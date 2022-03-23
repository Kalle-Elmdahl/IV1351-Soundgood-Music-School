--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

-- Started on 2021-11-30 13:04:21 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

set datestyle to 'ISO, YMD';

--
-- TOC entry 5 (class 2615 OID 26368)
-- Name: archive; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA archive;


ALTER SCHEMA archive OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 237 (class 1259 OID 26374)
-- Name: archived_lesson; Type: TABLE; Schema: archive; Owner: postgres
--

CREATE TABLE archive.archived_lesson (
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    location character varying(100),
    skill_level character varying(20),
    type text,
    cost double precision,
    instructor character varying(100),
    instruments character varying(100)[],
    attending_students character varying(100)[],
    name character varying(500),
    id integer NOT NULL
);


ALTER TABLE archive.archived_lesson OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 26381)
-- Name: archived_lesson_id_seq; Type: SEQUENCE; Schema: archive; Owner: postgres
--

ALTER TABLE archive.archived_lesson ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME archive.archived_lesson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 16511)
-- Name: ensemble_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ensemble_lesson (
    lesson_id integer NOT NULL,
    genre character varying(100)
);


ALTER TABLE public.ensemble_lesson OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16516)
-- Name: ensemble_lesson_instruments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ensemble_lesson_instruments (
    lesson_id integer NOT NULL,
    instrument_id integer NOT NULL
);


ALTER TABLE public.ensemble_lesson_instruments OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16506)
-- Name: group_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_lesson (
    lesson_id integer NOT NULL,
    minimum_number_of_participants integer,
    maximum_number_of_participants integer
);


ALTER TABLE public.group_lesson OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16475)
-- Name: instructor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor (
    id integer NOT NULL,
    employee_id character varying(100) NOT NULL,
    person_id integer NOT NULL,
    can_teach_ensemble boolean NOT NULL
);


ALTER TABLE public.instructor OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16733)
-- Name: instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.instructor ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instructor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 16482)
-- Name: instructor_instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_instrument (
    instructor_id integer NOT NULL,
    instrument_id integer NOT NULL
);


ALTER TABLE public.instructor_instrument OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16434)
-- Name: instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(100)
);


ALTER TABLE public.instrument OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16734)
-- Name: instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.instrument ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instrument_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 16487)
-- Name: lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson (
    id integer NOT NULL,
    instructor_id integer,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    location character varying(100),
    pricing_scheme_id integer,
    custom_cost double precision,
    description character varying(2000),
    name character varying(500),
    skill_level_id integer,
    instrument_id integer
);


ALTER TABLE public.lesson OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16735)
-- Name: lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.lesson ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.lesson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 211 (class 1259 OID 16439)
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    person_number character varying(20) NOT NULL,
    email character varying(100),
    street_address character varying(500) NOT NULL,
    zip_code character varying(10) NOT NULL,
    area character varying(100) NOT NULL
);


ALTER TABLE public.person OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16736)
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.person ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 212 (class 1259 OID 16448)
-- Name: phone_number; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phone_number (
    id integer NOT NULL,
    person_id integer NOT NULL,
    phone_number character varying(20) NOT NULL,
    type character varying(100)
);


ALTER TABLE public.phone_number OWNER TO postgres;

ALTER TABLE public.phone_number ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.phone_number_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

--
-- TOC entry 213 (class 1259 OID 16453)
-- Name: pricing_scheme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pricing_scheme (
    id integer NOT NULL,
    lesson_type character varying(100) NOT NULL,
    cost double precision NOT NULL
);


ALTER TABLE public.pricing_scheme OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16737)
-- Name: pricing_scheme_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pricing_scheme ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pricing_scheme_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 16494)
-- Name: rental_instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rental_instrument (
    id integer NOT NULL,
    rental_instrument_id character varying(10) NOT NULL,
    is_available boolean,
    monthly_cost double precision,
    condition character varying(100),
    instrument_id integer NOT NULL
);


ALTER TABLE public.rental_instrument OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16738)
-- Name: rental_instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.rental_instrument ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.rental_instrument_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.rental (
    id integer NOT NULL,
    student_id INT NOT NULL,
    rental_instrument_id INT NOT NULL,
    end_date TIMESTAMP NOT NULL,
    start_date TIMESTAMP NOT NULL,
    is_ended BOOLEAN NOT NULL
);


ALTER TABLE public.rental OWNER TO postgres;


ALTER TABLE public.rental ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.rental_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



--
-- TOC entry 214 (class 1259 OID 16458)
-- Name: skill_level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skill_level (
    id integer NOT NULL,
    level character varying(20) NOT NULL
);


ALTER TABLE public.skill_level OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16739)
-- Name: skill_level_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.skill_level ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.skill_level_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 215 (class 1259 OID 16463)
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    id integer NOT NULL,
    sid character varying(100) NOT NULL,
    person_id integer NOT NULL,
    sibling_id integer
);


ALTER TABLE public.student OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16731)
-- Name: student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.student ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 16470)
-- Name: student_instrument_skill_level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_instrument_skill_level (
    skill_level_id integer NOT NULL,
    instrument_id integer NOT NULL,
    student_id integer NOT NULL
);


