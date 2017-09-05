-- create descQualifier table: id, DescriptorUI, QualifierUI, QualifierName
CREATE TABLE descQualifier (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    DescriptorUI varchar(255) NOT NULL,
    QualifierUI varchar(255) NOT NULL,
    QualifierName varchar(255) NOT NULL
);

LOAD DATA LOCAL INFILE "/Users/ruizhao/Desktop/MYSQL/PUBMEDFILE/descQualifier.csv"
INTO TABLE descQualifier
COLUMNS TERMINATED BY ','
LINES TERMINATED BY '\n';