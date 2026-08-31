/*
Filter conditions to those that were classified and pick the classification
with the greatest probability (that's the greatest logic). This logic removes
any rows that were not classified.
*/
{{ config(
     enabled = var('claims_enabled', False) | as_bool
   )
}}

with typed_probabilities as (

    select
        encounter_id
      , data_source
      , primary_diagnosis_code
      , primary_diagnosis_code_type
      , cast(edcnnpa as {{ dbt.type_numeric() }}) as edcnnpa
      , cast(edcnpa as {{ dbt.type_numeric() }}) as edcnpa
      , cast(epct as {{ dbt.type_numeric() }}) as epct
      , cast(noner as {{ dbt.type_numeric() }}) as noner
      , cast(injury as {{ dbt.type_numeric() }}) as injury
      , cast(psych as {{ dbt.type_numeric() }}) as psych
      , cast(alcohol as {{ dbt.type_numeric() }}) as alcohol
      , cast(drug as {{ dbt.type_numeric() }}) as drug
      , ed_classification_capture
    from {{ ref('ed_classification__map_primary_dx') }}

)

select
   a.encounter_id
   , a.data_source
   , a.primary_diagnosis_code
   , a.primary_diagnosis_code_type
   , a.edcnnpa
   , a.edcnpa
   , a.epct
   , a.noner
   , a.injury
   , a.psych
   , a.alcohol
   , a.drug
   , a.ed_classification_capture
   , case greatest(a.edcnnpa, a.edcnpa, a.epct, a.noner, a.injury, a.psych, a.alcohol, a.drug)
          when a.edcnnpa then 'edcnnpa'
          when a.edcnpa then 'edcnpa'
          when a.epct then 'epct'
          when a.noner then 'noner'
          when a.injury then 'injury'
          when a.psych then 'psych'
          when a.alcohol then 'alcohol'
          when a.drug then 'drug'
          else 'unclassified'
   end as classification
from typed_probabilities as a
where a.ed_classification_capture = 1
