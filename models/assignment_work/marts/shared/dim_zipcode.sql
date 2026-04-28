WITH all_zipcodes AS (

  SELECT DISTINCT
    incident_zip AS zipcode,
    borough
  FROM {{ ref('stg_nyc_311_dot') }}
  WHERE incident_zip IS NOT NULL

  UNION DISTINCT

  SELECT DISTINCT
    zip_code AS zipcode,
    NULL AS borough
  FROM {{ ref('stg_nyc_dog_licensing') }}
  WHERE zip_code IS NOT NULL
),

zipcode_dimension AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key(['zipcode', 'borough']) }} AS zipcode_key,
    zipcode,
    borough
  FROM all_zipcodes
)

SELECT *
FROM zipcode_dimension