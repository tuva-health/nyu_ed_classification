# NYU ED Classification

`nyu_ed_classification` applies the NYU emergency department algorithm to
standardized Tuva Core encounters. It classifies ED visits from their primary
diagnosis and makes the classification available with patient, facility, and
claim-cost context.

## What this package produces

The public `ed_classification.summary` model contains one row per emergency
department encounter and `data_source`. It includes:

- the resolved NYU ED classification when the primary diagnosis matches the
  Johnston lookup;
- the encounter's diagnosis, dates, and paid, allowed, and charge amounts;
- patient demographic and geographic fields; and
- facility NPI, name, location, and provider attributes.

Unmatched ED visits remain in the summary with null classification fields, so
the output can also be used to measure classification capture.

## Prerequisites and dependency ownership

This package requires dbt `>=1.10.5,<3.0.0`, claims data, and a Tuva connector
or other root dbt project that installs a compatible Tuva Core revision. The
root project must produce `core__encounter`, `core__patient`, and
`provider_data__provider`.

The root project owns the Tuva Core version so that one dependency graph
controls the shared Core installation. For that reason, this package
intentionally does not declare Tuva Core in its own dependency manifest. It
has no additional dbt package dependencies.

## Installation

Declare Tuva Core and this package once in the root project's
`packages.yml`. Use the immutable 1.0 release tags:

```yaml
packages:
  - git: "https://github.com/tuva-health/tuva-core.git"
    revision: "v1.0.0"
  - git: "https://github.com/tuva-health/nyu_ed_classification.git"
    revision: "v1.0.0"
```

After these releases are available on dbt Hub, the equivalent installation is:

```yaml
packages:
  - package: tuva-health/the_tuva_project
    version: 1.0.0
  - package: tuva-health/nyu_ed_classification
    version: 1.0.0
```

Then install dependencies:

```shell
dbt deps
```

## Configuration and usage

The models are enabled when the root project supplies claims data:

```yaml
vars:
  claims_enabled: true
```

Set `tuva_schema_prefix` to prefix the default `ed_classification` schema.
Most projects should leave `nyu_ed_classification_data_asset_version` at its
package default.

Run the complete package, including its package-owned seed ancestors, with:

```shell
dbt build --select package:nyu_ed_classification
```

## Data assets

The package owns its NYU classification categories and ICD-9-CM and ICD-10-CM
Johnston lookup tables. Seed contents load from
`s3://tuva-public-resources/data-marts/nyu-ed-classification/<asset-version>/`.
Checked-in CSV files are header-only loader contracts.

`nyu_ed_classification_data_asset_version` defaults to `1.0.0`; the data-asset
version is intentionally independent of this package's code version. Public
cloud manifests are maintenance metadata and are not read by dbt at runtime.

## Supported warehouses

The package is designed for Snowflake, BigQuery, Databricks, Microsoft Fabric,
Redshift, and DuckDB when used with the matching Tuva Core adapter. Its models
and unit fixtures have been checked for compilation and parsing across that
warehouse set; complete execution still depends on the connector and Core
relations supplied by the root project.

## Documentation and contributing

- [NYU ED Classification documentation](https://thetuvaproject.com/data-marts/ed-classification)
- [NYU Wagner algorithm background](https://wagner.nyu.edu/faculty/billings/nyued-background)
- [Issues and feature requests](https://github.com/tuva-health/nyu_ed_classification/issues)
- [Tuva community Slack](https://join.slack.com/t/thetuvaproject/shared_invite/zt-16iz61187-G522Mc2WGA2mHF57e0il0Q)

Contributions are welcome through GitHub issues and pull requests. This
project is licensed under the [Apache License 2.0](LICENSE).
