package se.kth.iv1351.kelmdahl.intergration;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;

import se.kth.iv1351.kelmdahl.model.Rental;
import se.kth.iv1351.kelmdahl.model.RentalInstrument;

public class SoundgoodDAO {
    private Connection conn;

    private PreparedStatement getRentalInstruments;
    private PreparedStatement insertRental;


    private PreparedStatement getRentalsByStudent;
    private PreparedStatement getRentalInstrument;
    private PreparedStatement getRentalInstrumentLocked;
    private PreparedStatement updateRentalInstrument;
    private PreparedStatement getRentalByInstrument;
    private PreparedStatement updateRental;



    /* private PreparedStatement getRentals;
    private PreparedStatement getRental;
    private PreparedStatement getRentalLocked;
    private PreparedStatement getRentalsByStudent;
    private PreparedStatement updateRental; */

    private static final String RENTAL_INSTRUMENT_TABLE_NAME = "RENTAL_INSTRUMENT";
    private static final String INSTRUMENT_TABLE_NAME = "INSTRUMENT";
    private static final String STUDENT_TABLE_NAME = "STUDENT";
    private static final String RENTAL_TABLE_NAME = "RENTAL";

    // rental instrument
    private static final String RENTAL_INSTRUMENT_ID_COL_NAME = "RENTAL_INSTRUMENT_ID"; 
    private static final String IS_AVAILABLE_COL_NAME = "IS_AVAILABLE"; 
    private static final String MONTHLY_COST_COL_NAME = "MONTHLY_COST"; 
    private static final String CONDITION_COL_NAME = "CONDITION";

    // student
    private static final String SID_COL_NAME = "SID";
    
    // instrument
    private static final String NAME_COL_NAME = "NAME"; 
    private static final String TYPE_COL_NAME = "TYPE";

    // rental
    private static final String START_DATE_COL_NAME = "START_DATE"; 
    private static final String END_DATE_COL_NAME = "END_DATE";
    private static final String IS_ENDED_COL_NAME = "IS_ENDED";


    private static final String RENTAL_INSTRUMENT_INSTRUMENT_FK = "instrument_id";
    private static final String RENTAL_RENTAL_INSTRUMENT_FK = "rental_instrument_id";
    private static final String RENTAL_STUDENT_FK = "student_id";

    public SoundgoodDAO() throws SoundgoodDBException {
        try {
            connectDB();
            prepareStatements();
        } catch (Exception e) {
            throw new SoundgoodDBException("Could not connect to datasource.", e);
        }
    }

    public RentalInstrument findRentalInstrumentById(String id, boolean shouldLock) throws SoundgoodDBException {

        String failureMsg = "Could not find specified instrument";
        ResultSet result = null;
        
        try {
            getRentalInstrument.setString(1, id);
            result = getRentalInstrument.executeQuery();
            
            
            if(shouldLock) {
                getRentalInstrumentLocked.setString(1, id);
                getRentalInstrumentLocked.executeQuery();
            } else conn.commit();

            if (result.next())
                return new RentalInstrument(
                    result.getString(RENTAL_INSTRUMENT_ID_COL_NAME),
                    result.getBoolean(IS_AVAILABLE_COL_NAME),
                    result.getDouble(MONTHLY_COST_COL_NAME),
                    result.getString(CONDITION_COL_NAME),
                    result.getString(NAME_COL_NAME),
                    result.getString(TYPE_COL_NAME)
                );
        } catch (Exception e) {
            handleException(failureMsg, e);
        } finally {
            closeResultSet(result, failureMsg);
        }
        return null;
    }

    public Rental findRentalByInstrument(String rentalInstrumentId) throws SoundgoodDBException {

        String failureMsg = "Could not find specified instrument";
        ResultSet result = null;
        
        try {
            getRentalByInstrument.setString(1, rentalInstrumentId);
            result = getRentalByInstrument.executeQuery();
            conn.commit();


            if (result.next())
                return new Rental(
                    result.getString(SID_COL_NAME),
                    result.getString(RENTAL_INSTRUMENT_ID_COL_NAME),
                    result.getTimestamp(START_DATE_COL_NAME),
                    result.getTimestamp(END_DATE_COL_NAME),
                    result.getBoolean(IS_ENDED_COL_NAME)
                );
        } catch (Exception e) {
            handleException(failureMsg, e);
        } finally {
            closeResultSet(result, failureMsg);
        }
        return null;
    }

