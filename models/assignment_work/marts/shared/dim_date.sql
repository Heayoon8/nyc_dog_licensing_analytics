WITH all_dates AS (

  SELECT DISTINCT CAST(created_date AS DATE) AS full_date
  FROM {{ ref('stg_311nyc_dog_complaints') }}
  WHERE created_date IS NOT NULL

  UNION DISTINCT

  SELECT DISTINCT license_issued_date AS full_date
  FROM {{ ref('stg_nyc_dog_licensing') }}
  WHERE license_issued_date IS NOT NULL

  UNION DISTINCT

  SELECT DISTINCT license_expired_date AS full_date
  FROM {{ ref('stg_nyc_dog_licensing') }}
  WHERE license_expired_date IS NOT NULL
),

date_dimension AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key(['full_date']) }} AS date_key,
    full_date,
    EXTRACT(YEAR FROM full_date) AS year,
    EXTRACT(MONTH FROM full_date) AS month,
    FORMAT_DATE('%B', full_date) AS month_name,
    EXTRACT(DAY FROM full_date) AS day_of_month,
    FORMAT_DATE('%A', full_date) AS day_of_week,
    EXTRACT(DAYOFWEEK FROM full_date) IN (1, 7) AS is_weekend,
    FALSE AS is_holiday
  FROM all_dates
)

SELECT *
FROM date_dimension