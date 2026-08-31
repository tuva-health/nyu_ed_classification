# NYU ED Classification

dbt package for the Tuva Project NYU ED Classification data mart.

## Data assets

Seed contents load from
`s3://tuva-public-resources/data-marts/nyu-ed-classification/<asset-version>/`.
The checked-in CSV files are header-only dbt loader contracts; their seed YAML
defines the relations, types, and tests.

`nyu_ed_classification_data_asset_version` selects the folder and defaults to
`1.0.0`. The data-asset version is intentionally independent of this package's
code version, and maintainers coordinate the two values when an asset changes.
Cloud `_manifest.json` and `_release.json` files are maintenance metadata and
are not read by dbt at runtime.