ALTER TABLE public.student_instrument_skill_level OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16501)
-- Name: student_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_lesson (
    lesson_id integer NOT NULL,
    student_id integer NOT NULL
);


ALTER TABLE public.student_lesson OWNER TO postgres;

--
-- TOC entry 3546 (class 2606 OID 26383)
-- Name: archived_lesson archived_lesson_pkey; Type: CONSTRAINT; Schema: archive; Owner: postgres
--

ALTER TABLE ONLY archive.archived_lesson
    ADD CONSTRAINT archived_lesson_pkey PRIMARY KEY (id);

--
-- TOC entry 3520 (class 2606 OID 16479)
-- Name: instructor instructor_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_employee_id_key UNIQUE (employee_id);


--
-- TOC entry 3504 (class 2606 OID 16445)
-- Name: person person_person_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_person_number_key UNIQUE (person_number);


--
-- TOC entry 3536 (class 2606 OID 16515)
-- Name: ensemble_lesson pk_ensemble_lesson; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble_lesson
    ADD CONSTRAINT pk_ensemble_lesson PRIMARY KEY (lesson_id);


--
-- TOC entry 3538 (class 2606 OID 16520)
-- Name: ensemble_lesson_instruments pk_ensemble_lesson_instruments; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble_lesson_instruments
    ADD CONSTRAINT pk_ensemble_lesson_instruments PRIMARY KEY (lesson_id, instrument_id);


--
-- TOC entry 3534 (class 2606 OID 16510)
-- Name: group_lesson pk_group_lesson; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT pk_group_lesson PRIMARY KEY (lesson_id);


--
-- TOC entry 3522 (class 2606 OID 16481)
-- Name: instructor pk_instructor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT pk_instructor PRIMARY KEY (id);


--
-- TOC entry 3524 (class 2606 OID 16486)
-- Name: instructor_instrument pk_instructor_instrument; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_instrument
    ADD CONSTRAINT pk_instructor_instrument PRIMARY KEY (instructor_id, instrument_id);


--
-- TOC entry 3502 (class 2606 OID 16438)
-- Name: instrument pk_instrument; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT pk_instrument PRIMARY KEY (id);


--
-- TOC entry 3526 (class 2606 OID 16493)
-- Name: lesson pk_lesson; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT pk_lesson PRIMARY KEY (id);


--
-- TOC entry 3506 (class 2606 OID 16447)
-- Name: person pk_person; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT pk_person PRIMARY KEY (id);


--
-- TOC entry 3508 (class 2606 OID 16452)
-- Name: phone_number pk_phone_number; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone_number
    ADD CONSTRAINT pk_phone_number PRIMARY KEY (id);


--
-- TOC entry 3510 (class 2606 OID 16457)
-- Name: pricing_scheme pk_pricing_scheme; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricing_scheme
    ADD CONSTRAINT pk_pricing_scheme PRIMARY KEY (id);


--
-- TOC entry 3528 (class 2606 OID 16500)
-- Name: rental_instrument pk_rental_instrument; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_instrument
    ADD CONSTRAINT pk_rental_instrument PRIMARY KEY (id);


ALTER TABLE ONLY public.rental 
    ADD CONSTRAINT PK_rental PRIMARY KEY (id);


--
-- TOC entry 3512 (class 2606 OID 16462)
-- Name: skill_level pk_skill_level; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skill_level
    ADD CONSTRAINT pk_skill_level PRIMARY KEY (id);


--
-- TOC entry 3514 (class 2606 OID 16469)
-- Name: student pk_student; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT pk_student PRIMARY KEY (id);


--
-- TOC entry 3518 (class 2606 OID 16474)
-- Name: student_instrument_skill_level pk_student_instrument_skill_level; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_instrument_skill_level
    ADD CONSTRAINT pk_student_instrument_skill_level PRIMARY KEY (skill_level_id, instrument_id, student_id);


--
-- TOC entry 3532 (class 2606 OID 16505)
-- Name: student_lesson pk_student_lesson; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT pk_student_lesson PRIMARY KEY (lesson_id, student_id);


--
-- TOC entry 3530 (class 2606 OID 16498)
-- Name: rental_instrument rental_instrument_rental_instrument_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_instrument
    ADD CONSTRAINT rental_instrument_rental_instrument_id_key UNIQUE (rental_instrument_id);


--
-- TOC entry 3516 (class 2606 OID 16467)
-- Name: student student_sid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_sid_key UNIQUE (sid);


--
-- TOC entry 3557 (class 2606 OID 16636)
-- Name: ensemble_lesson fk_ensemble_lesson_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble_lesson
    ADD CONSTRAINT fk_ensemble_lesson_0 FOREIGN KEY (lesson_id) REFERENCES public.group_lesson(lesson_id) ON DELETE CASCADE;


--
-- TOC entry 3558 (class 2606 OID 16641)
-- Name: ensemble_lesson_instruments fk_ensemble_lesson_instruments_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble_lesson_instruments
    ADD CONSTRAINT fk_ensemble_lesson_instruments_0 FOREIGN KEY (lesson_id) REFERENCES public.ensemble_lesson(lesson_id) ON DELETE CASCADE;


