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
        # You can add pattern-based generation here if needed

    # 3.1 Handle decimal (e.g., latitude/longitude)
    if xsd_element.type.name and f"{COCO_NS}decimal".lower() in str(xsd_element.type.name).lower():
        if "latitude" in tag_name.lower():
            return str(round(random.uniform(-90, 90), 6))
        elif "longitude" in tag_name.lower():
            return str(round(random.uniform(-180, 180), 6))
        else:
            return str(round(random.uniform(0, 1000), 2))

    # 3.2 Handle positiveInt
    if xsd_element.type.name and f"{COCO_NS}positiveint".lower() in str(xsd_element.type.name).lower():
        return str(fake.random_int(min=1, max=5) )

    # 3.3 Handle unsignedInt
    if xsd_element.type.name and f"{COCO_NS}unsignedint".lower() in str(xsd_element.type.name).lower():
        return str(fake.random_int(min=0, max=5) )

    # 3.4 Handle integer (same as positiveInt)
    if xsd_element.type.name and f"{COCO_NS}integer".lower() in str(xsd_element.type.name).lower():
        return str(fake.random_int(min=1, max=5) )

    # 3.5 Handle boolean
    if xsd_element.type.name and f"{XML_NS}boolean".lower() in str(xsd_element.type.name).lower():
        return str(fake.boolean()).lower()

    # TODO: consider how to organize data being set for different schemas vs lumped together here.

    # 4. Semantic defaults via tag map instead of long if/else
    tag_map = {
        f"{COCO_NS}email": lambda: fake.email(),
        f"{COCO_NS}phone": lambda: fake.phone_number(),
        f"{COCO_NS}name": lambda: fake.name(),
        f"{COCO_NS}given": lambda: fake.first_name(),
        f"{COCO_NS}family": lambda: fake.last_name(),
        f"{COCO_NS}prefix": lambda: fake.prefix(),
        f"{COCO_NS}suffix": lambda: fake.suffix(),
        f"{COCO_NS}url": lambda: fake.url(),
        f"{COCO_NS}rank": lambda: str(fake.random_int(min=1, max=5)),
        f"{COCO_NS}id": lambda: fake.uuid4(),
        f"{COCO_NS}date": lambda: fake.date(),
        f"{COCO_NS}birth_date": lambda: fake.date(),
        f"{COCO_NS}period": lambda: fake.date(),
        f"{COCO_NS}start": lambda: iso_datetime_z() if xsd_element.type.name == f"{XML_NS}dateTime" else fake.date(),
        f"{COCO_NS}end": lambda: iso_datetime_z() if xsd_element.type.name == f"{XML_NS}dateTime" else fake.date(),
        f"{COCO_NS}npi": lambda: str(fake.random_number(digits=10, fix_len=True)),
        f"{COCO_NS}is_active": lambda: "true",
        f"{COCO_NS}city": lambda: fake.city(),
        f"{COCO_NS}line": lambda: fake.street_address(),
        f"{COCO_NS}postal_code": lambda: fake.zipcode(),
        f"{COCO_NS}country": lambda: fake.country_code(),  # must match maxLength constraints
        f"{COCO_NS}state": lambda: fake.state_abbr(),
        f"{COCO_NS}member_last_4_ssn": lambda: str(fake.random_int(min=1000, max=9999)),
        f"{COCO_NS}secret_length": lambda: str(fake.random_number(digits=6, fix_len=True)),
        f"{COCO_NS}available_start_time": lambda: str(fake.time()),
        f"{COCO_NS}available_end_time": lambda: str(fake.time()),
        f"{COCO_NS}opening_time": lambda: str(fake.time()),
        f"{COCO_NS}closing_time": lambda: str(fake.time()),
        # added for eob
        f"{COCO_NS}timing_date": lambda: str(fake.date()),
        f"{COCO_NS}serviced_date": lambda: str(fake.date()),
        f"{COCO_NS}value_time": lambda: str(fake.time()),
        f"{COCO_NS}due_date": lambda: str(fake.date()),
    }

    if tag_name in tag_map:
        return tag_map[tag_name]()

    # fallback for any other tags
    return fake.word()

def iso_datetime_z():
    fake = Faker()
    return fake.date_time(tzinfo=timezone.utc).replace(microsecond=0).strftime("%Y-%m-%dT%H:%M:%SZ")

def build_element(root_element_name, schema, xsd_element=None, depth=0, canonical_name="None", child_choice="None"):
    """
    recursively builds xml elements and returns as an xml document; 
    handles building for practitioner or providingOrganization for provider-directory

    Args:
        root_element_name (str): name of the element to build
        schema (XmlSchema): schema object to use
        xsd_element (XsdElement): element object - used recursively
        depth (int): recursion depth
        canonical_name (str): name of canonical (e.g., 'roster', 'providers')
        child_choice (str): for xs:choice elements, specify which child to build (e.g., 'practitioner')

    Returns:
        XmlElement: containing the full XML document
    """
    print(f"build_element called with name='{root_element_name}', xsd_element={'None' if xsd_element is None else 'provided'}")    

    if xsd_element is None:
            if root_element_name not in schema.elements:
                print(f"ERROR: '{root_element_name}' not found in global elements")
                print(f"Available global elements: {list(schema.elements.keys())}")
                raise KeyError(f"Global element '{root_element_name}' not found")
            xsd_element = schema.elements[root_element_name]

    # skip all 'reference' elements - only building out inline for these samples
    if xsd_element.name == f"{COCO_NS}reference":
        return
    
    xml_elem = etree.Element(root_element_name)

    # Add schema reference - but only set at root level
    if depth == 0:
        # Make canonical *in* the cocodata namespace and declare xsi prefix 
        xml_elem = etree.Element(
            f"{COCO_NS}{root_element_name}",
            nsmap={None: COCO_NS_BARE, "xsi": XSI_NS_BARE},  # set default ns + xsi prefix
        )
        # Set xsi:schemaLocation using Clark notation
        xml_elem.set(
            f"{XSI_NS}schemaLocation",
            f"{COCO_NS_BARE} ../../schemas/v2.0/{schema.name}" #TODO: handle version dynamically
        ) 

    if xsd_element.type.is_complex():
        if hasattr(xsd_element.type, 'content') and xsd_element.type.content:
            # Special handling for provider element which contains xs:choice
            is_provider_choice = root_element_name == f"{COCO_NS}provider" and child_choice is not None
            
            for child in xsd_element.type.content.iter_elements():
                if not hasattr(child, 'name') or child.name is None:
                    continue
                
                # If this is the provider element with a choice specified
                if is_provider_choice:
                    child_local_name = child.name.split('}')[-1] if '}' in child.name else child.name
                    if child_local_name != child_choice:
                        continue  # Skip this child
                
                max_count = child.max_occurs if child.max_occurs else 1
                count = max(1, child.min_occurs or 1)
                
                for _ in range(min(count, max_count)):
                    child_elem = build_element(
                        child.name, 
                        schema, 
                        child, 
                        depth=depth+1,
                        canonical_name=canonical_name,
                        child_choice=child_choice
                    )
                    # skip all 'reference' elements - only building out inline for these samples
                    if child.name != f"{COCO_NS}reference":
                        xml_elem.append(child_elem)
    else:
        xml_elem.text = generate_value(root_element_name, xsd_element)
            
    return xml_elem