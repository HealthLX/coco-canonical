import random
from faker import Faker
from lxml import etree
from pathlib import Path
import re
from datetime import datetime, timedelta, timezone
import xmlschema
from xmlschema.validators import XsdElement  # needed for type checking
import base64  # needed for base64Binary values

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
    start = datetime(2000, 1, 1, 0, 0, 0, tzinfo=timezone.utc)
    end = datetime(2030, 12, 31, 23, 59, 59, tzinfo=timezone.utc)
    delta = end - start
    random_seconds = random.randint(0, int(delta.total_seconds()))
    # ensure UTC Z
    return (start + timedelta(seconds=random_seconds)).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def iso_datetime_z():
    fake = Faker()
    # matches XSD instant pattern
    return fake.date_time(tzinfo=timezone.utc).replace(microsecond=0).strftime("%Y-%m-%dT%H:%M:%SZ")


def generate_value(tag_name, xsd_element=None):
    # handle static or pre-determined values (i.e., things that are not random, like schema version)
    if tag_name == f"{COCO_NS}schema_version":
        return "2.0"

    if tag_name == f"{COCO_NS}date_time_reported":
        # change: match XSD instant
        return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")

    fake = Faker()

    # normalize type name once
    type_name = str(xsd_element.type.name).lower(
    ) if xsd_element.type and xsd_element.type.name else ""

    # 1.Handle enum values
    if getattr(xsd_element.type, "is_simple", lambda: False)():  # can i remove this check?
        enum_values = getattr(xsd_element.type, "enumeration", None)
        if enum_values:
            # this works great for strings, for objects will need to use [e.value for e in enum_facet.enumeration]
            return random.choice(enum_values)

    # 2.Handle regex patterns
    pattern = get_pattern_from_type(xsd_element.type)
    if pattern:
        pattern_str = str(pattern)
        # Check if the pattern looks like a datetime (contains T and time components)
        if "T" in pattern_str and "-" in pattern_str and ":" in pattern_str:
            return random_datetime()

    # 3. Handle numeric and boolean types
    # 3.1 Handle decimal (e.g., latitude/longitude)
    if "decimal" in type_name:
        if "latitude" in tag_name.lower():
            return str(round(random.uniform(-90, 90), 6))
        elif "longitude" in tag_name.lower():
            return str(round(random.uniform(-180, 180), 6))
        else:
            return str(round(random.uniform(0, 1000), 2))
    # 3.2 Handle positiveInt / 3.4 Handle integer (same as positiveInt)
    if "positiveint" in type_name or "integer" in type_name:
        return str(fake.random_int(min=1, max=5))
    # 3.3 Handle unsignedInt
    if "unsignedint" in type_name:
        return str(fake.random_int(min=0, max=5))
    # 3.5 Handle boolean
    if "boolean" in type_name:
        return str(fake.boolean()).lower()
    if "base64binary" in type_name:  # change: fix base64Binary errors
        sample_bytes = fake.word().encode("utf-8")
        return base64.b64encode(sample_bytes).decode("ascii")

    # TODO: consider how to organize data being set for different schemas vs lumped together here.
    # 4. Semantic defaults via tag map
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
        
        # 'date' should be a date (YYYY-MM-DD), not a dateTime ---
        f"{COCO_NS}date": lambda: fake.date(),  # change: was iso_datetime_z()
        
        f"{COCO_NS}birth_date": lambda: fake.date(),
        f"{COCO_NS}period": lambda: fake.date(),
        f"{COCO_NS}start": lambda: iso_datetime_z() if xsd_element.type.name == f"{XML_NS}dateTime" else fake.date(),
        f"{COCO_NS}end": lambda: iso_datetime_z() if xsd_element.type.name == f"{XML_NS}dateTime" else fake.date(),
        f"{COCO_NS}npi": lambda: str(fake.random_number(digits=10, fix_len=True)),  # NPI numbers are always 10 digits
        f"{COCO_NS}is_active": lambda: "true",
        f"{COCO_NS}city": lambda: fake.city(),
        f"{COCO_NS}line": lambda: fake.street_address(),
        f"{COCO_NS}postal_code": lambda: fake.zipcode(),
        f"{COCO_NS}country": lambda: fake.country_code(),
        f"{COCO_NS}state": lambda: fake.state_abbr(),
        f"{COCO_NS}member_last_4_ssn": lambda: str(fake.random_int(min=1000, max=9999)),
        f"{COCO_NS}secret_length": lambda: str(fake.random_number(digits=6, fix_len=True)),
        f"{COCO_NS}available_start_time": lambda: str(fake.time()),
        f"{COCO_NS}available_end_time": lambda: str(fake.time()),
        f"{COCO_NS}opening_time": lambda: str(fake.time()),
        f"{COCO_NS}closing_time": lambda: str(fake.time()),
        
        # --- Add specific email tags ---
        f"{COCO_NS}email_plan_contact": lambda: fake.email(),
        f"{COCO_NS}email_address": lambda: fake.email(),

        # added for eob
        # ---  Add 'timing' as a date type ---
        f"{COCO_NS}timing": lambda: fake.date(),

        f"{COCO_NS}timing_date": lambda: str(fake.date()),
        f"{COCO_NS}serviced_date": lambda: str(fake.date()),
        f"{COCO_NS}value_time": lambda: str(fake.time()),
        f"{COCO_NS}due_date": lambda: str(fake.date()),
    }

    if tag_name in tag_map:
        return tag_map[tag_name]()

    return fake.word()


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
            print(
                f"Available global elements: {list(schema.elements.keys())}")
            raise KeyError(
                f"Global element '{root_element_name}' not found")
        xsd_element = schema.elements[root_element_name]

    xml_elem = etree.Element(root_element_name)

    # Add schema reference - but only set at root level
    if depth == 0:
        # Make canonical *in* the cocodata namespace and declare xsi prefix
        xml_elem = etree.Element(
            f"{COCO_NS}{root_element_name}",
            # set default ns + xsi prefix
            nsmap={None: COCO_NS_BARE, "xsi": XSI_NS_BARE},
        )
        # Set xsi:schemaLocation using Clark notation
        xml_elem.set(
            f"{XSI_NS}schemaLocation", f"{COCO_NS_BARE} ../../schemas/v2.0/{schema.name}")  # TODO: handle version dynamically

    # change: Handle content generation based on type

    # Case 1: Simple type (xs:string, xs:int) OR Complex type with simple content (<elem attr="val">text</elem>)
    # These types should receive a generated text value.
    if getattr(xsd_element.type, "is_simple", lambda: False)() or \
       (getattr(xsd_element.type, "is_complex", lambda: False)() and getattr(xsd_element.type, "has_simple_content", lambda: False)()):

        xml_elem.text = generate_value(root_element_name, xsd_element)

    # Case 2: Complex type with complex content (child elements)
    # These types should have child elements added recursively.
    elif getattr(xsd_element.type, "is_complex", lambda: False)() and \
         (getattr(xsd_element.type, "has_complex_content", lambda: False)() or getattr(xsd_element.type, "has_mixed_content", lambda: False)()) and \
         hasattr(xsd_element.type, 'content') and xsd_element.type.content:

        content_model = xsd_element.type.content

        # change: NEW RECURSIVE FUNCTION TO PROCESS GROUPS
        # This helper function correctly walks the XSD content model tree (sequences, choices, elements)
        def process_particle(particle, parent_xml_elem, depth_level, choice_override=None):
            """
            Recursively processes an XSD particle (Element, Choice, Sequence, All)
            """

            if isinstance(particle, XsdElement):
                # This is an <xs:element ...>

                # --- Normal element processing ---
                count = 0
                # We are building a "full" sample, so we want to *include*
                # optional elements (min_occurs="0") instead of skipping them.

                if particle.min_occurs == 0:
                    count = 1  # Always include at least one
                else:
                    # Handle required (1 or more)
                    count = particle.min_occurs or 1

                # of items if max_occurs is greater than 1.
                if particle.max_occurs and particle.max_occurs > 1:
                    # Pick a random number between 1 (our new minimum) and max_occurs
                    max_items = min(particle.max_occurs, 3)
                    count = random.randint(count, max_items)

                for _ in range(count):
                    child_elem = build_element(
                        particle.name, schema, xsd_element=particle, depth=depth_level, child_choice=choice_override
                    )
                    if child_elem is not None:
                        parent_xml_elem.append(child_elem)

            elif hasattr(particle, 'model'):
                # This is a group <xs:choice>, <xs:sequence>, <xs:all>
                group_model = particle.model

                if group_model == 'choice':
                    # --- Handle <xs:choice> ---

                    # Check for the special 'provider' case from the original code
                    # Special handling for provider element which contains xs:choice
                    is_provider_choice = root_element_name == f"{COCO_NS}provider" and choice_override is not None

                    if is_provider_choice:
                        # If this is the provider element with a choice specified
                        # Find the *specific* child element from the choice_override
                        for choice_child in particle:
                            if isinstance(choice_child, XsdElement):
                                child_local_name = choice_child.name.split(
                                    '}')[-1] if '}' in choice_child.name else choice_child.name
                                if child_local_name == choice_override:
                                    # Process only this chosen particle
                                    process_particle(
                                        choice_child, parent_xml_elem, depth_level, choice_override)
                                    break  # Found and processed
                    else:
                        # --- Normal <xs:choice> ---
                        possible_choices = list(
                            particle)  # Get all particles in the choice
                        if not possible_choices:
                            return  # Empty choice

                        # Filter out the <reference> element to *prefer* the full data block
                        non_reference_choices = [
                            p for p in possible_choices
                            if not (isinstance(p, XsdElement) and p.name == f"{COCO_NS}reference")
                        ]

                        if non_reference_choices:
                            # We found at least one non-reference choice (e.g., the full <sequence>)
                            # Randomly pick from this *filtered* list
                            chosen_particle = random.choice(
                                non_reference_choices)
                        else:
                            # If, for some reason, *only* reference options exist, just pick one
                            chosen_particle = random.choice(possible_choices)

                        # Process the *one* chosen particle
                        process_particle(
                            chosen_particle, parent_xml_elem, depth_level, choice_override)

                elif group_model in ('sequence', 'all'):
                    # --- Handle <xs:sequence> or <xs:all> ---
                    # Process *all* sub-particles in order
                    for sub_particle in particle:
                        process_particle(
                            sub_particle, parent_xml_elem, depth_level, choice_override)

        # Start processing the *main* content model (e.g., the <xs:sequence> of 'patient')
        # We pass the 'child_choice' from the function args as the 'choice_override'
        process_particle(content_model, xml_elem, depth + 1, child_choice)

    # Case 3: Complex type with empty content (<elem attr="val"/>)
    # This element has no children and no text, so we do nothing.

    return xml_elem