package se.kth.iv1351.kelmdahl.view;

public enum Command {
    /**
     * List all instruments of a certain kind
     */
    LIST("search_term\t\t\tList available instruments for renting"),
    /**
     * Rent an instrument
     */
    RENT("rental_instrument_id student_id\tStart a new rental"),
    /**
     * Terminate a rental
     */
    STOP("rental_instrument_id\t\tClear an ongoing rental for an instrument"),
    /**
     * Lists all commands.
     */
    HELP("-\t\t\t\tShow this list"),
    /**
     * Leave the chat application.
     */
    QUIT("-\t\t\t\tExit the program"),
    /**
     * None of the valid commands above was specified.
     */
    ILLEGAL_COMMAND("");

    public final String label;

    private Command(String label) {
        this.label = label;
    }
}
