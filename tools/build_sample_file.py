import xmlschema
import random
from faker import Faker
from lxml import etree
from pathlib import Path
import re
from datetime import datetime, timedelta
from lxml import etree
import xmlschema
from xmlschema.validators import XsdElement
from pathlib import Path
from datetime import timezone

COCO_NS_BARE = "http://cocodata.org"
XSI_NS_BARE = "http://www.w3.org/2001/XMLSchema-instance"

COCO_NS = "{http://cocodata.org}"
XML_NS = "{http://www.w3.org/2001/XMLSchema}"
XSI_NS = "{http://www.w3.org/2001/XMLSchema-instance}"

ROSTER_SCHEMA = "roster.xsd"
PROVIDERDIRECTORY_SCHEMA = "provider_directory.xsd"
EOB_SCHEMA = "eob.xsd"
FORMULARY_SCHEMA = "formulary.xsd"
CLINICAL_SCHEMA = "clinical.xsd"


def get_pattern_from_type(xsd_type):
    for facet_name, facet in xsd_type.facets.items():
        if 'pattern' in facet_name:
            return facet.patterns[0]
    return None

def random_datetime():
    start = datetime(2000, 1, 1, 0, 0, 0)
    end = datetime(2030, 12, 31, 23, 59, 59)
    delta = end - start
    random_seconds = random.randint(0, int(delta.total_seconds()))
    return (start + timedelta(seconds=random_seconds)).isoformat()

def generate_value(tag_name, xsd_element=None):
    # handle static or pre-determined values (i.e., things that are not random, like schema version)
    if tag_name == F"{COCO_NS}schema_version":
        return str("2.0")

    if tag_name == F"{COCO_NS}date_time_reported":
        return datetime.now().astimezone().isoformat(timespec="milliseconds")

    fake = Faker()
    # 1.Handle enum values
    if xsd_element.type.is_simple(): # can i remove this check?
        enum_values = getattr(xsd_element.type, "enumeration", None)
        if enum_values:
            return random.choice(enum_values) # this works great for strings, for objects will need to use [e.value for e in enum_facet.enumeration]

     # 2.Handle regex patterns
    pattern = get_pattern_from_type(xsd_element.type)
    if pattern:
        pattern_str = str(pattern)
         # Check if the pattern looks like a datetime (contains T and time components)
        if "T" in pattern_str and "-" in pattern_str and ":" in pattern_str:
            return random_datetime()

        # # this parses pattern facets in the XSD and generates values - not sure how much this is used
        # i dont believe this is being used, should be able to delete
        # match = re.findall(r'\{(\d+),?(\d+)?\}', pattern_str)
        # if match:
        #     # Handle simple numeric patterns
        #     min_len = int(match[0][0])
        #     max_len = int(match[0][1]) if match[0][1] else min_len
        #     length = random.randint(min_len, max_len)
        #     return ''.join(str(random.randint(0, 9)) for _ in range(length))
        # else:
        #     # Fallback
        #     return "sample"
        
    # 3. Handle decimals (e.g., latitude/longitude)
    if xsd_element.type.name and f"{COCO_NS}decimal" in str(xsd_element.type.name).lower():
        if "latitude" in tag_name.lower():
            return str(round(random.uniform(-90, 90), 6))
        elif "longitude" in tag_name.lower():
            return str(round(random.uniform(-180, 180), 6))
        else:
            return str(round(random.uniform(0, 1000), 2))

    # TODO: consider how to organize data being set for different schemas vs lumped together here.
    
    # 4. Semantic defaults based on tag name
    if f"{COCO_NS}email" in tag_name.lower():
        return fake.email()
    elif f"{COCO_NS}date_time_reported" in tag_name.lower():
        return fake.date_time().isoformat()    
    elif f"{COCO_NS}phone" in tag_name.lower():
        return fake.phone_number()
    elif f"{COCO_NS}name" in tag_name.lower():
        return fake.name()
    elif f"{COCO_NS}given" in tag_name.lower():
        return fake.name()
    elif f"{COCO_NS}family" in tag_name.lower():
        return fake.name()
    elif f"{COCO_NS}prefix" in tag_name.lower():
        return fake.prefix()
    elif f"{COCO_NS}suffix" in tag_name.lower():
        return fake.suffix()
    elif f"{COCO_NS}url" in tag_name.lower():
        return fake.url()
    elif f"{COCO_NS}rank" in tag_name.lower():
        return str(fake.random_int(min=1, max=5))
    elif f"{COCO_NS}id" in tag_name.lower():
        return fake.uuid4()
    elif f"{COCO_NS}date" in tag_name.lower():
        return fake.date()
    elif f"{COCO_NS}birth_date" in tag_name.lower():
        return fake.date()
    elif f"{COCO_NS}period" in tag_name.lower():
        return fake.date()
    elif f"{COCO_NS}start" in tag_name.lower():
        if xsd_element.type.name == f"{XML_NS}dateTime":
            return iso_datetime_z()
        elif f"{XML_NS}date":
            return fake.date()
    elif f"{COCO_NS}end" in tag_name.lower():
        if xsd_element.type.name == f"{XML_NS}dateTime":
            return iso_datetime_z()
        elif f"{XML_NS}date":
            return fake.date()
    elif f"{COCO_NS}npi" in tag_name.lower():
        return str(fake.random_number(digits=10, fix_len=True)) # NPI numbers are always 10 digits
    elif f"{COCO_NS}is_active" in tag_name.lower():
        return "true"
    elif f"{COCO_NS}city" in tag_name.lower():
        return fake.city()
    elif f"{COCO_NS}line" in tag_name.lower():
        return fake.street_address()
    elif f"{COCO_NS}postal_code" in tag_name.lower():
        return fake.zipcode()
    elif f"{COCO_NS}country" in tag_name.lower():
        return fake.country_code()
    elif f"{COCO_NS}state" in tag_name.lower():
        return fake.state_abbr()
    elif f"{COCO_NS}is_subscriber" in tag_name.lower():
        return str(fake.boolean()).lower()
    elif f"{COCO_NS}is_enrolled" in tag_name.lower():
        return str(fake.boolean()).lower()
    elif f"{COCO_NS}active" in tag_name.lower():
        return str(fake.boolean()).lower()
    elif f"{COCO_NS}member_last_4_ssn" in tag_name.lower():
        return str(fake.random_int(min=1000, max=9999))
    elif f"{COCO_NS}secret_length" in tag_name.lower():
        return str(fake.random_number(digits=6, fix_len=True))
    elif f"{COCO_NS}is_preferred" in tag_name.lower():
        return str(fake.boolean()).lower()
    # all items below added for provider-directory
    elif f"{COCO_NS}all_day" in tag_name.lower():
        return str(fake.boolean()).lower()
    elif f"{COCO_NS}available_start_time" in tag_name.lower():
        return str(fake.time())
    elif f"{COCO_NS}available_end_time" in tag_name.lower():
        return str(fake.time())
    elif f"{COCO_NS}opening_time" in tag_name.lower(): 
        return str(fake.time())
    elif f"{COCO_NS}closing_time" in tag_name.lower(): 
        return str(fake.time())
    elif f"{COCO_NS}appointment_required" in tag_name.lower():
        return str(fake.boolean()).lower()
    else:
        return fake.word()

