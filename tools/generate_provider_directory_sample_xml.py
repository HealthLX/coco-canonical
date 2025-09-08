import xmlschema
import random
import rstr
from faker import Faker
from lxml import etree
from pathlib import Path
import re
from datetime import datetime, timedelta

base_dir = Path(__file__).resolve().parent.parent  # adjust as needed
schema_path = base_dir / "schemas/v2.0/ProviderDirectory.xsd"
schema = xmlschema.XMLSchema(str(schema_path))

fake = Faker()
XSD_NAMESPACE = "http://www.w3.org/2001/XMLSchema"

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

def generate_fake_value(tag_name, xsd_element=None):
      
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

        # Existing logic for other patterns
        match = re.findall(r'\{(\d+),?(\d+)?\}', pattern_str)
        if match:
            # Handle simple numeric patterns
            min_len = int(match[0][0])
            max_len = int(match[0][1]) if match[0][1] else min_len
            length = random.randint(min_len, max_len)
            return ''.join(str(random.randint(0, 9)) for _ in range(length))
        else:
            # Fallback
            return "sample"
        
    # 3. Handle decimals (e.g., latitude/longitude)
    if xsd_element.type.name and "decimal" in str(xsd_element.type.name).lower():
        if 'latitude' in tag_name.lower():
            return str(round(random.uniform(-90, 90), 6))
        elif 'longitude' in tag_name.lower():
            return str(round(random.uniform(-180, 180), 6))
        else:
            return str(round(random.uniform(0, 1000), 2))
                
    # 4. Semantic defaults based on tag name
    if 'email' in tag_name.lower():
        return fake.email()
    elif 'date_time_reported' in tag_name.lower():
        return fake.date_time().isoformat()    
    elif 'phone' in tag_name.lower():
        return fake.phone_number()
    elif 'name' in tag_name.lower():
        return fake.name()
    elif 'given' in tag_name.lower():
        return fake.name()
    elif 'family' in tag_name.lower():
        return fake.name()
    elif 'prefix' in tag_name.lower():
        return fake.prefix()
    elif 'suffix' in tag_name.lower():
        return fake.suffix()
    elif 'url' in tag_name.lower():
        return fake.url()
    elif 'rank' in tag_name.lower():
        return str(fake.random_int(min=1, max=5))
    elif 'id' in tag_name.lower():
        return fake.uuid4()
    elif 'date' in tag_name.lower():
        return fake.date()
    elif 'period' in tag_name.lower():
        return fake.date()
    elif 'start' in tag_name.lower():
        return fake.date()
    elif 'end' in tag_name.lower():
        return fake.date()
    elif 'npi' in tag_name.lower():
        return str(fake.random_number(digits=10, fix_len=True)) # NPI numbers are always 10 digits
    elif 'is_active' in tag_name.lower():
        return "true"
    elif 'city' in tag_name.lower():
        return fake.city()
    elif 'line' in tag_name.lower():
        return fake.street_address()
    elif 'postal_code' in tag_name.lower():
        return fake.zipcode()
    elif 'country' in tag_name.lower():
        return fake.country()
    elif 'state' in tag_name.lower():
        return fake.state_abbr()
    else:
        return fake.word()

def build_element(name, xsd_element=None):
    if xsd_element is None:
        xsd_element = schema.elements[name]

    xml_elem = etree.Element(name)

    if xsd_element.type.is_complex():
        if hasattr(xsd_element.type, 'content') and xsd_element.type.content:
            for child in xsd_element.type.content.iter_elements():
                max_count = child.max_occurs if child.max_occurs else 1
                # Always generate at least one, even if minOccurs=0
                count = max(1, child.min_occurs or 1)
                for _ in range(min(count, max_count)):
                    child_elem = build_element(child.name, child)
                    xml_elem.append(child_elem)
    else:
        xml_elem.text = generate_fake_value(name, xsd_element)
        # xml_elem.text = generate_fake_value(name)

    return xml_elem

# TODO: change this to be canonical-agnostic - root name needs to change, file created needs to change
# Generate from root
root_name = "providers" #schema.root_element.name
root_xml = build_element(root_name)

# Write to file - changing this impacts where the script is run from CLI

pdname = "provider-directory-sample.xml"
rname = "roster-sample.xml"

with open("samples/v2.0/" + pdname, "wb") as f:
    f.write(etree.tostring(root_xml, pretty_print=True, xml_declaration=True, encoding='UTF-8'))
print("Sample XML generated as ../samples/v2.0/" + pdname)

# with open("validation/samples/" + rname, "wb") as f:
#     f.write(etree.tostring(root_xml, pretty_print=True, xml_declaration=True, encoding='UTF-8'))
# print("Sample XML generated as ../samples/" + rname)
