package se.kth.iv1351.kelmdahl.model;

import java.sql.Timestamp;

public interface RentalDTO {

    public String getStudentId();

    public String getRentalInstrumentId();
    
    public Timestamp getStartDate();

    public Timestamp getEndDate();

    public boolean isEnded();
}
