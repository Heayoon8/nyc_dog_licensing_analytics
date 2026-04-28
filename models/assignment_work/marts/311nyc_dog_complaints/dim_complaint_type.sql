WITH complaint_types AS (
  SELECT DISTINCT
    complaint_type,
    descriptor,
    CAST(NULL AS STRING) AS additional_descriptor,
    status
  FROM {{ ref('stg_nyc_311_dot') }}
  WHERE complaint_type IS NOT NULL
),

final AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key([
      'complaint_type',
      'descriptor',
      'additional_descriptor',
      'status'
    ]) }} AS complaint_type_key,
    complaint_type,
    descriptor,
    additional_descriptor,
    status
  FROM complaint_types
)

SELECT *
FROM final