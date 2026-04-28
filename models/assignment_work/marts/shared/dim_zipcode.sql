WITH all_zipcodes AS (

  SELECT DISTINCT
    CAST(incident_zip AS STRING) AS zipcode,
    CAST(borough AS STRING) AS borough
  FROM {{ ref('stg_nyc_311_dot') }}
  WHERE incident_zip IS NOT NULL

  UNION DISTINCT

  SELECT DISTINCT
    CAST(zip_code AS STRING) AS zipcode,
    CAST(NULL AS STRING) AS borough
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