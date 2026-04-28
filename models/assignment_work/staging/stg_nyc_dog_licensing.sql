-- Clean and standardize NYC dog licensing data
-- One row per dog licensing record

WITH source AS (
  SELECT *
  FROM {{ source('raw_dog', 'source_nyc_dog_licensing') }}
),

cleaned AS (
  SELECT
    CAST(animalname AS STRING) AS animal_name,
    CAST(animalgender AS STRING) AS animal_gender,
    SAFE_CAST(animalbirth AS INT64) AS animal_birth_year,
    CAST(breedname AS STRING) AS breed_name,

    CASE
      WHEN zipcode IS NULL THEN NULL
      WHEN LENGTH(TRIM(CAST(zipcode AS STRING))) = 5 THEN TRIM(CAST(zipcode AS STRING))
      ELSE NULL
    END AS zip_code,

    SAFE_CAST(licenseissueddate AS DATE) AS license_issued_date,
    SAFE_CAST(licenseexpireddate AS DATE) AS license_expired_date,
    SAFE_CAST(extract_year AS INT64) AS extract_year,

    CURRENT_TIMESTAMP() AS _stg_loaded_at

  FROM source
  WHERE zipcode IS NOT NULL
)

SELECT *
FROM cleaned