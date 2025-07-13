CREATE OR REPLACE PACKAGE mgr_constraints_pkg
IS
  PROCEDURE add_mgrlist (v_mgr IN emp.mgr%TYPE);
  PROCEDURE clean_mgrlist;
  PROCEDURE check_mgr(v_new_mgr emp.mgr%TYPE);
  PROCEDURE check_president;
  PROCEDURE check_pres_sal(v_new_sal emp.sal%TYPE);
  PROCEDURE new_location(v_deptno dept.deptno%TYPE);
END mgr_constraints_pkg;
/

CREATE OR REPLACE PACKAGE BODY mgr_constraints_pkg 
IS
  v_max_sal         emp.sal%TYPE;
  v_list_length		NUMBER	:= 0;

  TYPE mgr_table_type IS TABLE OF
    emp.mgr%TYPE
    INDEX BY BINARY_INTEGER;

  CURSOR mgr_cursor IS
    SELECT distinct mgr
    FROM emp
    ORDER BY mgr;

  mgrlist_table    mgr_table_type;

  PROCEDURE clean_mgrlist
  IS
  BEGIN
    mgrlist_table.delete;
    v_list_length := 0;
  END clean_mgrlist;

  PROCEDURE add_mgrlist (v_mgr	IN 	emp.mgr%TYPE)
  IS
    v_new_mgr    BOOLEAN := TRUE;  
  BEGIN
    FOR i IN 1..v_list_length LOOP
      if mgrlist_table(i) = v_mgr THEN
        v_new_mgr := FALSE;
      END IF;
    END LOOP;

    IF v_new_mgr THEN 
      v_list_length := v_list_length + 1;
      mgrlist_table(v_list_length) := v_mgr;
    END IF;
  END add_mgrlist;

  PROCEDURE check_mgr(v_new_mgr emp.mgr%TYPE) IS
  v_total_emps NUMBER;
  v_max_number_emps CONSTANT NUMBER := 5;
  BEGIN
  SELECT count(*) INTO v_total_emps
  FROM emp
  WHERE mgr = v_new_mgr;

  IF v_total_emps + 1 > v_max_number_emps THEN
    RAISE_APPLICATION_ERROR(-20000,
      'Max number of emps exceeded for ' || TO_CHAR(v_new_mgr));
  END IF;
  END check_mgr;


  PROCEDURE check_president
  IS
    v_dummy  VARCHAR2(1);
  BEGIN
    SELECT 'X'
    INTO   v_dummy
    FROM   emp
    WHERE  job = 'PRESIDENT';

    IF v_dummy IS NOT NULL THEN
      RAISE_APPLICATION_ERROR(-20001,'President title already exists');
    END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        null;
  END check_president;

  PROCEDURE check_pres_sal(v_new_sal emp.sal%TYPE)
  IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('v_new_sal: '||v_new_sal);
    DBMS_OUTPUT.PUT_LINE('v_max_sal: '||v_max_sal);
    IF v_new_sal > v_max_sal THEN
      RAISE_APPLICATION_ERROR(-20003,'Salary may not exceed that of the President');
    END IF;
  END check_pres_sal;

  PROCEDURE new_location(v_deptno dept.deptno%TYPE)
  IS
    v_sal  emp.sal%TYPE;
  BEGIN
    UPDATE emp
    SET sal = sal*1.02
    WHERE deptno = v_deptno;

    SELECT sal
    INTO v_sal
    FROM emp
    WHERE job = 'PRESIDENT';

    IF v_sal > v_max_sal THEN
      v_max_sal := v_sal;
    END IF;
  END new_location;

BEGIN
  SELECT MAX(sal)
  INTO v_max_sal
  FROM emp;

  FOR mgr_rec IN mgr_cursor LOOP
    add_mgrlist(mgr_rec.mgr);
  END LOOP;

END mgr_constraints_pkg;
/
