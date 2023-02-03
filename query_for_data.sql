SET search_path to ctgov; 
-- CTE to get ID's for studies that are phase 3 and interventional
WITH relevant_ids AS (
	SELECT nct_id
	FROM studies
	WHERE phase like '%Phase 3%' -- this keeps Phase 2/Phase 3 and Phase 3 studies
	AND study_type = 'Interventional'
),

-- CTE to select required columns from studies table
study_subtable AS (
	SELECT nct_id,
		start_date, 
		start_date_type, 
		study_type,
		phase,
		overall_status, 
		last_known_status,
	    brief_title
	FROM studies
	WHERE nct_id IN (SELECT nct_id FROM relevant_ids)
),

-- CTE to select required columns from eligibilities table
eligibility_subtable AS (
	SELECT nct_id, 
		population,
		gender_description,
		minimum_age,
		maximum_age,
		criteria,
		gender,
		healthy_volunteers
	FROM eligibilities
	WHERE nct_id IN (SELECT nct_id FROM relevant_ids)
),

-- CTE FOR COUNTRIES
country_subtable AS (SELECT nct_id,
	ARRAY_REMOVE(ARRAY_AGG(DISTINCT CASE WHEN removed IS FALSE THEN c.name ELSE NULL END ), NULL) AS countries_retained,
	ARRAY_REMOVE(ARRAY_AGG(DISTINCT CASE WHEN removed THEN c.name ELSE NULL END ), NULL) AS countries_removed
FROM countries c
GROUP BY nct_id),


-- CTE to select conditions
conditions_subtable AS (
	SELECT nct_id,
		string_agg(concat(downcase_name), ', ') AS conditions_table
	FROM conditions
	WHERE nct_id IN (SELECT nct_id FROM relevant_ids)
	GROUP BY nct_id
),

-- CTE to select mesh terms
mesh_subtable AS (
	SELECT nct_id,
	string_agg(concat(downcase_mesh_term), ', ') AS mesh_term
	FROM browse_conditions
	WHERE nct_id IN (SELECT nct_id FROM relevant_ids)
	GROUP BY nct_id
)



-- NOW JOIN ALL SUBTABLES
SELECT s.*,
	e.population,
	e.gender_description,
	e.minimum_age,
	e.maximum_age,
	e.gender,
	e.healthy_volunteers,
	c.countries_removed,
	c.countries_retained,
	cond.conditions_table,
	m.mesh_term,
	e.criteria
FROM study_subtable s
LEFT JOIN eligibility_subtable e ON s.nct_id = e.nct_id
LEFT JOIN country_subtable c ON s.nct_id = c.nct_id
LEFT JOIN conditions_subtable cond ON s.nct_id = cond.nct_id
LEFT JOIN mesh_subtable m ON s.nct_id = m.nct_id;