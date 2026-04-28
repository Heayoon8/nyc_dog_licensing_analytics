WITH source AS (
  SELECT *
  FROM {{ ref('stg_311nyc_dog_complaints') }}
),

final AS (
  SELECT
    request_id AS unique_key,

    {{ dbt_utils.generate_surrogate_key([
      'incident_address',
      'street_name',
      'address_type',
      'city',
      'community_board',
      'council_district'
    ]) }} AS incident_address_key,

    {{ dbt_utils.generate_surrogate_key(['latitude', 'longitude']) }} AS location_id,

    {{ dbt_utils.generate_surrogate_key([
      'complaint_type',
      'descriptor',
      'descriptor_2',
      'status'
    ]) }} AS complaint_type_key,

    {{ dbt_utils.generate_surrogate_key(['agency_name']) }} AS agency_key,

    {{ dbt_utils.generate_surrogate_key([
      'incident_zip',
      'borough'
    ]) }} AS zipcode_key,

    {{ dbt_utils.generate_surrogate_key(['created_date']) }} AS created_date_key,

    {{ dbt_utils.generate_surrogate_key(['location_type']) }} AS location_type_key,

    latitude,
    longitude

  FROM source
)

SELECT *
FROM final