    public ArrayList<Rental> findRentalsByStudent(String sid) throws SoundgoodDBException {
        String failureMsg = "Could not find rentals instruments for student id: " + sid;
        ResultSet result = null;
        try {
            ArrayList<Rental> r = new ArrayList<Rental>();
            
            getRentalsByStudent.setString(1, sid);
            result = getRentalsByStudent.executeQuery();

            while(result.next()) {
                r.add(new Rental(
                    result.getString(SID_COL_NAME),
                    result.getString(RENTAL_INSTRUMENT_ID_COL_NAME),
                    result.getTimestamp(START_DATE_COL_NAME),
                    result.getTimestamp(END_DATE_COL_NAME),
                    result.getBoolean(IS_ENDED_COL_NAME)
                ));
            }

            conn.commit();
            return r;
        } catch (SQLException sqle) {
            handleException(failureMsg, sqle);
        } finally {
            closeResultSet(result, failureMsg);
        }
        return null;
    }

    public ArrayList<RentalInstrument> getRentalInstruments(String instrumentName) throws SoundgoodDBException {
        ResultSet result = null;
        try {
            
            getRentalInstruments.setString(1, "%" + instrumentName + "%");
            result = getRentalInstruments.executeQuery();
            
            ArrayList<RentalInstrument> r = new ArrayList<RentalInstrument>();

            while(result.next()) {
                r.add(new RentalInstrument(
                    result.getString(RENTAL_INSTRUMENT_ID_COL_NAME),
                    result.getBoolean(IS_AVAILABLE_COL_NAME),
                    result.getDouble(MONTHLY_COST_COL_NAME),
                    result.getString(CONDITION_COL_NAME),
                    result.getString(NAME_COL_NAME),
                    result.getString(TYPE_COL_NAME)
                ));
            }
        
            conn.commit();
            return r;
        } catch (Exception e) {
            handleException("Failed to get all rentalInstruments", e);
        } finally {
            closeResultSet(result, "Failed to get all rentalInstruments");
        }
        return null;
    }

    public void saveRentalInstrument(RentalInstrument instrument, boolean shouldCommit) throws SoundgoodDBException {
        String failureMsg = "Could not update the rental instrument: " + instrument.getRentalInstrumentId();
        try {

            updateRentalInstrument.setBoolean(1, instrument.isAvailable());
            updateRentalInstrument.setDouble(2, instrument.getMonthlyCost());
            updateRentalInstrument.setString(3, instrument.getCondition());
            updateRentalInstrument.setString(4, instrument.getRentalInstrumentId());
            int updatedRows = updateRentalInstrument.executeUpdate();
            if (updatedRows < 1) {
                handleException(failureMsg, null);
            }
            if(shouldCommit) conn.commit();
        } catch (SQLException sqle) {
            handleException(failureMsg, sqle);
        }
    }

    public void saveRental(Rental rental, boolean shouldCommit) throws SoundgoodDBException {
        String failureMsg = "Could not update the rental instrument: " + rental;
        try {

            updateRental.setBoolean(1, rental.isEnded());
            updateRental.setTimestamp(2, rental.getStartDate());
            updateRental.setTimestamp(3, rental.getEndDate());
            updateRental.setString(4, rental.getRentalInstrumentId());
            int updatedRows = updateRental.executeUpdate();
            if (updatedRows < 1) {
                handleException(failureMsg, null);
            }
            if(shouldCommit) conn.commit();
        } catch (SQLException sqle) {
            handleException(failureMsg, sqle);
        }
    }

