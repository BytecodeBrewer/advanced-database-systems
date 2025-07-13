SELECT empno, sal, deptno FROM emp WHERE deptno = 20;

-- Standort muss geändert werden, um Gehaltserhöhung zu ermöglichen
UPDATE dept SET loc = 'HAMBURG' WHERE deptno = 20;
COMMIT;

SELECT empno, sal, deptno FROM emp WHERE deptno = 20;

-- Kritisch: Es gibt diese Abteilung nicht
UPDATE dept SET loc = 'DRESDEN' WHERE deptno = 999;
COMMIT;