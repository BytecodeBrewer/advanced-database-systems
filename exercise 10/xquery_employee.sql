set lines 10000
set long 10000
set pagesize 1000


-- Exercise 10: XQuery with XML data in Oracle
-- Ich habe Serialisierung in bestimmten Fällen hinzugefügt, um die Ausgabe lesbarer zu machen.
-- Doch in den Klammern sind die Queries, die das gleiche Ergebnis liefern würden, aber ohne Serialisierung. 

SELECT XMLQuery('
<result> {
  for $m in ora:view("companyXML")//Mitarbeiter
  order by $m/Name
  return ($m/Name,"&#xA;")
} </result>
' RETURNING CONTENT) AS Namen_Sortiert
FROM dual;

SELECT XMLSerialize(
  CONTENT XMLQuery('
    <result>{
      for $m in ora:view("companyXML")//Mitarbeiter
      return (
        <Angestellter>
          <ID>{ data($m/@id) }</ID>
          <EDat>{ $m/Einstelldatum/text() }</EDat>
          <Name>{ $m/Name/text() }</Name>
          <Beruf>{ $m/Beruf/text() }</Beruf>
          <Gehalt>{ $m/Payment/Gehalt/text() }</Gehalt>
        </Angestellter>
      )
    }</result>
    ' RETURNING CONTENT)
  AS CLOB INDENT SIZE = 2
) AS Angestellte_Strukturiert
FROM dual;

/*
SELECT XMLQuery('
    <result>{
    for $a in distinct-values(ora:view("companyXML")//Mitarbeiterliste/@abteilung)
    order by $a
    return <Abteilung>{ data($a) }</Abteilung>
    }</result>
' RETURNING CONTENT)
  AS Abteilungen
FROM dual;
*/

SELECT XMLSerialize(
  CONTENT XMLQuery('
    <result>{
    for $a in distinct-values(ora:view("companyXML")//Mitarbeiterliste/@abteilung)
    order by $a
    return <Abteilung>{ data($a) }</Abteilung>
    }</result>
' RETURNING CONTENT) 
  AS CLOB INDENT SIZE = 2)
  AS Abteilungen
FROM dual;

/*
SELECT XMLQuery('
<result>{
  for $m in ora:view("companyXML")//Mitarbeiter
  let $g := $m/Payment/Gehalt
  where $g >= 2500
  order by xs:decimal($g) descending
  return (
    <topdog>
      <Name>{ $m/Name/text() }</Name>
      <Gehalt>{ $g/text() }</Gehalt>
    </topdog>,
    "&#xA;"
  )
}</result>
' RETURNING CONTENT) AS TopVerdiener
FROM dual;
*/

SELECT XMLSerialize(
  CONTENT XMLQuery('
    <result>{
      for $m in ora:view("companyXML")//Mitarbeiter
      let $g := $m/Payment/Gehalt
      where $g >= 2500
      order by xs:decimal($g) descending
      return (
        <topdog>
          <Name>{ $m/Name/text() }</Name>
          <Gehalt>{ $g/text() }</Gehalt>
        </topdog>
      )
    }</result>
  ' RETURNING CONTENT)
  AS CLOB INDENT SIZE = 2
) AS TopVerdiener
FROM dual;