    public void insertNewRental(Rental rental, boolean shouldCommit) throws SoundgoodDBException {
        String failureMsg = "Could not update the rental instrument: " + rental;
        try {

            insertRental.setString(1, rental.getRentalInstrumentId());
            insertRental.setString(2, rental.getStudentId());
            insertRental.setTimestamp(3, rental.getStartDate());
            insertRental.setTimestamp(4, rental.getEndDate());
            insertRental.setBoolean(5, rental.isEnded());
            insertRental.execute();
            if(shouldCommit) conn.commit();
        } catch (SQLException sqle) {
            handleException(failureMsg, sqle);
        }
    }

    public void commit() throws SoundgoodDBException {
        try {
            conn.commit();
        } catch (SQLException e) {
            handleException("Failed to commit", e);
        }
    }

    private void connectDB() throws SQLException {

        String url = "jdbc:postgresql://localhost:5432/soundgood";
        Properties props = new Properties();
        props.setProperty("user", "postgres");
        conn = DriverManager.getConnection(url, props);
        conn.setAutoCommit(false);
    }

    public void closeResultSet(ResultSet r, String errMsg) throws SoundgoodDBException {
        try {
            r.close();
        } catch (Exception e) {
            throw new SoundgoodDBException(errMsg + " Could not close result set.", e);
        }
    }

    private void handleException(String failureMsg, Exception cause) throws SoundgoodDBException {
        String completeFailureMsg = failureMsg;
        try {
            conn.rollback();
        } catch (SQLException rollbackExc) {
            completeFailureMsg = completeFailureMsg + 
            ". Also failed to rollback transaction because of: " + rollbackExc.getMessage();
        }

        if (cause != null) {
            throw new SoundgoodDBException(failureMsg, cause);
        } else {
            throw new SoundgoodDBException(failureMsg);
        }
    }

