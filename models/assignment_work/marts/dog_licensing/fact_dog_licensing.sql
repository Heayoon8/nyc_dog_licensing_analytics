-- Fact table for NYC dog licensing
-- Grain: one row per dog license record

WITH source AS (
  SELECT *
  FROM {{ ref('stg_nyc_dog_licensing') }}
),

final AS (
  SELECT
    -- Primary key (surrogate)
    {{ dbt_utils.generate_surrogate_key([
      'animal_name',
      'animal_gender',
      'animal_birth_year',
      'breed_name',
      'zip_code',
      'license_issued_date',
      'license_expired_date'
    ]) }} AS licensing_id,

    animal_name,

    -- FK to dim_animal_characteristics
    {{ dbt_utils.generate_surrogate_key([
      'breed_name',
      'NULL',
      'NULL'
    ]) }} AS animal_characteristics_key,

    -- FK to dim_gender_and_birth_year
    {{ dbt_utils.generate_surrogate_key([
      'animal_gender',
      'animal_birth_year'
    ]) }} AS gender_birth_year_key,

    -- FK to dim_zipcode
    {{ dbt_utils.generate_surrogate_key([
      'zip_code',
      'NULL'
    ]) }} AS zipcode_key,

    -- FK to dim_date
    {{ dbt_utils.generate_surrogate_key(['license_issued_date']) }} AS license_issued_date_key,
    {{ dbt_utils.generate_surrogate_key(['license_expired_date']) }} AS license_expired_date_key,

    CAST(extract_year AS STRING) AS extract_year

  FROM source
)

SELECT *
FROM final