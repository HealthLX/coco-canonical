# main.py
import xmlschema
from pathlib import Path
from lxml import etree
from tools.build_sample_file import build_element

def build_sample_file(canonical_name, root_element_name, schema_file_name, output_file_name, provider_directory_child=None):
    #Get path and load schema
    base_dir = Path(__file__).resolve().parent.parent
    schema_path = base_dir / "schemas" / "v2.0" / f"{schema_file_name}"
    schema = xmlschema.XMLSchema(str(schema_path))

    # call builder function and pass in schema, along with root name to get the process started (recursion takes over once in function)
    # built_xml = build_element(canonical_name, root_element_name, schema)

    # if provider_directory_child is not "None":
    #     built_xml = build_element(root_element_name, schema, canonical_name=canonical_name, child_choice=provider_directory_child)
    # else:
    #     built_xml = build_element(root_element_name, schema, canonical_name=canonical_name)


    # Build with optional child_choice parameter
    built_xml = build_element(
        root_element_name, 
        schema, 
        canonical_name=canonical_name,
        child_choice=provider_directory_child
    )


    # Write to file - changing this impacts where the script is run from CLI
    name = output_file_name
    with open("canonical-samples/v2.0/" + name, "wb") as f:
        f.write(etree.tostring(built_xml, pretty_print=True, xml_declaration=True, encoding='UTF-8'))
    print("Sample XML generated as ../samples/v2.0/" + name)

def main():
    build_sample_file(
       "providerdirectory", 
       "providers", 
       "provider-directory.xsd", 
       "provider-directory-practitioner-sample.xml", 
       provider_directory_child="practitioner")
   
    build_sample_file(
       "providerdirectory", 
       "providers", 
       "provider-directory.xsd", 
       "provider-directory-organization-sample.xml", 
       provider_directory_child="providing_organization")

    build_sample_file(
        "roster", 
        "roster", 
        "roster.xsd", 
        "roster-sample.xml")

    build_sample_file(
        "forumarly", 
        "coverage_plans", 
        "formulary.xsd", 
        "formulary-sample.xml")

    # TODO: figure out how to handle providing_organization and practitioner XOR for EOB
    # should be able to use same logic as for provider-directory... but not working as is 
    build_sample_file(
       "eob",
       "eob_list",
       "eob.xsd",
       "eob-sample.xml")

    build_sample_file(
        "clinical", 
        "clinicals",
        "clinical.xsd", 
        "clinical-sample.xml")

if __name__ == "__main__":
    main()