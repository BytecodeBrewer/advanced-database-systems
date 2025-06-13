package connection;

import java.util.Scanner;
import java.sql.*;

public class Company {
    private Connection conn;

    //Aufgabe 1
    public void init()
    {
        try{
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@141.57.9.192:1521:imora19c","C##DBA25012","oracle");
    	
            System.out.println("Verbindung erfolgreich.");
        } catch (Exception e)
        {
            System.out.println("Verbindung nicht erfolgreich.");
        }
    }

    public void listEMP()
    {
        if (conn == null) {
        System.out.println("Keine Verbindung zur Datenbank.");
        return;
        }
        try {
            String sql = "SELECT empno, ename, job, sal FROM emp";
            Statement stmt = conn.createStatement();
            ResultSet rset = stmt.executeQuery(sql);
    
            System.out.println("\n--- Angestellte ---");
            while (rset.next()) {
                int empno = rset.getInt("empno");
                String ename = rset.getString("ename");
                String job = rset.getString("job");
                double sal = rset.getDouble("sal");
    
                System.out.printf("%d | %s | %s | %.2f%n", empno, ename, job, sal);
            }
    
            rset.close();
            stmt.close();
    
        } catch (SQLException e) {
            System.out.println("Fehler beim SELECT.");
            e.printStackTrace();
        }
    }

    public void listMetaData()
    {
        if (conn == null) {
            System.out.println("Keine Verbindung zur Datenbank.");
            return;
        }
    
        try {
            String sql = "SELECT empno, ename, job, sal FROM emp";
            Statement stmt = conn.createStatement();
            ResultSet rset = stmt.executeQuery(sql);
            ResultSetMetaData meta = rset.getMetaData();
    
            System.out.println("\n--- Metadaten der Spalten ---");
            for (int i = 1; i <= meta.getColumnCount(); i++) {
                String name = meta.getColumnName(i);
                String typ = meta.getColumnTypeName(i);
                int laenge = meta.getPrecision(i);
                int scale = meta.getScale(i);
    
                System.out.printf("Spalte %d: %s | Typ: %s | Länge: %d | Nachkommastellen: %d%n",
                        i, name, typ, laenge, scale);
            }
    
            rset.close();
            stmt.close();
    
        } catch (SQLException e) {
            System.out.println("Fehler beim Lesen der Metadaten.");
            e.printStackTrace();
        }
    }

    public void updateEMP() {
        if (conn == null) {
            System.out.println("Keine Verbindung zur Datenbank.");
            return;
        }

        Scanner scanner = new Scanner(System.in);
        try {
            System.out.print("\nGib die Angestelltennummer ein: ");
            int empno = scanner.nextInt();
            scanner.nextLine(); // Rest der Zeile entfernen

            System.out.print("Neuer Name: ");
            String neuerName = scanner.nextLine();

            String sql = "UPDATE emp SET ename = ? WHERE empno = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, neuerName);
            pstmt.setInt(2, empno);

            int zeilen = pstmt.executeUpdate();
            if (zeilen > 0) {
                System.out.println("Datensatz wurde erfolgreich geändert.");
            } else {
                System.out.println("Keine Änderung – möglicherweise falsche Personalnummer.");
            }

            pstmt.close();
        } catch (SQLException e) {
            System.out.println("Fehler beim UPDATE.");
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Ungültige Eingabe.");
            e.printStackTrace();
        }
    }

}