--
-- TOC entry 3559 (class 2606 OID 16646)
-- Name: ensemble_lesson_instruments fk_ensemble_lesson_instruments_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble_lesson_instruments
    ADD CONSTRAINT fk_ensemble_lesson_instruments_1 FOREIGN KEY (instrument_id) REFERENCES public.instrument(id) ON DELETE RESTRICT;


--
-- TOC entry 3556 (class 2606 OID 16651)
-- Name: group_lesson fk_group_lesson_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT fk_group_lesson_0 FOREIGN KEY (lesson_id) REFERENCES public.lesson(id) ON DELETE CASCADE;


--
-- TOC entry 3545 (class 2606 OID 16656)
-- Name: instructor fk_instructor_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT fk_instructor_0 FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- TOC entry 3546 (class 2606 OID 16661)
-- Name: instructor_instrument fk_instructor_instrument_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_instrument
    ADD CONSTRAINT fk_instructor_instrument_0 FOREIGN KEY (instructor_id) REFERENCES public.instructor(id) ON DELETE CASCADE;


--
-- TOC entry 3547 (class 2606 OID 16666)
-- Name: instructor_instrument fk_instructor_instrument_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_instrument
    ADD CONSTRAINT fk_instructor_instrument_1 FOREIGN KEY (instrument_id) REFERENCES public.instrument(id) ON DELETE CASCADE;


--
-- TOC entry 3550 (class 2606 OID 16681)
-- Name: lesson fk_lesson_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT fk_lesson_0 FOREIGN KEY (instructor_id) REFERENCES public.instructor(id) ON DELETE RESTRICT;


--
-- TOC entry 3548 (class 2606 OID 16671)
-- Name: lesson fk_lesson_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT fk_lesson_1 FOREIGN KEY (pricing_scheme_id) REFERENCES public.pricing_scheme(id) ON DELETE RESTRICT;


--
-- TOC entry 3549 (class 2606 OID 16676)
-- Name: lesson fk_lesson_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT fk_lesson_2 FOREIGN KEY (skill_level_id) REFERENCES public.skill_level(id) ON DELETE RESTRICT;


--
-- TOC entry 3551 (class 2606 OID 16686)
-- Name: lesson fk_lesson_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT fk_lesson_3 FOREIGN KEY (instrument_id) REFERENCES public.instrument(id) ON DELETE RESTRICT;


--
-- TOC entry 3539 (class 2606 OID 16691)
-- Name: phone_number fk_phone_number_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone_number
    ADD CONSTRAINT fk_phone_number_0 FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- TOC entry 3553 (class 2606 OID 16701)
-- Name: rental_instrument fk_rental_instrument_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_instrument
    ADD CONSTRAINT fk_rental_instrument_1 FOREIGN KEY (instrument_id) REFERENCES public.instrument(id) ON DELETE RESTRICT;



ALTER TABLE ONLY public.rental
    ADD CONSTRAINT fk_rental_1 FOREIGN KEY (student_id) REFERENCES public.student(id) ON DELETE SET NULL;


ALTER TABLE ONLY public.rental
    ADD CONSTRAINT fk_rental_2 FOREIGN KEY (rental_instrument_id) REFERENCES public.rental_instrument(id) ON DELETE SET NULL;


--
-- TOC entry 3540 (class 2606 OID 16626)
-- Name: student fk_student_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT fk_student_0 FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- TOC entry 3542 (class 2606 OID 16706)
-- Name: student_instrument_skill_level fk_student_instrument_skill_level_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_instrument_skill_level
    ADD CONSTRAINT fk_student_instrument_skill_level_0 FOREIGN KEY (skill_level_id) REFERENCES public.skill_level(id) ON DELETE CASCADE;


--
-- TOC entry 3543 (class 2606 OID 16711)
-- Name: student_instrument_skill_level fk_student_instrument_skill_level_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_instrument_skill_level
    ADD CONSTRAINT fk_student_instrument_skill_level_1 FOREIGN KEY (instrument_id) REFERENCES public.instrument(id) ON DELETE CASCADE;


--
-- TOC entry 3544 (class 2606 OID 16716)
-- Name: student_instrument_skill_level fk_student_instrument_skill_level_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_instrument_skill_level
    ADD CONSTRAINT fk_student_instrument_skill_level_2 FOREIGN KEY (student_id) REFERENCES public.student(id) ON DELETE CASCADE;


--
-- TOC entry 3554 (class 2606 OID 16721)
-- Name: student_lesson fk_student_lesson_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT fk_student_lesson_0 FOREIGN KEY (lesson_id) REFERENCES public.lesson(id) ON DELETE CASCADE;


--
-- TOC entry 3555 (class 2606 OID 16726)
-- Name: student_lesson fk_student_lesson_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT fk_student_lesson_1 FOREIGN KEY (student_id) REFERENCES public.student(id) ON DELETE CASCADE;


-- Completed on 2021-11-30 13:04:21 CET

--
-- PostgreSQL database dump complete
--

