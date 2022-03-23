/*
    1
*/
CREATE VIEW public.lessons_per_month_in_year AS
SELECT 
	TO_CHAR(
    	TO_DATE (EXTRACT(MONTH FROM start_time)::text, 'MM'), 
		'Month'
    ) as month, 
	count(lesson.id) as number_of_lessons, 
	CASE
	  	WHEN ensemble_lesson.lesson_id IS NOT NULL
			THEN 'ensemble_lesson'
	  	WHEN ensemble_lesson.lesson_id IS NULL AND group_lesson.lesson_id IS NOT NULL
			THEN  'group_lesson'
	 	WHEN group_lesson.lesson_id IS NULL
	   		THEN 'individual_lesson'
	END type
FROM lesson
LEFT JOIN group_lesson ON group_lesson.lesson_id = lesson.id
LEFT JOIN ensemble_lesson ON ensemble_lesson.lesson_id = lesson.id
WHERE date_part('year', start_time) = '2021'
GROUP BY EXTRACT(MONTH FROM start_time), type;


/* 
    2
*/

CREATE VIEW public.lessons_per_month_in_year_avg AS
SELECT
	ROUND(CAST(count(id) AS NUMERIC) / 12, 2) as avg_number_of_lessons,
	CASE
	  	WHEN ensemble_lesson.lesson_id IS NOT NULL
			THEN 'ensemble_lesson'
	  	WHEN ensemble_lesson.lesson_id IS NULL AND group_lesson.lesson_id IS NOT NULL
			THEN  'group_lesson'
	 	WHEN group_lesson.lesson_id IS NULL
	   		THEN 'individual_lesson'
	END type
FROM lesson
LEFT JOIN group_lesson ON group_lesson.lesson_id = lesson.id
LEFT JOIN ensemble_lesson ON ensemble_lesson.lesson_id = lesson.id
WHERE date_part('year', start_time) = '2021'
GROUP BY type;



/*
    3
*/

CREATE VIEW public.overworked_instructors AS
SELECT employee_id, first_name, last_name, given_lessons FROM (
	SELECT COUNT(id) as given_lessons, instructor_id FROM lesson
	WHERE TO_CHAR(DATE(lesson.start_time), 'Month') = TO_CHAR(NOW(), 'Month')
	GROUP BY instructor_id
) as instructor_info
INNER JOIN (
	SELECT instructor.id, employee_id, first_name, last_name FROM instructor
	INNER JOIN person ON instructor.person_id=person.id
) as instructor_name ON instructor_name.id = instructor_info.instructor_id
WHERE given_lessons > 3
ORDER BY given_lessons desc;

/*
    4
*/

CREATE MATERIALIZED VIEW public.ensemble_lessons_next_week AS
SELECT id, genre, start_time,
	-- Generate messages depending on slots left
	CASE
	  	WHEN number_of_participants >= maximum_number_of_participants
			THEN 'Fully booked'
	  	WHEN number_of_participants >= maximum_number_of_participants - 2
			AND number_of_participants < maximum_number_of_participants 
			THEN  (maximum_number_of_participants - number_of_participants) || ' slots left'
	 	WHEN number_of_participants < maximum_number_of_participants - 2 
	   		THEN 'Many slots left'
	END status
FROM (
	-- Get number of participants and genre from ensemble_lesson and student_lesson tables
	SELECT COUNT(*) as number_of_participants, student_lesson.lesson_id, genre FROM ensemble_lesson
	INNER JOIN student_lesson ON ensemble_lesson.lesson_id=student_lesson.lesson_id
	GROUP BY student_lesson.lesson_id, genre
) as ensemble_lesson_participants
-- Join other tables to get time and participant info
INNER JOIN group_lesson ON group_lesson.lesson_id=ensemble_lesson_participants.lesson_id
INNER JOIN lesson ON lesson.id=group_lesson.lesson_id
-- Find in correct time period
WHERE start_time >= (date_trunc('week', NOW()) + INTERVAL '1week')
AND start_time < (date_trunc('week', NOW()) + INTERVAL '2week')
-- Sort accordingly
ORDER BY genre, start_time;

/*
    Historical
*/

INSERT INTO archive.archived_lesson (
    instructor, start_time, end_time, location, skill_level, type, cost, instruments, attending_students, name
) SELECT 
	instructor.employee_id as instructor, 
	start_time, end_time, 
	location, 
	level as skill_level, 
	CASE
	  	WHEN ensemble_lesson.lesson_id IS NOT NULL
			THEN 'ensemble'
	  	WHEN ensemble_lesson.lesson_id IS NULL AND group_lesson.lesson_id IS NOT NULL
			THEN  'group'
	 	ELSE 'individual'
	END type,
	CASE
		WHEN lesson.custom_cost IS NULL
			THEN pricing_scheme.cost
		ELSE lesson.custom_cost
	END cost,
	instrument_info.instruments,
	attending_students,
	name
FROM lesson
LEFT JOIN ensemble_lesson ON ensemble_lesson.lesson_id=lesson.ID
LEFT JOIN group_lesson ON group_lesson.lesson_id=lesson.ID
LEFT JOIN skill_level ON skill_level_id = skill_level.id
LEFT JOIN instructor ON lesson.instructor_id = instructor.id
LEFT JOIN pricing_scheme ON pricing_scheme.id = lesson.pricing_scheme_id
LEFT JOIN (
	SELECT lesson.id, ARRAY_AGG(student.sid) as attending_students FROM lesson
	LEFT JOIN student_lesson ON student_lesson.lesson_id=lesson.id
	LEFT JOIN student ON student_lesson.student_id = student.id
	GROUP BY lesson.id
) as student_info ON student_info.id = lesson.id
LEFT JOIN (
	SELECT
		lesson.id,
		ARRAY_AGG(instrument.name) as instruments
	FROM lesson
	LEFT JOIN ensemble_lesson_instruments ON ensemble_lesson_instruments.lesson_id = lesson.id
	LEFT JOIN instrument ON 
		ensemble_lesson_instruments.instrument_id = instrument.id 
		OR lesson.instrument_id = instrument.id
	GROUP BY lesson.id
) as instrument_info ON instrument_info.id = lesson.id
WHERE start_time = '2021-12-15 17:07:00' and end_time = '2021-12-07 18:02:00' -- Match start and end time or id or something else