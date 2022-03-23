package se.kth.iv1351.kelmdahl.startup;

import se.kth.iv1351.kelmdahl.controller.Controller;
import se.kth.iv1351.kelmdahl.intergration.SoundgoodDBException;
import se.kth.iv1351.kelmdahl.view.BlockingInterpreter;

public class Main {
    public static void main(String[] args) {
        try {
            new BlockingInterpreter(new Controller()).handleCmds();
        } catch (SoundgoodDBException e) {
            e.printStackTrace();
        }
    }
}