WITH agencies AS (
    SELECT DISTINCT
        agency,
        agency_name
    FROM {{ ref('stg_311nyc_dog_complaints') }}
    WHERE agency IS NOT NULL
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['agency']) }} AS agency_key,
        agency,
        agency_name
    FROM agencies
)

SELECT * FROM final