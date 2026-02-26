# coco-canonical

#### Unit Test Status
![Pytest](https://github.com/teschglobal/hlx-saas/actions/workflows/unit_tests.yml/badge.svg)

## Dynamic Canonical Schema Documentation
**Live docs:** https://healthlx.github.io/coco-canonical/

# Table of Contents
- [1. Project Overview](#1overview)
  - [Guiding Prinicples](#guiding-prinicples)
- [2. Engagement Opportunities](#engagement-opportunities)
- [3. Project Features](#project-features)
- - [Canonical Models](#canonical-models)
    - [Canonical Model Composition](#canonical-model-composition)
  - [Documentation](#auto-generated-documentation)
      - [How to Publish Documentation](#how-to-publish-documentation)
  - [Sample Files](#auto-generated-sample-files)
      - [How to setup and run sample file generator](#how-to-setup-and-run-sample-file-generator)
  - [Testing](#testing)
    - [Unit Tests](#unit-tests)
    - [Integration Tests](#integration-tests)
  - [Mapping](#mapping)
- [4. Environment Setup](#environment-setup)
  - [Setup python virtual environment](#setup-python-virtual-environment)
  - [Refresh python virtual environment](#refresh-python-virtual-environment)
  - [How to run script](#how-to-run-script)

## 1. CoCo Project Overview
This repository contains the HealthLX canonical data models used for ingestion and mapping to FHIR, along with several features to support use of those canonical models in a real-world environment. These canonical models use XML Schema (XSD) version 1.0 for maximum compatibility across systems.


### Why CoCo Exists
CMS interoperability regulations (including CMS-9115-F and CMS-0057-F) define *what* must happen, but not *how* systems should implement, observe, or explain compliance in real-world environments. CoCo exists to provide a **canonical, open, and inspectable representation of CMS compliance intent** that can be consistently implemented across heterogeneous payer systems and downstream FHIR platforms. CoCo does not replace payer adjudication logic. CoCo makes compliance **explicit, observable, and explainable**.

### What CoCo Does *Not* Do
CoCo does not attempt to:
- Certify the correctness of utilization management decisions
- Replace payer-specific adjudication logic
- Guarantee deterministic outcomes from legacy UM systems

CMS-0057-F prior authorization responses depend on decision logic embedded in payer systems that may be opaque, non-deterministic, or human-influenced. CoCo focuses on **process conformance and interface integrity**, not adjudication correctness.

### Who CoCo is for
| Audience       | Value Provided |
|---------------|----------------|
| Developers    | Clear, versioned compliance artifacts without interpreting regulation text |
| Regulators    | Transparent, inspectable representations of regulatory intent |
| Health Plans  | Reduced compliance ambiguity and improved audit readiness |
| Vendors       | A neutral, canonical compliance layer independent of platform |

### Governance & Evolution
CoCo is an open-source project stewarded by [HealthLX](https://healthlx.com) and the community. Its evolution is driven by:
- Changes in CMS regulations
- Community feedback and implementation experience
- A commitment to transparency, reproducibility, and regulatory alignment

All canonical artifacts are versioned and traceable to regulatory source material.

### Guiding Principles
To shape the development and management of this project a set of guiding principles has been developed:
1. Reuse is encouraged where possible, so long as it does not create overly complex schema models
2. A strongly typed model approach will be used to drive consistent business meaning
3. All schema files will follow consistent XML namespace and versioning practices
4. Cardinality and occurrence control will be utilized where possible to define concrete implementation to provide alignment with downstream validation against FHIR
5. `xs:documentation` blocks will be used to support clear documentation
6. `xs:simpleTypes` will be given a name and only defined where they constrain an existing simple type (.e.g, positive integer)
7. `xs:complexTypes` will be given a name
8. `xs:element` will be used at the top level to group items within a schema (e.g., `roster->member` in the Roster model)
9. `xs:group` is used to defined reusable collections of elements
10. xmlschema is used for validation in support of strict W3C compliance to XSD

## 2. Engagement Opportunities

The concepts that exist currently need to be built upon and improved. We are hopeful that this happens with help from the community and encourage pull requests be made against this repo. All pull request will require review and approval before being merged and released.

## 3. Project Features
The features of this project are organized into: Canonical Models, Documentation, Samples, Testing, and Mapping.

### Canonical Models
There are currently 5 canonical models available representing the majority of the data elements needed for compliance with CMS-9115, specifically for the Patient Access API and Provider Directory API. 

Future versions of these canonicals will include models for CMS-0057 compliance, including the Provider Access API, Payer to Payer API, and Prior Authorization API.

These models represent a subset of the data required for each of these APIs and will be expanded as implementations across the industry mature. The intention is not to replace the required or recommended underlying FHIR Implementation Guides, but rather to compliment them, providing an implementation path for organizations looking to implement.

These models may also be leveraged by existing organizations that have already invested in Patient Access and Burden Reduction functionality, but choosing to use them to adapt their solutions to a common model in use by industry exchange partners.

The five canonical models and their composition are:

#### Canonical Model Composition

| Schema           | complexTypes | simpleTypes | elements | groups |
|------------------|--------------|-------------|----------|--------|
| Roster           | YES          | YES         | YES      | NO     |
| EOB              | YES          | YES         | YES      | YES    |
| ProviderDirectory| YES          | YES         | YES      | NO     |
| Formulary        | YES          | YES         | YES      | NO     |
| Clinical         | YES          | YES         | YES      | YES    |

### Documentation
Documentation is automatically generated using python, with the output published in markdown for simplicty and portability.

#### How to Publish Documentation
- Click on `Releases`
- Click `Draft a new release`
- Give the release a title of `Provider Directory IG - Release 2025-xx-xx` with the current date
- Click `Choose a tag` and provide an appropriate tag version such as `v0.6`
- Ensure that:
  - `Set as a pre-release` is unchecked
  - `Set as the latest release` is checked
- Click `Publish release`

#### Quick Documentation Generation Tool

Use `build_xsd_docs.py` to quickly generate markdown documentation for all XSD schemas in a specified `schemas/` subfolder:

**Input Parameters:**
- `subfolder` (required): Subfolder name within `schemas/` directory (e.g., `v10.0`)
- `--release-tag` or `-r` (optional): Release tag for versioning

```bash
# Generate docs for schemas in schemas/v10.0/
python tools/build_xsd_docs.py v10.0

# With optional release tag
python tools/build_xsd_docs.py v10.0 --release-tag v0.6
```

The script processes all `.xsd` files in the specified directory and generates corresponding markdown files in `docs/`.

### Sample Files

Sample files are generated from the canonical schema files provided. The sample file generator uses the faker library in python. Sample files can be used to create realistic data for testing purposes in systems, or for use in collaboration with industry partners on what instances of these canonical files should look like.

While the canonical schema files are used to generate the sample files, this does not automatically mean that they are correct. Unit tests will be added that will generate the files and then validate against the schema files to ensure valid XML is being generated against the canonical schema. This ensures the generators do not start creating invalid data.

#### How to setup and run sample file generator
| **Step**     | **Command**                  |
|--------------|------------------------------|
| Run the create script  | `python -m tools.build_all_sample_files`|
* This must be run from the root directory

### Testing

Testing is organized into unit tests and integration tests. Unit tests are included in this project whereas integration tests are not, so this section is primarily focused on what unit tests are included and how to execute them.

#### Unit Tests

##### Overview

Currently there are two primary types of unit tests:
1. Validation of generated files against their schema files to ensure the generators continue creating valid XML to the schema each one uses.
2. Validation of canonical schema files to ensure valid XML Schema 1.0

##### Execution

Unit tests use the pytest library. and are setup to run on commit of any code to main branch in this repo. They can, and should be run locally prior to a commit to any source control branch.

To run unit tests locally:
- First, ensure your environment for python is setup and running.
- Then, run all the test scripts in the tests folder using this script:
  - `pytest tests/unit`

#### End-to-End Pipeline Tests

The coco-pipeline runs on pull request creation and uses a detect-changes script to determine which canonical models are affected. When schemas or `config/sample_builds.yaml` change, the pipeline runs for each affected target. It supports multiple schema changes in a single PR: each changed schema (or the shared Core-Model) is processed independently.

For each target, the pipeline:

1. Builds sample XML from the schema
2. Validates the generated XML against the XSD schema
3. Applies an XSLT transform to FHIR only if that schema has a transform configured (e.g. roster → Patient); targets without a transform skip this step
4. Validates the FHIR output against the configured FHIR profile when a transform was applied

So transforms and FHIR validation run only for schemas that have them configured; other targets are built and XSD-validated only.

#### Integration Tests

Integration tests are not included in the open source version of this project.

### Mapping

Canonical to FHIR mappings are not included in the open source of CoCo. Application compliance bindings to Smile Digital Health, Health Samurai, and Firely are available through HealthLX sales. sales@healthlx.com

## 4. Environment Setup

The following environment setup is required for all of the above features. Python3 must be installed - instructions can be found for your operating system at https://www.python.org/. 


### Setup python virtual environment


While not required, using a python virtual environment will help to keep things isolated from any OS level configuration your system may have with python. All dependency management is now handled via `pyproject.toml`.

| **Step**                               | **macOS / Linux Command**                    | **Windows Command**        |
|----------------------------------------|----------------------------------------------|---------------------------|
| Create Python virtual environment      | `python3 -m venv venv`                       | `python -m venv venv`     |
| Activate virtual environment           | `source venv/bin/activate`                   | `venv\Scripts\activate` |
| Install dependencies from pyproject.toml| `pip install .`                             | `pip install .`           |


### Dependency Management via pyproject.toml

All dependency management, project metadata, and tooling configuration are handled in `pyproject.toml`.

| Purpose | macOS / Linux | Windows |
|---------|---------------|---------|
| Install runtime dependencies | `pip install .` | `pip install .` |
| Install with dev/test extras | `pip install .[dev]` | `pip install .[dev]` |
| Install with API extras | `pip install .[api]` | `pip install .[api]` |
| Run tests | `pytest` | `pytest` |

Notes:

1. You do not need to manually maintain a `requirements.txt` file; all dependencies are managed in `pyproject.toml`.
2. To add a new direct dependency, edit the `dependencies` array in `pyproject.toml` and re-run `pip install .`.

#### Updating dependencies

Edit `pyproject.toml` and bump versions (use compatible `<` upper bounds when possible). Then run:

```bash
pip install --upgrade .[dev]
```

#### Why use pyproject.toml?

PEP 621 standardizes project metadata, enables modern build backends and simpler installs (`pip install .`), centralizes tool configuration (e.g., pytest), and prepares the project for publishing if desired.

### Generate sample files via YAML config

The sample file generation is now configuration-driven using YAML. Edit `config/sample_builds.yaml` to add or remove builds, then run:

| Purpose | macOS / Linux | Windows |
|---------|----------------|---------|
| Generate all samples from config | `python -m tools.build_all_sample_files` | `python -m tools.build_all_sample_files` |
| Use a custom config path | `python -m tools.build_all_sample_files --config path/to/file.yaml` | `python -m tools.build_all_sample_files --config path\to\file.yaml` |

YAML keys per build entry:

- `canonical_name` (string)
- `root_element_name` (string)
- `schema_file_name` (string)
- `output_file_name` (string)
- `provider_directory_child` (string, optional)

### HTTP API (for web app / other repo)

A small FastAPI app exposes config, sample building, XSLT transform, and artifact listing/download over HTTP so another repo’s web app can list canonicals, generate samples, run transforms, and pull schemas/transforms/samples.

**Run the API** (from project root, after `pip install .[api]`):

| Purpose | Command |
|---------|--------|
| Start API server | `uvicorn api.main:app --reload` |
| Start on a specific host/port | `uvicorn api.main:app --host 0.0.0.0 --port 8000` |

- Docs (Swagger): **http://localhost:8000/docs**
- Discovery: `GET /builds`, `GET /canonicals`, `GET /config`
- Generate samples: `POST /samples/generate` (body: `{"target": "roster"}` or `{"all": true}`), `POST /samples/generate/{target}`, `POST /samples/generate/{target}/content`
- Transform (canonical → FHIR): `POST /transform` (body: `{"target": "roster"}` or `{"canonical_file": "...", "xslt_file": "..."}`), `POST /transform/{target}`, `POST /transform/{target}/content`
- List/download: `GET /samples`, `GET /samples/canonical`, `GET /samples/fhir`, `GET /schemas`, `GET /transforms`; download via `GET /samples/canonical/{filename}`, `GET /samples/fhir/{filename}`, `GET /schemas/{filename}`, `GET /transforms/{filename}`
- Regenerate and serve: `GET /samples/canonical/{filename}/regenerate`

Config path can be overridden with env `COCO_CONFIG_PATH`.

### Refresh python virtual environment

Sometimes the virtual environment will get into a bad state. Deactivating and reactivating it should resolve any issues.

| **Step**                                 | **Command**                                  |
|------------------------------------------|----------------------------------------------|
| deactivate current environment           | `deactivate`                                 |
| follow the steps above                   | n/a                                          |

