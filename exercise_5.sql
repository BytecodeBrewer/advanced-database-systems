-- 1. 
-- Objekt-Typ PERSON
-- Hinweis: Über NONEDITIONABLE steht nicht viel, ist hier notwendig
CREATE OR REPLACE NONEDITIONABLE TYPE PERSON AS OBJECT (
    VNAME      VARCHAR2(20),
    NNAME      VARCHAR2(20),
    GEBJAHR    NUMBER(4),
    STRASSE    VARCHAR2(30),
    ORT        VARCHAR2(30),
    MANAGER    REF PERSON,

    CONSTRUCTOR FUNCTION PERSON (
        VNAME VARCHAR2,
        NNAME VARCHAR2,
        GEBJAHR NUMBER,
        STRASSE VARCHAR2
    ) RETURN SELF AS RESULT,

    MEMBER FUNCTION AGE RETURN NUMBER,
    MEMBER PROCEDURE NeuerName(p_neuerNachname IN VARCHAR2)
) NOT FINAL;
/

-- Type Body
CREATE OR REPLACE TYPE BODY PERSON AS

    CONSTRUCTOR FUNCTION PERSON (
        VNAME VARCHAR2,
        NNAME VARCHAR2,
        GEBJAHR NUMBER,
        STRASSE VARCHAR2
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.VNAME := VNAME;
        SELF.NNAME := NNAME;
        SELF.GEBJAHR := GEBJAHR;
        SELF.STRASSE := STRASSE;
        SELF.ORT := 'LEIPZIG';
        SELF.MANAGER := NULL;
        RETURN;
    END;

    MEMBER FUNCTION AGE RETURN NUMBER IS
    BEGIN
        RETURN EXTRACT(YEAR FROM SYSDATE) - GEBJAHR;
    END;

    MEMBER PROCEDURE NeuerName(p_neuerNachname IN VARCHAR2) IS
    BEGIN
        SELF.NNAME := p_neuerNachname;
    END;

END;
/

-- 2

DECLARE
    p1 PERSON;
    p2 PERSON;
BEGIN
    -- Standardkonstruktor
    p1 := PERSON('Anna', 'Schmidt', 1990, 'Käthe-Kollwitz-Str. 5', 'Berlin', NULL);

    -- Benutzerdefinierter Konstruktor (Ort = Leipzig, Manager = NULL)
    p2 := NEW PERSON('Lena', 'Schulze', 2000, 'Hauptstr. 1');

    -- Nachnamen ändern
    p2.NeuerName('Krause');

    -- Ausgabe
    DBMS_OUTPUT.PUT_LINE('p1: ' || p1.VNAME || ' ' || p1.NNAME || ', Alter: ' || p1.AGE());
    DBMS_OUTPUT.PUT_LINE('p2: ' || p2.VNAME || ' ' || p2.NNAME || ', Ort: ' || p2.ORT || ', Alter: ' || p2.AGE());
END;
/

--3

-- Tabelle auf Basis des Typs
CREATE TABLE PERSONAL OF PERSON (
    PRIMARY KEY (NNAME)
)
OBJECT IDENTIFIER IS PRIMARY KEY;

-- Ohne Dereferenzierung
SELECT * FROM PERSONAL;

-- Mit Dereferenzierung (Name des Managers)
SELECT
    p.VNAME,
    p.NNAME,
    p.GEBJAHR,
    p.STRASSE,
    p.ORT,
    DEREF(p.MANAGER).NNAME AS MANAGER_NAME
FROM PERSONAL p;


--4

-- Subtyp MITARBEITER
CREATE OR REPLACE TYPE MITARBEITER UNDER PERSON (
    MA_NR NUMBER,
    ABTEILUNG VARCHAR2(30)
);
/

CREATE SEQUENCE MA_SEQ START WITH 1 INCREMENT BY 1;

DECLARE
    ref_mueller REF PERSON;
BEGIN
    SELECT REF(p) INTO ref_mueller
    FROM PERSONAL p
    WHERE p.NNAME = 'Mueller';

    INSERT INTO PERSONAL VALUES (
        MITARBEITER('Lisa', 'König', 1999, 'Markt 2', 'Leipzig', ref_mueller, MA_SEQ.NEXTVAL, 'Marketing')
    );
END;
/

SELECT
    p.VNAME,
    p.NNAME,
    TREAT(VALUE(p) AS MITARBEITER).MA_NR AS MA_NR,
    TREAT(VALUE(p) AS MITARBEITER).ABTEILUNG AS ABT,
    DEREF(p.MANAGER).NNAME AS MANAGER_NAME
FROM PERSONAL p;
