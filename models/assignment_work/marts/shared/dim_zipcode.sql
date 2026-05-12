WITH all_zipcodes AS (
    SELECT DISTINCT
        borough,
        incident_zip AS zipcode
    FROM {{ ref('stg_311nyc_dog_complaints') }}
    WHERE incident_zip IS NOT NULL
    UNION DISTINCT
    SELECT DISTINCT
        'Unknown' AS borough,
        zip_code AS zipcode        
    FROM {{ ref('stg_nyc_dog_licensing') }}
    WHERE zip_code IS NOT NULL
),
zipcode_dimension AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['borough', 'zipcode']) }} AS zipcode_key,
        zipcode,
        borough
    FROM all_zipcodes
)
SELECT * FROM zipcode_dimension