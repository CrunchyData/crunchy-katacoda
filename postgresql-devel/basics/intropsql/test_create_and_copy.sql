-- Partial copy of se_details table
CREATE TABLE cp_se_details AS
SELECT
    *
FROM se_details
WHERE month_name = 'June';

-- Create another new table and insert some data
CREATE TABLE new_test_table (
    id  SERIAL  PRIMARY KEY,
    hero_name   VARCHAR (80),
    cohort  integer 
);
INSERT INTO new_test_table (hero_name, cohort)
VALUES  ('Iron Man', 1),
        ('Captain Marvel', 3),
        ('Incredible Hulk', 1),
        ('Black Panther', 2),
        ('Black Widow', 3);

-- Display contents of new table
SELECT * FROM new_test_table;


