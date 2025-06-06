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
        RETURN EXTRACT(YEAR FROM SYSDATE) - SELF.GEBJAHR;
    END;

    MEMBER PROCEDURE NeuerName(p_neuerNachname IN VARCHAR2) IS
    BEGIN
        SELF.NNAME := p_neuerNachname;
    END;
END;
/

-- ====================================
-- 2. Anonymer Block zur Konstruktor- und Methodenprüfung
-- ====================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Test Konstruktoren & Methoden ---');
    DECLARE
        p1 PERSON;
        p2 PERSON;
    BEGIN
        p1 := PERSON('Anna', 'Schmidt', 1990, 'Käthe-Kollwitz-Str. 5', 'Berlin', NULL);
        p2 := NEW PERSON('Lena', 'Schulze', 2000, 'Hauptstr. 1');
        p2.NeuerName('Krause');

        DBMS_OUTPUT.PUT_LINE('p1: ' || p1.VNAME || ' ' || p1.NNAME || ', Alter: ' || p1.AGE());
        DBMS_OUTPUT.PUT_LINE('p2: ' || p2.VNAME || ' ' || p2.NNAME || ', Ort: ' || p2.ORT || ', Alter: ' || p2.AGE());
    END;
END;
/

-- ====================================
-- 3. Tabelle auf Basis des Objekttyps + Daten mit REF
-- ====================================

DROP TABLE PERSONAL;

CREATE TABLE PERSONAL OF PERSON
  OBJECT IDENTIFIER IS SYSTEM GENERATED;


INSERT INTO PERSONAL VALUES (
    PERSON('Peter', 'Mueller', 1982, 'Hillerstr.10', 'Leipzig', NULL)
);

DECLARE
    ref_mueller REF PERSON;
BEGIN
    SELECT REF(p) INTO ref_mueller
    FROM PERSONAL p
    WHERE p.NNAME = 'Mueller';

    INSERT INTO PERSONAL VALUES (
        PERSON('Horst', 'Meier', 1996, 'Herderstr.13', 'Paderborn', ref_mueller)
    );
END;
/

-- ====================================
-- 4. Subtyp MITARBEITER + Sequence + Insert mit REF
-- ====================================

CREATE OR REPLACE NONEDITIONABLE TYPE MITARBEITER UNDER PERSON (
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
        NEW MITARBEITER('Lisa', 'König', 1999, 'Markt 2', 'Leipzig', ref_mueller, MA_SEQ.NEXTVAL, 'Marketing')
    );
END;
/

-- ====================================
-- 5. Ausgabe mit TREAT + Dereferenzierung
-- ====================================

SELECT
    p.VNAME,
    p.NNAME,
    TREAT(VALUE(p) AS MITARBEITER).MA_NR AS MA_NR,
    TREAT(VALUE(p) AS MITARBEITER).ABTEILUNG AS ABT,
    DEREF(p.MANAGER).NNAME AS MANAGER_NAME
FROM PERSONAL p
WHERE TREAT(VALUE(p) AS MITARBEITER) IS NOT NULL;

-- ====================================
-- ENDE DES SKRIPTS
-- ====================================