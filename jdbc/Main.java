import connection.Company;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Company c = new Company();
        c.init();

        Scanner scanner = new Scanner(System.in);
        boolean running = true;

        while (running) {
            System.out.println("\n==== Menü ====");
            System.out.println("1 - Alle Angestellten anzeigen");
            System.out.println("2 - Metadaten anzeigen");
            System.out.println("3 - Angestelltennamen ändern");
            System.out.println("0 - Beenden");
            System.out.print("Deine Wahl: ");
            
            String input = scanner.nextLine();

            switch (input) {
                case "1":
                    c.listEMP();
                    break;
                case "2":
                    c.listMetaData();
                    break;
                case "3":
                    c.updateEMP();
                    break;
                case "0":
                    running = false;
                    break;
                default:
                    System.out.println("Ungültige Eingabe.");
            }
        }

        System.out.println("Programm beendet.");
        scanner.close();
    }
}
