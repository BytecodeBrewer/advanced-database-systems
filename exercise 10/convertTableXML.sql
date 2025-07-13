DROP TABLE SALGRADESXML;

CREATE TABLE salgradesXML AS
SELECT XMLElement("SalgradeListe",
  XMLAgg(
    XMLElement("Salgrade",
      XMLElement("Stufe", GRADE),
      XMLElement("Min", LOSAL),
      XMLElement("Max", HISAL)
    )
  )
) AS salgrade_xml
FROM salgrade;


