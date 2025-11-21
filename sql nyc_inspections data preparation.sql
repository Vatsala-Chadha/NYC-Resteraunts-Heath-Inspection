create table inspections_copy as 
select * from inspections ;

-- inspecting raw data --
select *
from inspections_copy
left join cuisine
using (cuisine_description)	
;

														-- DEALING WITH MISSING VALUES --	
-- fixing missing values in cuisine description --
update inspections_copy
set cuisine_description = 'Unknown'
where cuisine_description is null
;

-- fixing missing values in action --
update inspections_copy
set action = 'not yet inspected'
where inspection_date = '01/01/1900' 
;

-- fixing missing values in boro --
update inspections_copy
set boro = 'not specified'
where boro is null or boro ='0'
;

-- fixing missing values in building --
update inspections_copy
set building = 'not specified'
where building is null
;

-- fixing missing values in zipcode --
update inspections_copy
set zipcode = 'not specified'
where zipcode is null
;

-- fixing misisng values in violation code --
update inspections_copy
set violation_code = 'missing'
where violation_code is null
;

-- fixing misisng values in violation description --
update inspections_copy
set violation_description = 'missing'
where violation_description is null
;

-- handling missing values in grades --
update inspections_copy
set grade = 'not graded/pending'
where grade is null
;

update inspections_copy -- changing the default value for missing values in grade --
set grade = 'not graded/pending inspection'
where grade = 'not graded/pending'
;

-- handling missing values in inspection_type --
update inspections_copy
set inspection_type = 'inspection pending'
where inspection_type is null
;

						-- data imputation for score --
-- adding a column for avg scores for each Cuisine classification--
alter table inspections_copy
add column imputed_score integer
;
alter table inspections_copy -- renaming the imputed_score column to avg_score --
rename column imputed_score to avg_score
;

-- adding avg score of each classification to inspections table --
with average as (
select 
	classification,
	sum(score) / count(*) as avg_score
from inspections_copy as ic
left join cuisine as c
	using(cuisine_description)
where score is not null
	and action != 'not yet inspected'
group by classification
)
update inspections_copy as ic
set avg_score = a.avg_score
from cuisine as c
left join average as a
	using (classification)
where ic.cuisine_description = c.cuisine_description
;

-- adding a column for imputed score to inspections --
alter table inspections_copy
add column imputed_score integer
;

-- updating imputed score data into the column -- 
update inspections_copy
set imputed_score = coalesce(score, avg_score)
;

													-- removing duplicate rows --
-- deleting duplicate rows --
WITH ranked AS (
    SELECT 
        ctid,
        ROW_NUMBER() OVER (
            PARTITION BY camis, inspection_date, violation_code
            ORDER BY record_date DESC NULLS LAST, ctid
        ) AS rn
    FROM inspections_copy
)
DELETE FROM inspections_copy
WHERE ctid IN (
    SELECT ctid FROM ranked WHERE rn > 1
)
;

														-- updates in cuisine table --
-- updating cuisine table classifictaion for unknown, not listed and others --
update cuisine
set classification = 'Not Known'
where cuisine_description in ('Unknown', 'Not Listed/Not Applicable', 'Other')
;

													-- cleaning necessary string columns -- 
-- trimming extra spaces from violation_description --
update inspections_copy
set violation_description = trim(violation_description)
;

-- changing dba to proper case -- 
update inspections_copy
set dba = initcap(dba)
;

-- changing string case and extra space in street column --
update inspections_copy
set street = initcap(trim(street))
;
----------------------------------------------------------------------------------
-- creating a view for cleaned, usable & relevant inspections data --
create view inspections_clean as 
select 
	camis, 
	dba,
	boro,
	building, 
	street,
	zipcode,
	ic.cuisine_description,
	c.classification,
	inspection_date,
	action,
	violation_code,
	violation_description,
	critical_flag,
	score,
	imputed_score,
	grade,
	grade_date,
	inspection_type
from inspections_copy as ic
left join cuisine as c 
	using(cuisine_description)
;
---------------------------------------------------

-- checking the inspections_clean view -- 
SELECT *
from inspections_clean













