-- 1. Keyspace anlegen
CREATE KEYSPACE IF NOT EXISTS UEBUNG11
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
USE UEBUNG11;

-- 2. Tabelle mit STATIC titel-Spalte anlegen
DROP TABLE IF EXISTS ARTIKEL;
CREATE TABLE IF NOT EXISTS ARTIKEL (
  id int,
  datum timestamp,
  titel text STATIC,
  art text,
  text text,
  version text,
  autor text,
  status text,
  schlagworte set<text>,
  PRIMARY KEY (id, datum)
);

-- 3. Datensätze einfügen
INSERT INTO ARTIKEL (id, datum, titel, art, text, version)
VALUES (1, '2021-12-10 10:34:00+0000', 'Workshop on Scientific Writing', 'Seite', 'Grundlagen ...', 'Vorschau');

INSERT INTO ARTIKEL (id, datum, titel, art, text, version)
VALUES (1, '2021-12-10 11:03:00+0000', 'Workshop on Scientific Writing', 'Seite', 'Grundlagen ...', 'Arbeitskopie');

INSERT INTO ARTIKEL (id, datum, titel, art, text, version)
VALUES (2, '2021-12-10 10:29:00+0000', 'wsw_programm.pdf', 'Datei', null, null);

-- 4. Weitere Spalten ergänzen und Datensatz für ID 3 einfügen
INSERT INTO ARTIKEL (id, datum, titel, art, autor, status, text)
VALUES (3, '2021-09-15 13:07:00+0000', 'Stundenplan WS2021', 'Nachricht', 'Meinhold', 'public', 'Anderungen ...');

-- 5. Datenänderung für Autor/Status
UPDATE ARTIKEL SET autor='riechert', status='privat'
WHERE id=1 AND datum='2021-12-10 10:34:00+0000';

UPDATE ARTIKEL SET autor='Admin', status='public'
WHERE id=1 AND datum='2021-12-10 11:03:00+0000';

-- 6. Collections (Schlagworte) hinzufügen
UPDATE ARTIKEL SET schlagworte = {'Workshop', 'Schreiben', 'Riechert'}
WHERE id=1 AND datum='2021-12-10 11:03:00+0000';

UPDATE ARTIKEL SET schlagworte = schlagworte - {'Riechert'}
WHERE id=1 AND datum='2021-12-10 11:03:00+0000';

-- 7. Abfragen

-- a. Verschiedene Artikel-IDs
SELECT DISTINCT id FROM ARTIKEL;

-- b. Anzahl Versionen von Artikel 1
SELECT COUNT(*) FROM ARTIKEL WHERE id=1;

-- c. Alle verschiedenen Titel
SELECT DISTINCT titel FROM ARTIKEL;
-- Es funktionier leider nicht, trotz einer STATIC Spalte.

-- d. Alle Versionen des Artikels 1
SELECT * FROM ARTIKEL WHERE id=1;

-- e. Alle Artikel von Autor RIECHERT
SELECT * FROM ARTIKEL WHERE autor='riechert' ALLOW FILTERING;

-- f. Artikel mit ID 2 oder 3
SELECT * FROM ARTIKEL WHERE id IN (2,3);

