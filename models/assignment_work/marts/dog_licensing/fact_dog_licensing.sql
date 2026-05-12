WITH source AS (
    SELECT *
    FROM {{ ref('stg_nyc_dog_licensing') }}
)

SELECT
    -- Primary Key
    {{ dbt_utils.generate_surrogate_key([
        'source.animal_name',
        'source.animal_gender',
        'source.animal_birth_year',
        'source.breed_name',
        'source.zip_code',
        'source.license_issued_date',
        'source.license_expired_date'
    ]) }} AS licensing_id,

    source.animal_name,

    ac.animal_characteristics_key,
    gb.gender_birth_year_key,
    z.zipcode_key,
    d1.date_key AS license_issued_date_key,
    d2.date_key AS license_expired_date_key,

    CAST(source.extract_year AS STRING) AS extract_year

FROM source

LEFT JOIN {{ ref('dim_animal_characteristics') }} ac
    ON source.breed_name = ac.breed_name

LEFT JOIN {{ ref('dim_gender_and_birth_year') }} gb
    ON source.animal_gender = gb.animal_gender
    AND CAST(source.animal_birth_year AS STRING) = gb.animal_birth_year

LEFT JOIN {{ ref('dim_zipcode') }} z
    ON CAST(source.zip_code AS STRING) = z.zipcode
    AND z.borough = 'Unknown'

LEFT JOIN {{ ref('dim_date') }} d1
    ON source.license_issued_date = d1.full_date

LEFT JOIN {{ ref('dim_date') }} d2
    ON source.license_expired_date = d2.full_date