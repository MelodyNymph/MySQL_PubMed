-- create database
CREATE DATABASE IF NOT EXISTS PubMed;
USE PubMed;

-- create table
CREATE TABLE SAMPLE (
    PMID int PRIMARY KEY,
    --DateCreated/year DATETIME -- not work 
    --- Title varchar(255),
    -- PublicationDate DATETIME,
    -- PublicationJournal varchar(255),
    -- Authors varchar(255)
    -- PRIMARY KEY (PMID)
);

-- load file 
LOAD XML LOCAL INFILE '/Users/ruizhao/Desktop/MYSQL/try.xml'
INTO TABLE SAMPLE
ROWS IDENTIFIED BY '<MedlineCitation>';
--- medline17n0001.xml


CREATE TABLE journal (
	`Title` varchar(255) NOT NULL,
    `ISOAbbreviation` varchar(255) NOT NULL,
    `ISSN` varchar(255) NOT NULL, 
    `PubDate` DATETIME NOT NULL,  
    `Volume` INT NOT NULL
)


LOAD DATA LOCAL INFILE  '/Users/ruizhao/Desktop/MYSQL/medline17n0001.xml' 
INTO TABLE journal

LINES STARTING BY '<PubmedArticle>' TERMINATED BY '</PubmedArticle>'
(@tmp)

SET 
Title = ExtractValue(@tmp, '//Title'),
ISOAbbreviation = ExtractValue(@tmp, '//ISOAbbreviation'),
ISSN = ExtractValue(@tmp, '//ISSN'),
PubDate = ExtractValue(@tmp, '//PubDate/Year'),
Volume = ExtractValue(@tmp, '//Volume');


--------------------------------------
2017-8-22

-- before mysql, in terminal 
mysql --local-infile -uroot

-- create table for xml 
CREATE TABLE journal1 (
    `Title` varchar(255) NOT NULL,
    `ISOAbbreviation` varchar(255) NOT NULL,
    `ISSN` varchar(255) NOT NULL, 
    `PubDate` varchar(255) NOT NULL,  
    `Volume` INT NOT NULL
);

-- load file 
LOAD DATA LOCAL INFILE  '/Users/ruizhao/Desktop/MYSQL/medline17n0001.xml' 
INTO TABLE journal1
LINES STARTING BY '<PubmedArticle>' TERMINATED BY '</PubmedArticle>'
(@tmp)

SET 
Title = ExtractValue(@tmp, '//Title'),
ISOAbbreviation = ExtractValue(@tmp, '//ISOAbbreviation'),
ISSN = ExtractValue(@tmp, '//ISSN'),
PubDate = ExtractValue(@tmp, '//PubDate/Year'),
Volume = ExtractValue(@tmp, '//Volume');

-- examine the table
select * from journal1 limit 3;

--------------------------------------------------------

CREATE TABLE journal2 (
    `Title` varchar(255) NOT NULL,
    `ISOAbbreviation` varchar(255) NOT NULL,
    `ISSN` varchar(255) NOT NULL, 
    `PubDate` varchar(255) NOT NULL,  
    `Volume` INT NOT NULL
);


LOAD DATA LOCAL INFILE  '/Users/ruizhao/Desktop/MYSQL/medline17n0002.xml' 
INTO TABLE journal2
LINES STARTING BY '<PubmedArticle>' TERMINATED BY '</PubmedArticle>'
(@tmp2)

SET 
Title = ExtractValue(@tmp2, '//Title'),
ISOAbbreviation = ExtractValue(@tmp2, '//ISOAbbreviation'),
ISSN = ExtractValue(@tmp2, '//ISSN'),
PubDate = ExtractValue(@tmp2, '//PubDate/Year'),
Volume = ExtractValue(@tmp2, '//Volume');

--------------------------------------------------------------------------------
2017-8-23

-- Construct more complete table with information: PMID, JournalTitle, ISOAbbreviation 
-- ISSN,PubDateYear, PubDateMonth, ArticleTitle, AbstractText, MeshHeadingDescriptorName,
-- MeshHeadingQualifierName
CREATE TABLE newpub (
    PMID int PRIMARY KEY,
    JournalTitle varchar(255) NOT NULL,
    ISOAbbreviation varchar(255) NOT NULL,
    ISSN varchar(255) NOT NULL, 
    PubDateYear varchar(255) NOT NULL,  
    PubDateMonth varchar(255) ,
    ArticleTitle varchar(255) NOT NULL,
    -- text is used for more characters
    AbstractText text,
    MeshHeadingDescriptorName text,
    MeshHeadingQualifierName varchar(255)
);


LOAD DATA LOCAL INFILE  '/Users/ruizhao/Desktop/MYSQL/medline17n0001.xml' 
INTO TABLE newpub
LINES STARTING BY '<PubmedArticle>' TERMINATED BY '</PubmedArticle>'
(@tmpnew)

SET 
PMID = ExtractValue(@tmpnew, '//PMID'),
JournalTitle = ExtractValue(@tmpnew, '//Journal/Title'),
ISOAbbreviation = ExtractValue(@tmpnew, '//ISOAbbreviation'),
ISSN = ExtractValue(@tmpnew, '//ISSN'),
PubDateYear = ExtractValue(@tmpnew, '//PubDate/Year'),
PubDateMonth = ExtractValue(@tmpnew, '//PubDate/Month'),
ArticleTitle = ExtractValue(@tmpnew, '//ArticleTitle'),
AbstractText = ExtractValue(@tmpnew, '//AbstractText'),
MeshHeadingDescriptorName = ExtractValue(@tmpnew, '//MeshHeading/DescriptorName'),
MeshHeadingQualifierName = ExtractValue(@tmpnew, '//MeshHeading/QualifierName');


