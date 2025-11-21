															-- overall insights --

-- total inspections by borough --
select
	boro,
	count(*) as tot_inspections,
	round(100 * count(*) / sum(count(*)) over (),2) || '%' as percentage
from inspections_clean
where action != 'not yet inspected'
group by boro
order by 2 desc
; -- top 3 boros with most inspections are manhattan, brooklyn and queens --


-- grade distributions aross nyc --
select 
	grade,
	count(*) as inspections,
	round(100 * count(*) / sum(count(*)) over(), 2) || '%' as percentage
from inspections_clean
group by grade
order by 2 desc
; -- more than half of the resteraunts in nyc havent been graded or their inspections are pending. wheras, 33% percent of resteraunts in nyc have been garded 'A'. 
							-- and less than 10% of them have been graded grade 'B' or 'C'

-- grade distribution across boroughs--
select 
	boro,
	grade,
	count(*) as inspections,
	sum(count(*)) over(partition by boro) as boro_tot_inspections,
	round(100 * count(*)/sum(count(*)) over(partition by boro), 2) || '%' as boro_grade_percentage
from inspections_clean
group by boro, grade
order by 1,3 desc
; -- in all boroughs almost half of them have not been inspected/ graded. other than that, around 30% of resteraunts in each boro are graded 'A'


-- inspection types % --
select 
	inspection_type,
	count(*) as inspections,
	round(100 * count(*) / sum(count(*)) over(), 2) || '%' as percentage
from inspections_clean
group by inspection_type
order by 2 desc
; -- common inspection types are- cycle inspection for initial and re-inspection followed by pre permit (ops) initial inspection 


															-- violation insights --

-- top 10 violation codes along with decsription--
select 
	violation_code,
	violation_description,
	count(*) as violation_count,
	round(100 * count(*) / sum(count(*)) over(), 2) || '%' as percentage
from inspections_clean
group by violation_code, violation_description
order by 3 desc
limit 10
;

-- finding out the occurence of top violations in different boros --
select 
	boro,
	count(*) as inspections_count,
	sum(count(*)) over() as overall_top_violations,
	round(100 * count(*) / sum(count(*)) over(), 2) || '%' as percentage
from inspections_copy
where violation_code in (
						select 
							violation_code
						from inspections_copy
						group by violation_code
						order by count (*) desc
						limit 10 
						)-- subquery for top 10 violations --
group by boro 
order by 2 desc
;		-- manhattan, brooklyn, queens have the most ocuurances of top violation -- 


-- critical and non critical inspections count across nyc --
select 
	critical_flag,
	count(*) as inspections,
	round(100 * count(*) / sum(count(*)) over(), 2) || '%' as percentage
from inspections_clean
where action != 'not yet inspected'
group by critical_flag
order by 2 desc
; -- nyc has more than half criical violations 


-- critical and non critical violations % across each boro --
select
	boro,
	critical_flag,
	count(*) as inspections_count,
	round(100 * count(*) / sum(count(*)) over(), 2) || '%' as percentage
from inspections_clean
where action != 'not yet inspected'
	and critical_flag != 'Not Applicable'
group by boro, critical_flag
order by 1, 3 desc
; -- the boro with most critical violations out of all are - manhattan, brooklyn, queens, bronx, staten island


-- critical violations % to each boros tot inspections --
select
	boro,
	count(*) as tot_inspections,
	sum(case 
		when critical_flag = 'Critical' then 1
		else 0
	end) as critical_violations_count,
	
	(100 * sum(case 
		when critical_flag = 'Critical' then 1
		else 0
	end) / count(*)) || '%' as critical_violations_rate
from inspections_clean
where action != 'not yet inspected'
group by boro
; -- Over half of all inspections in every borough reveal critical violations.


											-- cuisine analysis --
-- grades % across cuisine classifictaion --
select
	classification,
	grade,
	count(*) as inspections_count,
	sum(count(*)) over(partition by classification) as cuisine_tot_inspections,
	round(100 * count(*) / sum(count(*)) over(partition by classification),2) || '%' as grade_percenatge
from inspections_clean
where action != 'not yet inspected' 
group by  classification, grade
order by 1, 3 desc
; -- more than half of the resteraunts in each classification have not been graded / pending inspection. 
	

-- top 5 cuisines with lowest average score --
select
	classification,
	round(avg(imputed_score), 2) as avg_score
from inspections_clean
where action != 'not yet inspected'
group by classification
order by 2 asc
limit 5 
; -- east asian & pacifics and  middle eastern & african cusisne classification has the lowest percetage of grade A wrt to toal inspections in each cusine classification resp.


-- critical and non critical violations % across different cusisines --
select 
	classification, 
	critical_flag,
	count(*) as violations_count,
	round(100 * count(*) / sum(count(*)) over(), 2) || '%' as percentage
	from inspections_clean
where critical_flag != 'Not Applicable' 
	and action != 'not yet inspected'
group by classification, critical_flag
order by 1, 3 desc
; -- east asian & pacific , north & south american have the most critical violations out of all --


-- critical violations % of each cuisine classification to total overal critical violations --
select 
	classification,
	count(*) as critical_violations,
	sum(count(*)) over() as overall_tot_critical_violations,
	round(100 * count(*) / sum(count(*)) over() , 2) || '%' as critical_violation_percenatge
from inspections_clean
where action!= 'not yet inspected' and critical_flag = 'Critical'
group by classification
order by 2 desc
; -- The East Asian & Pacific, North & South American, and Entrées & Specialized Main Dishes classifications report the highest proportion of critical violations relative to total inspections within their respective categories.


-- critical violations % to each cuisine classification inspections --
select
	classification,
	count(*) as tot_inspections,
	sum(case 
		when critical_flag = 'Critical' then 1
		else 0
	end) as critical_violations_count,
	
	(100 * sum(case 
		when critical_flag = 'Critical' then 1
		else 0
	end) / count(*)) || '%' as critical_violations_rate
from inspections_clean
where action != 'not yet inspected'
group by classification
order by 3 desc
;

