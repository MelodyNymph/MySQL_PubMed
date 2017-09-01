CREATE TABLE MASTER (
    PMID int PRIMARY KEY,
    JournalTitle varchar(255) NOT NULL,
    ISOAbbreviation varchar(255) NOT NULL,
    ISSN varchar(255) NOT NULL, 
    PubDateYear varchar(255) NOT NULL,  
    PubDateMonth varchar(255) ,
    ArticleTitle varchar(255) NOT NULL,
    AbstractText text
);

LOAD DATA LOCAL INFILE  '/Users/ruizhao/Desktop/MYSQL/PUBMEDFILE/medsample1.xml' 
INTO TABLE MASTER
LINES STARTING BY '<PubmedArticle>' TERMINATED BY '</PubmedArticle>'
(@mas)
SET 
PMID = ExtractValue(@mas, '//PMID'),
JournalTitle = ExtractValue(@mas, '//Journal/Title'),
ISOAbbreviation = ExtractValue(@mas, '//ISOAbbreviation'),
ISSN = ExtractValue(@mas, '//ISSN'),
PubDateYear = ExtractValue(@mas, '//PubDate/Year'),
PubDateMonth = ExtractValue(@mas, '//PubDate/Month'),
ArticleTitle = ExtractValue(@mas, '//ArticleTitle'),
AbstractText = ExtractValue(@mas, '//AbstractText');