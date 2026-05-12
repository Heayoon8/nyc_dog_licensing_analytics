WITH locations AS (
    SELECT DISTINCT
        CAST(incident_zip AS STRING) AS zipcode,
        CAST(borough AS STRING) AS borough
    FROM {{ ref('stg_311nyc_dog_complaints') }}
    WHERE incident_zip IS NOT NULL
    AND borough IS NOT NULL
),
final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['zipcode', 'borough']) }} AS location_id,
        zipcode,
        borough
    FROM locations
)
SELECT * FROM final