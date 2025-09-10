# main.py
import xmlschema
from pathlib import Path
from lxml import etree
from tools.roster import build_element

def BuildSampleFile(root_name, schema_file_name, output_file_name):
    #Get path and load schema
    base_dir = Path(__file__).resolve().parent.parent
    schema_path = base_dir / "schemas" / "v2.0" / f"{schema_file_name}"
    schema = xmlschema.XMLSchema(str(schema_path))
    # call builder function and pass in schema, along with root name to get the process started (recursion takes over once in function)
    built_xml = build_element(root_name, schema)
    # Write to file - changing this impacts where the script is run from CLI
    name = output_file_name
    with open("samples/v2.0/" + name, "wb") as f:
        f.write(etree.tostring(built_xml, pretty_print=True, xml_declaration=True, encoding='UTF-8'))
    print("Sample XML generated as ../samples/v2.0/" + name)

def main():

   BuildSampleFile("providers", "provider-directory.xsd", "provider-directory-sample.xml")
   BuildSampleFile("roster", "roster.xsd", "roster-sample.xml")
   BuildSampleFile("eob_list", "eob.xsd", "eob-sample.xml")
   BuildSampleFile("clinicals", "clinical.xsd", "clinical-sample.xml")
 

if __name__ == "__main__":
    main()