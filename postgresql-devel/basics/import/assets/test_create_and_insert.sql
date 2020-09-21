-- Create another table and insert some data
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
        (1, 'Black Widow', 3);
