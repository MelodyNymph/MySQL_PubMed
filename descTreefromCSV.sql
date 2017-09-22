--create descTree table: DescriptorUI，TreeNumber 
CREATE TABLE descTree (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    DescriptorUI varchar(255) NOT NULL,
    TreeNumber varchar(255) NOT NULL
);

LOAD DATA LOCAL INFILE "/Users/ruizhao/Desktop/IQSS/MYSQL/PUBMEDFILE/desc2017TreeNumber.csv"
INTO TABLE descTree
COLUMNS TERMINATED BY ','
LINES TERMINATED BY '\n';
