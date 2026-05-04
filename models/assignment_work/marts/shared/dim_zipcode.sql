WITH all_zipcodes AS (
    SELECT DISTINCT
        CAST(incident_zip AS STRING) AS zipcode,
        CAST(borough AS STRING) AS borough
    FROM {{ ref('stg_311nyc_dog_complaints') }}
    WHERE incident_zip IS NOT NULL

    UNION DISTINCT

    SELECT DISTINCT
        CAST(zip_code AS STRING) AS zipcode,
        CAST(NULL AS STRING) AS borough
    FROM {{ ref('stg_nyc_dog_licensing') }}
    WHERE zip_code IS NOT NULL
),


deduped AS (
    SELECT
        zipcode,
        MAX(borough) AS borough
    FROM all_zipcodes
    GROUP BY zipcode
),

zipcode_dimension AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['zipcode']) }} AS zipcode_key,
        zipcode,
        borough
    FROM deduped
)

SELECT * FROM zipcode_dimension