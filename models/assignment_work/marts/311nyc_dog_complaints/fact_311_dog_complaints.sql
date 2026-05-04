WITH source AS (
    SELECT *
    FROM {{ ref('stg_311nyc_dog_complaints') }}
),

final AS (
    SELECT
        request_id AS unique_key,

        -- Incident Address Key 
        {{ dbt_utils.generate_surrogate_key([
            'incident_address',
            'street_name',
            'address_type',
            'city',
            'community_board',
            'council_district'
        ]) }} AS incident_address_key,

        -- Location Key 
        {{ dbt_utils.generate_surrogate_key([
            'latitude',
            'longitude'
        ]) }} AS location_id,

        -- Complaint Type Key 
        {{ dbt_utils.generate_surrogate_key([
            'complaint_type',
            'descriptor',
            'descriptor_2',
            'status'
        ]) }} AS complaint_type_key,

        -- Agency Key 
        {{ dbt_utils.generate_surrogate_key(['agency']) }} AS agency_key,

        -- Zipcode Key 
        {{ dbt_utils.generate_surrogate_key(['incident_zip']) }} AS zipcode_key,

        -- Date Key
        {{ dbt_utils.generate_surrogate_key([
            'CAST(created_date AS DATE)'
        ]) }} AS created_date_key,

        -- Location Type Key 
        {{ dbt_utils.generate_surrogate_key(['location_type']) }} AS location_type_key,

        -- Measures
        latitude,
        longitude

    FROM source
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
)

SELECT * FROM final