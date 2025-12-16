from saxonche import PySaxonProcessor
import os
from pathlib import Path
from xml.dom import minidom

def apply_xslt(base_dir, xml_file, xslt_file, output_file=None):
    """
    Apply an XSLT transformation to an XML file using Saxon.
    
    Args:
        xml_file: Path to the input XML file
        xslt_file: Path to the XSLT stylesheet file
        output_file: Optional path to save the output (if None, returns as string)
    
    Returns:
        Transformed XML as a string if output_file is None
    """
    # Create Saxon processor
    with PySaxonProcessor(license=False) as proc:
        # Create XSLT 3.0 processor
        xslt_proc = proc.new_xslt30_processor()
        
        # Compile the stylesheet
        executable = xslt_proc.compile_stylesheet(stylesheet_file=xslt_file)
        
        # Apply the transformation
        result = executable.transform_to_string(source_file=xml_file)

        # Pretty-print the XML
        dom = minidom.parseString(result)
        pretty_xml = dom.toprettyxml(indent="  ", encoding="utf-8").decode("utf-8")
        # Remove extra blank lines that minidom adds
        pretty_xml = "\n".join([line for line in pretty_xml.split("\n") if line.strip()])

        # Handle output
        if output_file:
            # Write to file
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(pretty_xml)
            print(f"Transformation complete. Output saved to {output_file}")
        else:
            # Return as string
            return pretty_xml


def apply_xslt_with_params(xml_file, xslt_file, params=None, output_file=None):
    """
    Apply an XSLT transformation with parameters.
    
    Args:
        xml_file: Path to the input XML file
        xslt_file: Path to the XSLT stylesheet file
        params: Dictionary of parameters to pass to the stylesheet
        output_file: Optional path to save the output (if None, returns as string)
    
    Returns:
        Transformed XML as a string if output_file is None
    """
    with PySaxonProcessor(license=False) as proc:
        xslt_proc = proc.new_xslt30_processor()
        
        # Set parameters if provided
        if params:
            for key, value in params.items():
                xslt_proc.set_parameter(key, proc.make_string_value(value))
        
        executable = xslt_proc.compile_stylesheet(stylesheet_file=xslt_file)
        result = executable.transform_to_string(source_file=xml_file)
        
        if output_file:
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(result)
            print(f"Transformation complete. Output saved to {output_file}")
        else:
            return result

if __name__ == "__main__":
    # Setup paths
    base_dir = os.path.dirname(os.path.dirname(__file__)) # go up one from /tools
    xml_file = os.path.join(base_dir, "canonical-samples/v10.0/roster-sample.xml")

    # Define all three transformations
    # TODO: move these to config files
    transformations = [
        {
            "name": "patient",
            "xslt": os.path.join(base_dir, "transforms/v10.0/roster-patient.xsl"),
            "output": os.path.join(base_dir, "fhir-samples/v10.0/roster-patient-fhir.xml")
        }
    ]

    print(f"Transforming roster canonical to FHIR resources...")
    print(f"Source XML: {xml_file}\n")

    # Apply each transformation
    for transform in transformations:
        print(f"Applying {transform['name']} transformation...")
        apply_xslt(base_dir, xml_file, transform['xslt'], transform['output'])
        print()

    print("All transformations complete!")