# coco-canonical

# Overview
This repository contains the HealthLX canonical data models used for ingestion and mapping to FHIR. There are several different features of this repo:

1. Canonical model
2. Auto-generated documentation
3. Auto-generated sample files
4. Unit tests
5. Integration tests

## Guiding Prinicples
 - Reuse is encouraged where possible, so long as it does not create overly complex schema models
 - A strongly typed model approach will be used to drive consistent business meaning
 - All schema files will follow consistent XML namespace and versioning practices
 - Cardinality and occurrence control will be utilized where possible to define concrete implementation to provide alignment with downstream validation against FHIR
 - `xs:documentation` blocks will be used to support clear documentation
 - `xs:simpleTypes` will be given a name and only defined where they constrain an existing simple type (.e.g, positive integer)
 - `xs:complexTypes` will be given a name
 - `xs:element` will be used at the top level to group items within a schema (e.g., `roster->member` in the Roster model)
 - `xs:group` is used to defined reusable collections of elements

### Additional Principles
- xmlschema is used for validation in support of strict W3C compliance to XSD


### Unit Test Status
![Pytest](https://github.com/teschglobal/hlx-saas/actions/workflows/unit_tests.yml/badge.svg)





# Canonical Models
There are currently 5 canonical models available representing the majority of the data elements needed for compliance with CMS-9115, specifically for the Patient Access API and Provider Directory API. 

Future versions of these canonicals will include models for CMS-0057 compliance, including the Provider Access API, Payer to Payer API, and Prior Authorization API.

These models represent a subset of the data required for each of these APIs and will be expanded as implementations across the industry mature. The intention is not to replace the required or recommended underlying FHIR Implementation Guides, but rather to compliment them, providing an implementation path for organizations looking to implement.

These models may also be leveraged by existing organizations that have already invested in Patient Access and Burden Reduction functionality, but choosing to use them to adapt their solutions to a common model in use by industry exchange partners.

The five canonical models are:
- Roster
- Provider Directory
- EOB
- Formulary
- Clinical

## Canonical Model Composition

| Schema           | complexTypes | simpleTypes | elements | groups |
|------------------|--------------|-------------|----------|--------|
| Roster           | YES          | YES         | YES      | NO     |
| EOB              | YES          | YES         | YES      | YES    |
| ProviderDirectory| YES          | YES         | YES      | NO     |
| Formulary        | YES          | YES         | YES      | NO     |
| Clinical         | YES          | YES         | YES      | YES    |


# Engagement Opportunities
The concepts that exist currently need to be built upon and improved. We are hopeful that this happens with help from the community and encourage pull requests be made against this repo. All pull request will require review and approval before being merged and released.

# Project Features

## Auto-Generated Documentation
Documentation is automatically generated using python, with the output published in markdown for simplicty and portability.

### How to Publish Documentation
- Click on `Releases`
- Click `Draft a new release`
- Give the release a title of `Provider Directory IG - Release 2025-xx-xx` with the current date
- Click `Choose a tag` and provide an appropriate tag version such as `v0.6`
- Ensure that:
  - `Set as a pre-release` is unchecked
  - `Set as the latest release` is checked
- Click `Publish release`

## Auto-Generated Sample Files
Sample files can be generated from the canonical schema files provided. The sample file generator uses the faker library in python.

### How to setup and run sample file generator
| **Step**                                 | **Command**                                  |
|------------------------------------------|----------------------------------------------|
| Run the create script                    | `python validation/scripts/generate_sample_xml.py`|
* This must be run from the root directory



## Unit Tests

This section describes how to setup and run unit tests.

First, ensure your environment for python is setup and running.

Then, run all the test scripts in the tests folder using pytest.

`pytest validation/tests`


# Integration Tests

Integration tests are not included in the open source version of this project

# Canonical to FHIR Mapping

Canonical to FHIR mappings are not included in the open source version of this project.

# Environment Setup

The following environment setup is required for all of the above features.

## Setup python virtual environment

| **Step**                                 | **Command**                                  |
|------------------------------------------|----------------------------------------------|
| Create Python virtual environment        | `python3 -m venv venv`                        |
| Activate virtual environment             | `source venv/bin/activate`                    |
| Install dependencies from requirements   | `pip install -r validation/requirements.txt`  |
| Update the requirements.txt file         | `pip freeze > validation/requirements.txt`    |

## Refresh python virtual environment

| **Step**                                 | **Command**                                  |
|------------------------------------------|----------------------------------------------|
| deactivate current environment           | `deactivate`                                 |
| follow the steps above                   | n/a                                          |  

## How to run script
- Create python virtual environment
  - `python3 -m venv venv`
- Activate virtual environment
  - `source venv/bin/activate`
- Install lxml in virtual environment
  - `pip install lxml`