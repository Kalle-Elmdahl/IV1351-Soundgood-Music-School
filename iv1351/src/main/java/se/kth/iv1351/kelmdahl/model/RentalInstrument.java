package se.kth.iv1351.kelmdahl.model;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;

public class RentalInstrument implements RentalInstrumentDTO {
    private String rentalInstrumentId;
    private boolean isAvailable;
    private double monthlyCost;
    private String condition;
    private String name;
    private String type;

    public RentalInstrument(
        String rentalInstrumentId,
        boolean isAvailable, 
        double monthlyCost, 
        String condition, 
        String name, 
        String type
    ) {
        this.rentalInstrumentId = rentalInstrumentId;
        this.isAvailable = isAvailable;
        this.monthlyCost = monthlyCost;
        this.condition = condition;
        this.name = name;
        this.type = type;
    }

    public String getRentalInstrumentId() {
        return rentalInstrumentId;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public double getMonthlyCost() {
        return monthlyCost;
    }

    public String getCondition() {
        return condition;
    }

    public String getName() {
        return name;
    }

    public String getType() {
        return type;
    }

    public void startNewRental() throws RentalInstrumentException {
        if(!isAvailable) throw new RentalInstrumentException("Instrument is not available");
        isAvailable = false;
    }

    public void terminateRental() throws RentalInstrumentException {
        if(isAvailable) throw new RentalInstrumentException("Cannot terminate rental when it is not rented");
        isAvailable = true;
    }

    public String toString() {
        return rentalInstrumentId + ", " + name + " in " + condition + " condition - $" + monthlyCost + (isAvailable ? ", " : ", not ") + "available";
    }
}