    private void prepareStatements() throws SQLException {

        // RENTAL INSTRUMENT
        //GET
        getRentalInstruments = conn.prepareStatement(
            "SELECT " +
            RENTAL_INSTRUMENT_ID_COL_NAME + ", " + 
            IS_AVAILABLE_COL_NAME + ", " + 
            MONTHLY_COST_COL_NAME + ", " + 
            CONDITION_COL_NAME + ", " + 
            NAME_COL_NAME + ", " + 
            TYPE_COL_NAME + " " + 
            "FROM " + RENTAL_INSTRUMENT_TABLE_NAME + " " +
            "INNER JOIN " + INSTRUMENT_TABLE_NAME + " " +
            "ON " + INSTRUMENT_TABLE_NAME + ".id=" + RENTAL_INSTRUMENT_TABLE_NAME + "." + RENTAL_INSTRUMENT_INSTRUMENT_FK + " " +
            "WHERE " + IS_AVAILABLE_COL_NAME + "=true AND " + NAME_COL_NAME + " LIKE ?"
        );

        getRentalInstrument = conn.prepareStatement(
            "SELECT " +
            RENTAL_INSTRUMENT_ID_COL_NAME + ", " + 
            IS_AVAILABLE_COL_NAME + ", " + 
            MONTHLY_COST_COL_NAME + ", " + 
            CONDITION_COL_NAME + ", " + 
            NAME_COL_NAME + ", " + 
            TYPE_COL_NAME + " " + 
            "FROM " + RENTAL_INSTRUMENT_TABLE_NAME + " " +
            "INNER JOIN " + INSTRUMENT_TABLE_NAME + " " +
            "ON " + INSTRUMENT_TABLE_NAME + ".id=" + RENTAL_INSTRUMENT_TABLE_NAME + "." + RENTAL_INSTRUMENT_INSTRUMENT_FK + " " +
            "WHERE " + RENTAL_INSTRUMENT_ID_COL_NAME + " = ?"
        );

        getRentalInstrumentLocked = conn.prepareStatement(
            "SELECT * FROM " + RENTAL_INSTRUMENT_TABLE_NAME + " " + 
            "WHERE " + RENTAL_INSTRUMENT_ID_COL_NAME + " = ? FOR UPDATE"
        );

        // MODIFY
        updateRentalInstrument = conn.prepareStatement(
            "UPDATE " + RENTAL_INSTRUMENT_TABLE_NAME + " " +
            "SET " +
            IS_AVAILABLE_COL_NAME + "=?, " +
            MONTHLY_COST_COL_NAME + "=?, " +
            CONDITION_COL_NAME + "=? " +
            "WHERE " + RENTAL_INSTRUMENT_ID_COL_NAME + "=?"
        );

        // RENTAL
        // GET
        getRentalsByStudent = conn.prepareStatement(
            "SELECT " +
            SID_COL_NAME + ", " + 
            RENTAL_INSTRUMENT_TABLE_NAME + "." + RENTAL_RENTAL_INSTRUMENT_FK + ", " + 
            START_DATE_COL_NAME + ", " + 
            END_DATE_COL_NAME + ", " + 
            IS_ENDED_COL_NAME + " " + 
            "FROM " + STUDENT_TABLE_NAME + " " +
            "RIGHT JOIN " + RENTAL_TABLE_NAME + " " + 
            "ON " + RENTAL_TABLE_NAME + "." + RENTAL_STUDENT_FK + "=" + STUDENT_TABLE_NAME + ".id " + 
            "INNER JOIN " + RENTAL_INSTRUMENT_TABLE_NAME + " " +
            "ON " + RENTAL_INSTRUMENT_TABLE_NAME + ".id=" + RENTAL_TABLE_NAME + "." + RENTAL_RENTAL_INSTRUMENT_FK + " " +
            "WHERE " + SID_COL_NAME + " = ?"
        );

        getRentalByInstrument = conn.prepareStatement(
            "SELECT " +
            SID_COL_NAME + ", " + 
            RENTAL_INSTRUMENT_TABLE_NAME + "." + RENTAL_INSTRUMENT_ID_COL_NAME + ", " + 
            START_DATE_COL_NAME + ", " + 
            END_DATE_COL_NAME + ", " + 
            IS_ENDED_COL_NAME + " " + 
            "FROM " + RENTAL_TABLE_NAME + " " +
            "INNER JOIN " + RENTAL_INSTRUMENT_TABLE_NAME + " " + 
            "ON " + RENTAL_TABLE_NAME + "." + RENTAL_RENTAL_INSTRUMENT_FK + "=" + RENTAL_INSTRUMENT_TABLE_NAME + ".id" + " " +
            "INNER JOIN " + STUDENT_TABLE_NAME + " ON " + STUDENT_TABLE_NAME + ".id=" + RENTAL_STUDENT_FK + " " +
            "WHERE " + IS_ENDED_COL_NAME + "=false AND " + RENTAL_INSTRUMENT_TABLE_NAME + "." + RENTAL_INSTRUMENT_ID_COL_NAME + "=?"
        );

        // MODIFY

        updateRental = conn.prepareStatement(
            "UPDATE " + RENTAL_TABLE_NAME + " " +
            "SET " +
            IS_ENDED_COL_NAME + "=?, " +
            START_DATE_COL_NAME + "=?, " +
            END_DATE_COL_NAME + "=? " +
            "WHERE " + RENTAL_RENTAL_INSTRUMENT_FK + "=" +
            "(SELECT id from " + RENTAL_INSTRUMENT_TABLE_NAME + " WHERE " + RENTAL_INSTRUMENT_ID_COL_NAME + "=?) " + 
            "AND " + IS_ENDED_COL_NAME + "=false"
        );

        insertRental = conn.prepareStatement(
            "INSERT INTO " + 
            RENTAL_TABLE_NAME + 
            "(" + 
                RENTAL_RENTAL_INSTRUMENT_FK + ", " + 
                RENTAL_STUDENT_FK + ", " + 
                START_DATE_COL_NAME + ", " + 
                END_DATE_COL_NAME + ", " +  
                IS_ENDED_COL_NAME +
            ") " + 
            "VALUES" + 
            "(" + 
                "(SELECT id from " + RENTAL_INSTRUMENT_TABLE_NAME + " WHERE " + RENTAL_INSTRUMENT_ID_COL_NAME + "= ? )," + 
                "(SELECT id from " + STUDENT_TABLE_NAME + " WHERE " + SID_COL_NAME + "= ? )," + 
                "?, " + 
                "?, " + 
                "?" + 
            ");"
        );
    }
}
