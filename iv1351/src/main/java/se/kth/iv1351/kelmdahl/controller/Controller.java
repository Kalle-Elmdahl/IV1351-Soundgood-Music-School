package se.kth.iv1351.kelmdahl.controller;

import java.util.ArrayList;

import se.kth.iv1351.kelmdahl.intergration.SoundgoodDAO;
import se.kth.iv1351.kelmdahl.intergration.SoundgoodDBException;
import se.kth.iv1351.kelmdahl.model.Rental;
import se.kth.iv1351.kelmdahl.model.RentalException;
import se.kth.iv1351.kelmdahl.model.RentalInstrument;
import se.kth.iv1351.kelmdahl.model.RentalInstrumentDTO;
import se.kth.iv1351.kelmdahl.model.RentalInstrumentException;

public class Controller {
    private final SoundgoodDAO sgDAO;

    public Controller() throws SoundgoodDBException {
        sgDAO = new SoundgoodDAO();
    }

    public ArrayList<? extends RentalInstrumentDTO> listRentalInstruments(String instrument) throws RentalInstrumentException {
        String failMsg = "Could not list all rentals for query: " + instrument + ".";

        if(instrument == null) throw new RentalInstrumentException(failMsg);

        try {
            return sgDAO.getRentalInstruments(instrument);
        } catch (SoundgoodDBException e) {
            throw new RentalInstrumentException(failMsg);
        }
    }

    public void rentInstrument(String rentalInstrumentId, String sid) throws Exception {
        String failMsg = "Could not start rental for rentalinstrument id: " + rentalInstrumentId + " and student id: " + sid;

        if(rentalInstrumentId == null || sid == null) throw new RentalInstrumentException(failMsg);

        try {
            ArrayList<Rental> currentRentals = sgDAO.findRentalsByStudent(sid);
            
            int currentActiveRentals = 0;
            for (Rental rental : currentRentals) if(!rental.isEnded()) currentActiveRentals++;

            if(currentActiveRentals >= 2) throw new RentalInstrumentException("Limit for rentals reached");

            RentalInstrument instrument = sgDAO.findRentalInstrumentById(rentalInstrumentId, true);
            if(instrument == null) throw new RentalInstrumentException(failMsg);

            instrument.startNewRental();
            
            Rental rental = new Rental(sid, rentalInstrumentId);
            
            sgDAO.saveRentalInstrument(instrument, false);
            sgDAO.insertNewRental(rental, true);
        } catch (RentalInstrumentException e) {
            System.out.println(e.getMessage());
            throw new RentalInstrumentException(failMsg);
        } catch (SoundgoodDBException e) {
            System.out.println(e.getMessage());
            throw new RentalInstrumentException(failMsg);
        } catch (Exception e) {
            commitOngoingTransaction(failMsg);
            throw e;
        }
    }

    public void terminateRental(String rentalInstrumentId) throws Exception {
        String failMsg = "Could not terminate rental for rental instrument: " + rentalInstrumentId + ".";

        if(rentalInstrumentId == null) throw new RentalInstrumentException(failMsg);
        
        try {
            RentalInstrument instrument = sgDAO.findRentalInstrumentById(rentalInstrumentId, true);
            instrument.terminateRental();

            Rental rental = sgDAO.findRentalByInstrument(rentalInstrumentId);
            rental.end();

            sgDAO.saveRentalInstrument(instrument, false);
            sgDAO.saveRental(rental, true);
        } catch (RentalInstrumentException e) {
            throw new RentalInstrumentException(failMsg);
        } catch (RentalException e) {
            throw new RentalInstrumentException(failMsg);
        } catch (SoundgoodDBException e) {
            throw new RentalInstrumentException(failMsg);
        } catch (Exception e) {
            commitOngoingTransaction(failMsg);
            throw e;
        }
    }

    private void commitOngoingTransaction(String failMsg) throws RentalInstrumentException {
        try {
            sgDAO.commit();
        } catch (SoundgoodDBException bdbe) {
            throw new RentalInstrumentException(failMsg, bdbe);
        }
    }
    
}

