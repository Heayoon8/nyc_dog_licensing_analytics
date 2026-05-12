WITH complaints_zip AS (
    SELECT DISTINCT
        borough,
        incident_zip AS zipcode
    FROM {{ ref('stg_311nyc_dog_complaints') }}
    WHERE incident_zip IS NOT NULL
),

licensing_zip AS (
    SELECT DISTINCT
        zip_code AS zipcode
    FROM {{ ref('stg_nyc_dog_licensing') }}
    WHERE zip_code IS NOT NULL
),


all_zipcodes AS (
    SELECT
        lz.zipcode,
        COALESCE(cz.borough, 'Unknown') AS borough
    FROM licensing_zip AS lz
    LEFT JOIN complaints_zip AS cz
        ON lz.zipcode = cz.zipcode

    UNION DISTINCT

    SELECT
        zipcode,
        borough
    FROM complaints_zip
),

zipcode_dimension AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['borough', 'zipcode']) }} AS zipcode_key,
        zipcode,
        borough
    FROM all_zipcodes
)

SELECT * FROM zipcode_dimension