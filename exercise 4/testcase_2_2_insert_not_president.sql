INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES (8001, 'MARIA', 'SALESMAN', NULL, SYSDATE, 2000, NULL, 10);
COMMIT;
-- Man sollte die Values anpassen, um Konflikte mit bestehenden Daten zu vermeiden
-- Denn dieser Insert wurde schon in einem einem Testfall verwendet
