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


-- example
select EXTRACTVALUE_ALL(@xml, '//DescriptorName', '|');
--result: Cell Membrane Permeability Diphosphoglyceric Acids Erythrocytes Humans Hydrogen-Ion Concentration Membrane Potentials|||||
--(6 mesh, 5 delimiters)