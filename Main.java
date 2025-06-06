import connection.Company;

import java.sql.ResultSet;

public class Main {
    public static void main(String[] args) {
        Company c = new Company();
        c.init();
        c.listEMP();
        c.listMetaData();
    }
}
