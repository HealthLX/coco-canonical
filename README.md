# coco-canonical

#### Unit Test Status
![Pytest](https://github.com/teschglobal/hlx-saas/actions/workflows/unit_tests.yml/badge.svg)

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

## 1. Project Overview
This repository contains the HealthLX canonical data models used for ingestion and mapping to FHIR, along with several features to support use of those canonical models in a real-world environment. These canonical models use XML Schema (XSD) version 1.0 for maximum compatibility across systems. To shape the development and management of this project a set of guiding principles has been developed:

### Guiding Principles
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

### Sample Files

Sample files are generated from the canonical schema files provided. The sample file generator uses the faker library in python. Sample files can be used to create realistic data for testing purposes in systems, or for use in collaboration with industry partners on what instances of these canonical files should look like.

#### How to setup and run sample file generator
| **Step**     | **Command**                  |
|--------------|------------------------------|
| Run the create script  | `python validation/scripts/generate_sample_xml.py`|
* This must be run from the root directory

### Testing

Testing is organized into unit tests and integration tests. Unit tests are included in this project whereas integration tests are not, so this section is primarily focused on what unit tests are included and how to execute them.

#### Unit Tests

##### Overview

It is important to note that when executing the unit tests using the sample files being generated, the test is not validating whether or not the sample files are valid, because we know they already are. Validating a file against a schema from which is was created effectively proves nothing. However, we can validate other aspects using this approach

Unit tests validate at the individual canonical file level to:
- verify all changes made to canonical XDS files are valid XSD 1.0
- verify sample file generator is working properly

##### Execution

Unit tests use the pytest library. and are setup to run on commit of any code to main branch in this repo. They can, and should be run locally prior to a commit to any source control branch.

To run unit tests locally:
- First, ensure your environment for python is setup and running.
- Then, run all the test scripts in the tests folder using this script:
  - `pytest tests/unit`

#### Integration Tests

Integration tests are not included in the open source version of this project.

### Mapping

Canonical to FHIR mappings are not included in the open source version of this project.

## 4. Environment Setup

The following environment setup is required for all of the above features. Python3 must be installed - instructions can be found for your operating system at https://www.python.org/. 


### Setup python virtual environment

While not required, using a python virtual environment will help to keep things isolated from any OS level configuration your system may have with python. A requirements.txt file is included in the source control package for restoring all dependencies.

| **Step**                                 | **Command**                                   |
|------------------------------------------|-----------------------------------------------|
| Create Python virtual environment        | `python3 -m venv venv`                        |
| Activate virtual environment             | `source venv/bin/activate`                    |
| Install dependencies from requirements   | `pip install -r requirements.txt`  |
| Update the requirements.txt file         | `pip freeze > requirements.txt`    |

### Refresh python virtual environment

Sometimes the virtual environment will get into a bad state. Deactivating and reactivating it should resolve any issues.

| **Step**                                 | **Command**                                  |
|------------------------------------------|----------------------------------------------|
| deactivate current environment           | `deactivate`                                 |
| follow the steps above                   | n/a                                          |  