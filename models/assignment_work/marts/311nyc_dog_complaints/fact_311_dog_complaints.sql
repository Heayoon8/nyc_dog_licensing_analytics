WITH source AS (
    SELECT *
    FROM {{ ref('stg_311nyc_dog_complaints') }}
)

SELECT
    s.request_id AS unique_key,


    a.agency_key,
    z.zipcode_key,
    d.date_key AS created_date_key,
    loc.location_id,
    inc.incident_address_key,
    ct.complaint_type_key,
    lt.location_type_key,

    
    s.latitude,
    s.longitude

FROM source s
LEFT JOIN {{ ref('dim_agency') }} a
    ON s.agency = a.agency

LEFT JOIN {{ ref('dim_zipcode') }} z
    ON CAST(s.incident_zip AS STRING) = z.zipcode

LEFT JOIN {{ ref('dim_date') }} d
    ON CAST(s.created_date AS DATE) = d.full_date

LEFT JOIN {{ ref('dim_location') }} loc
    ON s.latitude = loc.latitude
    AND s.longitude = loc.longitude

LEFT JOIN {{ ref('dim_incident_address') }} inc
    ON s.incident_address = inc.incident_address
    AND s.street_name = inc.street_name
    AND s.address_type = inc.address_type
    AND s.city = inc.city
    AND s.community_board = inc.community_board
    AND s.council_district = inc.council_district

LEFT JOIN {{ ref('dim_complaint_type') }} ct
    ON s.complaint_type = ct.complaint_type
    AND s.descriptor = ct.descriptor
    AND s.descriptor_2 = ct.additional_descriptor
    AND s.status = ct.status

LEFT JOIN {{ ref('dim_location_type') }} lt
    ON s.location_type = lt.location_type

WHERE s.latitude IS NOT NULL
AND s.longitude IS NOT NULL