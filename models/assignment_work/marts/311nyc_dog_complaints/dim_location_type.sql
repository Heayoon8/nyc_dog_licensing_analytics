WITH location_types AS (
    SELECT DISTINCT
        location_type
    FROM {{ ref('stg_311nyc_dog_complaints') }}
    WHERE location_type IS NOT NULL
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['location_type']) }} AS location_type_key,
        location_type
    FROM location_types
)

SELECT * FROM final