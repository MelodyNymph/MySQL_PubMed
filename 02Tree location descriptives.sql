-- Tree location descriptives
-- 1.	For each tree (16, A, B, …), how many articles
-- use sampleMesh and descTree
CREATE TABLE PMIDUITREE
SELECT sampleMesh.PMID, sampleMesh.UI, descTree.TreeNumber
FROM sampleMesh
LEFT JOIN descTree ON sampleMesh.UI=descTree.DescriptorUI
ORDER BY PMID;

-- get the label (A, B, ...) for all the items 
CREATE TABLE PMIDUITREEPREFIX
SELECT *, SUBSTRING(TreeNumber, 1, 1) AS Prefix
FROM PMIDUITREE
ORDER BY PMID

-- COUNT the number of articles for each tree
SELECT Prefix, COUNT(DISTINCT PMID)
from PMIDUITREEPREFIX
GROUP BY Prefix


-- 2.	Average number of distinct trees (A, B, …) used by article
-- find the number of distinct trees (A, B, …) used by article
CREATE TABLE NUMTREEbyPMID
SELECT PMID, COUNT(distinct Prefix) AS NUMofTREE 
FROM PMIDUITREEPREFIX
GROUP BY PMID;

SELECT avg(NUMofTREE)
FROM NUMTREEbyPMID


-- a.	SD of this number
SELECT STDDEV(NUMofTREE)
FROM NUMTREEbyPMID


-- 3.	Average number of tree levels (dots) in MESH terms in articles, for each of 16 trees
-- get the number of levels for each tree
CREATE TABLE PMIDUITREEPREFIXLEVEL
SELECT *, (length(TreeNumber) - length(replace(TreeNumber,'.',''))+1) as NumLevel
FROM PMIDUITREEPREFIX

-- For each PMID and Prefix, find the average tree levels
CREATE TABLE PMIDPREFIXNUMLEVEL 
SELECT PMID, Prefix, AVG(NumLevel) AS LEVEL
FROM PMIDUITREEPREFIXLEVEL
GROUP BY PMID, Prefix;

-- transform PMIDPREFIXNUMLEVEL into the form: each PMID, 16 columns representing 16 average levels
SELECT 
       PMID,  
       MAX(CASE Prefix WHEN 'A' THEN LEVEL END) AS 'A',
       MAX(CASE Prefix WHEN 'B' THEN LEVEL END) AS 'B',
       MAX(CASE Prefix WHEN 'C' THEN LEVEL END) AS 'C',
       MAX(CASE Prefix WHEN 'D' THEN LEVEL END) AS 'D',
       MAX(CASE Prefix WHEN 'E' THEN LEVEL END) AS 'E',
       MAX(CASE Prefix WHEN 'F' THEN LEVEL END) AS 'F',
       MAX(CASE Prefix WHEN 'G' THEN LEVEL END) AS 'G',
       MAX(CASE Prefix WHEN 'H' THEN LEVEL END) AS 'H',
       MAX(CASE Prefix WHEN 'I' THEN LEVEL END) AS 'I',
       MAX(CASE Prefix WHEN 'J' THEN LEVEL END) AS 'J',
       MAX(CASE Prefix WHEN 'K' THEN LEVEL END) AS 'K',
       MAX(CASE Prefix WHEN 'L' THEN LEVEL END) AS 'L',
       MAX(CASE Prefix WHEN 'M' THEN LEVEL END) AS 'M',
       MAX(CASE Prefix WHEN 'N' THEN LEVEL END) AS 'N',
       MAX(CASE Prefix WHEN 'V' THEN LEVEL END) AS 'V',
       MAX(CASE Prefix WHEN 'Z' THEN LEVEL END) AS 'Z'
FROM PMIDPREFIXNUMLEVEL
GROUP BY PMID 


-- CREATE TABLE PMIDLEVELN
-- select PMID, AVG(NumLevel) AS LEVELN
-- from PMIDUITREEPREFIXLEVEL
-- WHERE Prefix = 'N'
-- GROUP BY PMID


-- CREATE TABLE PMIDLEVELH
-- select PMID, AVG(NumLevel) AS LEVELH
-- from PMIDUITREEPREFIXLEVEL
-- WHERE Prefix = 'H'
-- GROUP BY PMID


-- CREATE TABLE ALLPMIDLEVELN
-- SELECT PMIDUITREEPREFIXLEVEL.PMID, AVG(PMIDLEVELN.LEVELN) AS LEVELN
-- FROM PMIDUITREEPREFIXLEVEL
-- LEFT JOIN PMIDLEVELN ON PMIDUITREEPREFIXLEVEL.PMID=PMIDLEVELN.PMID
-- GROUP BY PMID


-- SELECT ALLPMIDLEVELN.PMID, ALLPMIDLEVELN.LEVELN, PMIDLEVELH.LEVELH
-- FROM ALLPMIDLEVELN
-- LEFT JOIN PMIDLEVELH ON ALLPMIDLEVELN.PMID=PMIDLEVELH.PMID


-- cd path
-- cat file*.csv > all_files.csv