/*
## Umfassendes Cheatblatt für deine DB-Prüfung (mit vielen Beispielen & Fallstricken)

---

### 1. PL/SQL: Stored Procedures & Parametermodi

#### Stored Procedure

* **Definition**: Benannter, persistent gespeicherter PL/SQL-Block im Schema, aufrufbar via SQL\*Plus, APEX oder JDBC.
* **Aufbau**:

  ```sql
  CREATE OR REPLACE PROCEDURE transfer_funds(
    sender_id     IN  NUMBER,
    recipient_id  IN  NUMBER,
    amount        IN  NUMBER
  )
  IS
    insufficient_balance EXCEPTION;
  BEGIN
    -- Prüfen
    IF (SELECT balance FROM accounts WHERE id = sender_id) < amount THEN
      RAISE insufficient_balance;
    END IF;
    -- Überweisung
    UPDATE accounts SET balance = balance - amount WHERE id = sender_id;
    UPDATE accounts SET balance = balance + amount WHERE id = recipient_id;
  EXCEPTION
    WHEN insufficient_balance THEN
      RAISE_APPLICATION_ERROR(-20001, 'Nicht genügend Kontostand');
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20002, 'Konto nicht gefunden');
  END transfer_funds;
  /
  ```
* **Falsche Parameterreihenfolge**

  * Aufruf ohne benannte Notation: `EXEC transfer_funds(2,1,100);`

    * Problem: `sender_id=2, recipient_id=1, amount=100`
    * Falsche Reihenfolge führt zu ungewolltem Empfänger oder Sender.
  * **Lösung**: Benannte Notation:

    ```sql
    EXEC transfer_funds(
      sender_id    => 1,
      recipient_id => 2,
      amount       => 100
    );
    ```
  * **Best Practice**: Immer `parameter_name => value` verwenden.

#### Parametermodi

| Modus  | Beschreibung                             | Beispiel                  | Fehlerquelle                                 |
| ------ | ---------------------------------------- | ------------------------- | -------------------------------------------- |
| IN     | Nur Eingang, unveränderbar im Block      | `p(v IN NUMBER)`          | OUT-Parameter uninitialisiert nutzen         |
| OUT    | Rückgabe, initial NULL, gefüllt im Block | `p(v OUT VARCHAR2)`       | OUT auf Literale oder konstante Werte setzen |
| IN OUT | Kombination aus IN und OUT               | `p(v IN OUT CUSTOM_TYPE)` | Undefiniertes Vor-/Nachzustand der Variable  |

* **Typische Anwendungsfälle**:

  * OUT: `procedure get_employee_name(id IN NUMBER, name OUT VARCHAR2)`
  * IN OUT: `procedure increment_counter(cnt IN OUT NUMBER)`

---

### 2. PL/SQL: Cursors & %TYPE / %ROWTYPE

#### Cursor

* **Expliziter Cursor**:

  ```plsql
  DECLARE
    CURSOR c_emp IS SELECT id, name FROM employees WHERE dept_id = 10;
    r_emp c_emp%ROWTYPE;
  BEGIN
    OPEN c_emp;
    LOOP
      FETCH c_emp INTO r_emp;
      EXIT WHEN c_emp%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(r_emp.id || ': ' || r_emp.name);
    END LOOP;
    CLOSE c_emp;
  END;
  ```
* **FOR-Cursor** (empfohlen):

  ```plsql
  BEGIN
    FOR r_emp IN (SELECT id, name FROM employees WHERE dept_id = 10) LOOP
      DBMS_OUTPUT.PUT_LINE(r_emp.id || ': ' || r_emp.name);
    END LOOP;
  END;
  ```
* **Häufige Fehler**:

  * Vergessen `OPEN`/`CLOSE` → Laufzeitfehler.
  * `EXIT WHEN c_emp%NOTFOUND` nach `FETCH` vergessen → Endlosschleife.

#### %TYPE / %ROWTYPE

* **%TYPE**: Variable übernimmt Datentyp einer Tabellenspalte.

  ```plsql
  v_sal employees.salary%TYPE;
  ```
* **%ROWTYPE**: Datensatz-Record passend zu ganzer Zeile.

  ```plsql
  r_emp employees%ROWTYPE;
  ```
* **Best Practice**: Verwende `%TYPE`/`%ROWTYPE` statt harter Datentypen, für Wartbarkeit.

---

### 3. JDBC: Connection, Statement, ResultSet & try-with-resources

#### Connection & try-with-resources

* **Zweck**: Aufbau und Verwaltung DB-Verbindung.
* **Beispiel**:

  ```java
  String sql = "SELECT id, name FROM employees";
  try (
    Connection conn = DriverManager.getConnection(url, user, pass);
    PreparedStatement ps = conn.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
  ) {
    while (rs.next()) {
      System.out.println(rs.getInt("id") + ": " + rs.getString("name"));
    }
  } catch (SQLException e) {
    e.printStackTrace();
  }
  ```
* **Best Practice**:

  * Immer `try(...) {}` nutzen, um `conn`, `ps`, `rs` automatisch zu schließen.

#### ResultSet

* **Funktion**: Hält Ergebnisse einer SELECT-Abfrage.
* **Modi**: `TYPE_FORWARD_ONLY` (default), `TYPE_SCROLL_INSENSITIVE`, `TYPE_SCROLL_SENSITIVE`.
* **Methoden**: `next()`, `getInt()`, `getString()`, `close()`.
* **Beispiel**:

  ```java
  while (rs.next()) {
    int id = rs.getInt(1);            // Index-basierter Zugriff
    String name = rs.getString("name");
  }
  ```
* **Fehlerquellen**:

  * Zugriff ohne `rs.next()` → `SQLException`
  * Falscher Spaltenindex (1-based vs. 0-based)

---

### 4. JPA: EntityManager, Fetch Types & Cascade

#### EntityManager & Lifecycle

* **Grundoperationen**: `persist()`, `find()`, `merge()`, `remove()`, `flush()`, `clear()`.
* **Transaktionsmanagement**:

  ```java
  EntityManager em = emf.createEntityManager();
  EntityTransaction tx = em.getTransaction();
  try {
    tx.begin();
    em.persist(entity);
    tx.commit();
  } catch (Exception ex) {
    tx.rollback();
  } finally {
    em.close();
  }
  ```
* **Fallstrick**: Nicht geschlossene EM → Memory Leak.

#### Lazy vs. Eager Loading

| Beziehung   | Default | Eignung                              |
| ----------- | ------- | ------------------------------------ |
| @ManyToOne  | EAGER   | Kleines Parent-Objekt immer benötigt |
| @OneToMany  | LAZY    | Große Listen nur bei Bedarf laden    |
| @OneToOne   | EAGER   | Immer zusammen abrufen               |
| @ManyToMany | LAZY    | Komplexe Joins nur bei Bedarf        |

* **Best Practice**: Setze **LAZY** für alle Relations, und nutze `JOIN FETCH` in der Abfrage:

  ```java
  SELECT o FROM Order o JOIN FETCH o.items WHERE o.id = :id
  ```

#### Cascade

* **Typen**: `PERSIST`, `MERGE`, `REMOVE`, `REFRESH`, `DETACH`, `ALL`.
* **Beispiel**:

  ```java
  @OneToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
  private List<OrderItem> items;
  ```
* **Ungeeignet**: `CascadeType.ALL` auf `REMOVE` lässt `OrderItem` unbeabsichtigt löschen.
* **Best Practice**: Nur notwendige Cascade-Typen setzen.

---

### 5. XML: Storage, Trigger & Abfragen

#### XMLType Storage (Oracle)

| Typ               | Beschreibung                           | Use-Case                             |
| ----------------- | -------------------------------------- | ------------------------------------ |
| CLOB              | XML als unstrukturierter Text          | Kompatibilität, einfache Speicherung |
| Binary XML        | Optimierte u. indexierbare Speicherung | Performance-optimierte Queries       |
| Object-Relational | Tabellenspalte + Pfad-Expressions      | Komplexe, relationale XML-Abfragen   |

* **Trigger auf XMLType**:

  ```sql
  CREATE OR REPLACE TRIGGER trg_validate_xml
  BEFORE INSERT OR UPDATE ON xml_table
  FOR EACH ROW
  BEGIN
    IF NOT xml_is_wellformed(:NEW.xmlcol) THEN
      RAISE_APPLICATION_ERROR(-20010, 'Ungültiges XML');
    END IF;
  END;
  ```
* **CLOB vs. Trigger**: CLOB speichert, Trigger validiert oder transformiert XML.

#### XML-Abfragen & Pfade

* **Absolut**: `/root/book[price<30]/title`
* **Relativ**: `//book[author='Lev']/title`
* **Trigger-Level**: XML-DML mit `XMLTABLE` oder `XQuery` im Trigger.
* **Beispiel XQuery**:

  ```xquery
  FOR $b IN /bookstore/book
  WHERE $b/price < 30
  RETURN <cheap>{$b/title/text()}</cheap>
  ```

---

### 6. NoSQL, Wide-Column & Graph DB

#### Key-Value Store (Redis)

* **Beispiel**:

  ```redis
  SET session:abc123 '{"user":"lev","ts":...}'
  GET session:abc123
  ```
* **Fehler**: Keine TTL setzen → Out-of-Memory.
* **Best Practice**: `EXPIRE session:abc123 3600`

#### Wide-Column Store (Cassandra)

* **Schema**:

  ```cql
  CREATE TABLE user_logs (
    user_id UUID,
    ts timestamp,
    action text,
    PRIMARY KEY (user_id, ts)
  );
  ```
* **Zweck**: Zeitreihen, hohe Schreib-Performance.
* **Fehler**: Multi-Cluster-Join vs. Relationale Joins.
* **Best Practice**: Query-first-Design, Partition Key auf häufige Lesezugriffe abstimmen.

#### Graph DB (Neo4j)

* **Beispiel**:

  ```cypher
  CREATE
    (a:User {name:'Lev'}),
    (b:User {name:'Vika'}),
    (a)-[:KNOWS]->(b);

  MATCH (u:User)-[:KNOWS]->(f)
  RETURN f.name;
  ```
* **Fehler**: Keine Indexe → Full-Graph-Scan.
* **Best Practice**:

  ```cypher
  CREATE INDEX FOR (u:User) ON (u.name);
  ```

---
*/