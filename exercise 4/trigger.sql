CREATE OR REPLACE PROCEDURE check_worktime IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Aenderungen nur waehrend der Arbeitszeit!');
END;
/

CREATE OR REPLACE TRIGGER trg_check_worktime
BEFORE INSERT OR UPDATE ON emp
FOR EACH ROW
DECLARE
    v_day   VARCHAR2(3);
    v_hour  NUMBER;
    v_current_time TIMESTAMP;
BEGIN
    v_day := TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH');
    v_hour := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));
    IF v_day IN ('SAT', 'SUN') OR v_hour < 10 OR v_hour >= 15 THEN
        check_worktime; -- Prozedur aufrufen
        RAISE_APPLICATION_ERROR(-20001, 'Aenderungen nur waehrend der Arbeitszeit!');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Aenderung erlaubt: ' || v_current_time);
END;
/