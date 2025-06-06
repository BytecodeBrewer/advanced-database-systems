package connection;

import java.beans.Statement;
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
    }
}