SELECT * FROM PubMed.newpub
where JournalTitle = 'Cell';

-----------------------------------------
2017-8-24
-- 1. query about CELL records 
-- newpub: order by year & month
SELECT * FROM PubMed.newpub
where JournalTitle = 'Cell'
order by PubDateYear, PubDateMonth;

-- create a new table storing mesh terms of CELL 
Create table CellMesh
SELECT PubDateYear, PubDateMonth, MeshHeadingDescriptorName FROM PubMed.newpub
where JournalTitle = 'Cell'
order by PubDateYear, PubDateMonth;


-- 2. check how to separate mesh terms (some contain more than one word)
-- consider create a table with all mesh terms & UID: too many mesh terms 
select ExtractValue(@tmp, '//DescriptorName');

----FAILURE---
-- DELIMITER |
-- DECLARE i INT DEFAULT 1;
-- DECLARE count DEFAULT ExtractValue(@newpubTry, 'count(//DescriptorName)');
-- WHILE i <= count DO
-- SELECT ExtractValue(xml, '//DescriptorName[$i]');
-- SET i = i+1;
-- END WHILE
-- | DELIMITER;
----FAILURE---

----FAILURE---
-- DELIMITER //
-- CREATE PROCEDURE mesh_extract(var1 INT) 
-- BEGIN   
--     DECLARE start  INT unsigned DEFAULT 1;  
--     DECLARE finish INT unsigned DEFAULT 10;

--     SELECT  var1, start, finish;

--     SELECT * FROM places WHERE place BETWEEN start AND finish; 
-- END; //
-- DELIMITER ;
----FAILURE---

SELECT CONCAT_WS(',','First name','Second name','Last Name');

select ExtractValue(@newpubTry, CONCAT_WS('| ','//DescriptorName')); -- no effect

CREATE TABLE newpubTry (
    PMID int PRIMARY KEY,
    JournalTitle varchar(255) NOT NULL,
    ISOAbbreviation varchar(255) NOT NULL,
    ISSN varchar(255) NOT NULL, 
    PubDateYear varchar(255) NOT NULL,  
    PubDateMonth varchar(255) ,
    ArticleTitle varchar(255) NOT NULL,
    AbstractText text,
    MeshHeadingDescriptorName enum('yes','no') DEFAULT 'yes', -- no work 
    MeshHeadingQualifierName varchar(255)
);

LOAD DATA LOCAL INFILE  '/Users/ruizhao/Desktop/MYSQL/try.xml' 
INTO TABLE newpubTry
LINES STARTING BY '<PubmedArticle>' TERMINATED BY '</PubmedArticle>'
(@newpubTry)
SET 
PMID = ExtractValue(@newpubTry, '//PMID'),
JournalTitle = ExtractValue(@newpubTry, '//Journal/Title'),
ISOAbbreviation = ExtractValue(@newpubTry, '//ISOAbbreviation'),
ISSN = ExtractValue(@newpubTry, '//ISSN'),
PubDateYear = ExtractValue(@newpubTry, '//PubDate/Year'),
PubDateMonth = ExtractValue(@newpubTry, '//PubDate/Month'),
ArticleTitle = ExtractValue(@newpubTry, '//ArticleTitle'),
AbstractText = ExtractValue(@newpubTry, '//AbstractText'),
MeshHeadingDescriptorName = ExtractValue(@newpubTry, '//MeshHeading/DescriptorName'),
MeshHeadingQualifierName = ExtractValue(@newpubTry, '//MeshHeading/QualifierName');


-- function about MySQL xpath ExtractValue with delimiter
DROP FUNCTION IF EXISTS EXTRACTVALUE_ALL;
DELIMITER |
CREATE FUNCTION EXTRACTVALUE_ALL(p_xml TEXT, p_xpathExpr TEXT, p_delimiter TEXT) RETURNS TEXT
BEGIN
DECLARE total_elements INT;
DECLARE xpath_expression_count, xpath_expression_index  TEXT;
DECLARE single_tag, result  TEXT;
SET xpath_expression_count = CONCAT('count(', p_xpathExpr, ')');
SELECT EXTRACTVALUE(p_xml, xpath_expression_count) INTO total_elements;
SET result = '';
SET xpath_expression_index = CONCAT(p_xpathExpr, '[$@i]');
SET @i = 1;
WHILE @i <= total_elements DO
SET single_tag = EXTRACTVALUE(p_xml, xpath_expression_index);
SET result = IF(result='', single_tag, CONCAT(result, p_delimiter, single_tag));
SET @i = @i + 1;
END WHILE;
RETURN result;
END |
DELIMITER ;

select EXTRACTVALUE_ALL(@newpubTry, '//DescriptorName', '|');
result: Cell Membrane Permeability Diphosphoglyceric Acids Erythrocytes Humans Hydrogen-Ion Concentration Membrane Potentials|||||


-- 3. check if we could combine xml files 
