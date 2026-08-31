{{ config(
    enabled = var('claims_enabled', False) | as_bool
) }}

select
    encounter_id
  , data_source
from {{ ref('ed_classification__summary') }}
group by
    encounter_id
  , data_source
having count(*) > 1