def iso_datetime_z():
    fake = Faker()
    return fake.date_time(tzinfo=timezone.utc).replace(microsecond=0).strftime("%Y-%m-%dT%H:%M:%SZ")

def build_element(root_element_name, schema, xsd_element=None, depth=0, canonical_name="None", child_choice="None"):
    """
    recursively builds xml elements and returns as an xml document

    Args:
        name (str): name of the element to build - used recursively so could be root or nested element name
        schema (XmlSchema): schema object to use
        xsd_element (XsdElement): element object - used recursively to drill down into all schema elements

    Returns:
        XmlElement: containing the full XML document to be serialized and written to file system
    """

    print(f"build_element called with name='{root_element_name}', xsd_element={'None' if xsd_element is None else 'provided'}")    
    if xsd_element is None:
            if root_element_name not in schema.elements:
                print(f"ERROR: '{root_element_name}' not found in global elements")
                print(f"Available global elements: {list(schema.elements.keys())}")
                raise KeyError(f"Global element '{root_element_name}' not found")
            xsd_element = schema.elements[root_element_name]
    xml_elem = etree.Element(root_element_name)

    # Add schema reference - but only set at root
    if depth == 0:
        # Make canonical *in* the cocodata namespace and declare xsi prefix 
        xml_elem = etree.Element(
            f"{COCO_NS}{root_element_name}",
            nsmap={None: COCO_NS_BARE, "xsi": XSI_NS_BARE},  # default ns + xsi prefix
        )
        # Set xsi:schemaLocation using Clark notation
        xml_elem.set(
            f"{XSI_NS}schemaLocation",
            f"{COCO_NS_BARE} ../../schemas/v2.0/{schema.name}"
        ) 
    
    # TODO: Provider Directory can only include a practitioner OR a providingOrganization. 
    # This needs to be handled, and controlled from the input method.

    if xsd_element.type.is_complex():
        if hasattr(xsd_element.type, 'content') and xsd_element.type.content: 
            for child in xsd_element.type.content.iter_elements():
                # Skip xs:any elements or elements without proper names
                if not hasattr(child, 'name') or child.name is None:
                    continue
                max_count = child.max_occurs if child.max_occurs else 1
                # Always generate at least one, even if minOccurs=0
                count = max(1, child.min_occurs or 1)
                for _ in range(min(count, max_count)):
                    child_elem = build_element(child.name, schema, child, depth=depth+1)
                    xml_elem.append(child_elem)
    else:
        xml_elem.text = generate_value(root_element_name, xsd_element)
        if root_element_name == f"{COCO_NS}names":
            xml_elem.text = generate_value(root_element_name, xsd_element)
            
    return xml_elem