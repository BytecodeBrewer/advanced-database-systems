
CREATE TABLE COMPANYXML (
    DEPTNO NUMBER,
    MITARBEITERLISTE XMLTYPE
);

INSERT INTO COMPANYXML (DEPTNO, MITARBEITERLISTE)
SELECT 
    d.DEPTNO,
    XMLELEMENT(
        "Mitarbeiterliste",
        XMLATTRIBUTES(d.DEPTNO AS "abteilung"),
        (
            SELECT 
                XMLAGG(
                    XMLELEMENT(
                        "Mitarbeiter",
                        XMLATTRIBUTES(e.EMPNO AS "id"),
                        XMLELEMENT("Name", e.ENAME),
                        XMLELEMENT("Beruf", e.JOB),
                        XMLELEMENT("Manager", e.MGR),
                        XMLELEMENT("Einstelldatum", TO_CHAR(e.HIREDATE, 'DD.MM.YY')),
                        XMLELEMENT("Payment",
                            XMLELEMENT("Gehalt", e.SAL),
                            XMLELEMENT("Kommission", NVL(e.COMM, 0))
                        )
                    )
                )
            FROM EMP e
            WHERE e.DEPTNO = d.DEPTNO
        )
    )
FROM (SELECT DISTINCT DEPTNO FROM EMP) d;

