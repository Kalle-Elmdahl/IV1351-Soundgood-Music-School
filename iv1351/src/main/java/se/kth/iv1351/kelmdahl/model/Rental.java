package se.kth.iv1351.kelmdahl.model;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;

public class Rental implements RentalDTO {
    private String studentId;
    private String rentalInstrumentId;
    private Timestamp startDate;
    private Timestamp endDate;
    private boolean isEnded;

    public Rental(String studentId, String rentalInstrumentId, Timestamp startDate, Timestamp endDate, boolean isEnded) {
        this.studentId = studentId;
        this.rentalInstrumentId = rentalInstrumentId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isEnded = isEnded;
    }

    public Rental(String studentId, String rentalInstrumentId) {
        this.studentId = studentId;
        this.rentalInstrumentId = rentalInstrumentId;
        this.isEnded = false;

        Calendar c = Calendar.getInstance();
        c.setTime(new Date(System.currentTimeMillis()));
        startDate = new Timestamp(c.getTimeInMillis());
        c.add(Calendar.MONTH, 1);
        endDate = new Timestamp(c.getTimeInMillis());
    }

    public String getStudentId() {
        return studentId;
    }

    public String getRentalInstrumentId() {
        return rentalInstrumentId;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public boolean isEnded() {
        return isEnded;
    }

    public void end() throws RentalException {
        if(isEnded) throw new RentalException("rental is already ended");
        isEnded = true;
    }

    public String toString() {
        return "Rental for " + rentalInstrumentId + 
        " and student " + studentId + 
        ", from " + startDate + " to " + endDate + " is ended: " + isEnded;
    }
    
}
