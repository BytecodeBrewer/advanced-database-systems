-- TESTFALL 1: Gehalt bleibt gleich (erlaubt)
UPDATE EMP
SET SAL = SAL
WHERE EMPNO = 7900;
COMMIT;

-- TESTFALL 2: Gehalt erhöhen (erlaubt)
UPDATE EMP
SET SAL = SAL + 200
WHERE EMPNO = 7900;
COMMIT;

-- TESTFALL 3: Gehalt verringern (verboten)
UPDATE EMP
SET SAL = SAL - 100
WHERE EMPNO = 7900;
COMMIT;