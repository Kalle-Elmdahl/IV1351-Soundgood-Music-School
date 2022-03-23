package se.kth.iv1351.kelmdahl.view;

import java.util.ArrayList;
import java.util.Scanner;

import se.kth.iv1351.kelmdahl.controller.Controller;
import se.kth.iv1351.kelmdahl.model.RentalInstrumentDTO;

/**
 * Reads and interprets user commands. This command interpreter is blocking, the user
 * interface does not react to user input while a command is being executed.
 */
public class BlockingInterpreter {
    private static final String PROMPT = "$ ";
    private final Scanner console = new Scanner(System.in);
    private Controller ctrl;
    private boolean keepReceivingCmds = false;

    /**
     * Creates a new instance that will use the specified controller for all operations.
     * 
     * @param ctrl The controller used by this instance.
     */
    public BlockingInterpreter(Controller ctrl) {
        this.ctrl = ctrl;
    }

    /**
     * Stops the commend interpreter.
     */
    public void stop() {
        keepReceivingCmds = false;
    }

    /**
     * Interprets and performs user commands. This method will not return until the
     * UI has been stopped. The UI is stopped either when the user gives the
     * "quit" command, or when the method <code>stop()</code> is called.
     */
    public void handleCmds() {
        keepReceivingCmds = true;
        while (keepReceivingCmds) {
            try {
                CmdLine cmdLine = new CmdLine(readNextLine());
                switch (cmdLine.getCmd()) {
                    case HELP:
                        for (Command command : Command.values()) {
                            if (command == Command.ILLEGAL_COMMAND) {
                                continue;
                            }
                            System.out.println(command.toString().toLowerCase() + "\t\t" + command.label);
                        }
                        break;
                    case LIST:
                        String instrumentKind = cmdLine.getParameter(0);
                        ArrayList<? extends RentalInstrumentDTO> instruments = ctrl.listRentalInstruments(instrumentKind);
                        if(instruments.size() == 0) {
                            System.out.println("No matches");
                        } else {
                            for (RentalInstrumentDTO instrument : instruments) {
                                System.out.println(instrument);
                            }
                        }
                        break;
                    case RENT:
                        ctrl.rentInstrument(
                            cmdLine.getParameter(0),
                            cmdLine.getParameter(1)
                        );
                        System.out.println("Success!");
                        break;
                    case STOP:
                        ctrl.terminateRental(
                            cmdLine.getParameter(0)
                        );
                        System.out.println("Success!");
                        break;
                    default:
                        System.out.println("illegal command");
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
    }

    private String readNextLine() {
        System.out.print(PROMPT);
        return console.nextLine();
    }
}