WITH source AS (
    SELECT *
    FROM {{ source('raw_dog', 'source_nyc_dog_licensing') }}
),

cleaned AS (
    SELECT
        -- Animal info
        CAST(animalname AS STRING) AS animal_name,
        UPPER(TRIM(CAST(animalgender AS STRING))) AS animal_gender,
        SAFE_CAST(animalbirth AS INT64) AS animal_birth_year,

        -- Breed name 
        UPPER(TRIM(CAST(breedname AS STRING))) AS breed_name,

        -- Zip code 
        CASE
            WHEN zipcode IS NULL THEN NULL
            WHEN LENGTH(TRIM(CAST(zipcode AS STRING))) = 5 THEN TRIM(CAST(zipcode AS STRING))
            ELSE NULL
        END AS zip_code,

        -- Date parsing 
        CASE
            WHEN licenseissueddate IS NULL THEN NULL
            ELSE SAFE.PARSE_DATE('%m/%d/%Y', TRIM(licenseissueddate))
        END AS license_issued_date,

        CASE
            WHEN licenseexpireddate IS NULL THEN NULL
            ELSE SAFE.PARSE_DATE('%m/%d/%Y', TRIM(licenseexpireddate))
        END AS license_expired_date,

        SAFE_CAST(extract_year AS INT64) AS extract_year,

        
        CURRENT_TIMESTAMP() AS _stg_loaded_at

    FROM source
    WHERE animalname IS NOT NULL
      AND breedname IS NOT NULL

    
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY animalname, breedname, animalgender, animalbirth, zipcode
        ORDER BY licenseissueddate DESC
    ) = 1
)

SELECT * FROM cleaned