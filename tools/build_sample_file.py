import random
from faker import Faker
from lxml import etree
from pathlib import Path
import re
from datetime import datetime, timedelta, timezone
import xmlschema
from xmlschema.validators import XsdElement  # needed for type checking
import base64  # needed for base64Binary values
from . import fhir_mappings  # FHIR code-display mappings for validation compliance

COCO_NS_BARE = "http://cocodata.org"
XSI_NS_BARE = "http://www.w3.org/2001/XMLSchema-instance"

COCO_NS = "{http://cocodata.org}"
XML_NS = "{http://www.w3.org/2001/XMLSchema}"
XSI_NS = "{http://www.w3.org/2001/XMLSchema-instance}"

# Current schema version. A build entry in config/sample_builds.yaml that omits "version"
# resolves to DEFAULT_VERSION_DIR, so bumping these two constants (plus adding the new
# schemas/<version>/ folder) is what promotes a new version to the default.
DEFAULT_SCHEMA_VERSION = "11.0"
DEFAULT_VERSION_DIR = "v11.0"

ROSTER_SCHEMA = "roster.xsd"
PROVIDERDIRECTORY_SCHEMA = "provider_directory.xsd"
EOB_SCHEMA = "eob.xsd"
FORMULARY_SCHEMA = "formulary.xsd"
CLINICAL_SCHEMA = "clinical.xsd"

# Import FHIR code-display mappings from centralized module
RACE_DISPLAY_MAP = fhir_mappings.RACE_DISPLAY_MAP
ETHNICITY_DISPLAY_MAP = fhir_mappings.ETHNICITY_DISPLAY_MAP
LANGUAGE_DISPLAY_MAP = fhir_mappings.LANGUAGE_DISPLAY_MAP



def get_pattern_from_type(xsd_type):
    for facet_name, facet in xsd_type.facets.items():
        if 'pattern' in facet_name:
            return facet.patterns[0]
    return None


def random_datetime(days_offset=0):
    # Base range: 2010 to 2020
    start = datetime(2010, 1, 1, 0, 0, 0, tzinfo=timezone.utc)
    end = datetime(2020, 12, 31, 23, 59, 59, tzinfo=timezone.utc)
    delta = end - start
    random_seconds = random.randint(0, int(delta.total_seconds()))
    # Apply offset: negative for older (start), positive for newer (end)
    dt = (start + timedelta(seconds=random_seconds) + timedelta(days=days_offset))
    return dt.replace(microsecond=0).isoformat().replace("+00:00", "Z")

def iso_datetime_z(days_offset=0):
    """
    Generates a UTC timestamp. 
    Use negative days_offset for the past, positive for the future.
    """
    fake = Faker()
    # Generate a date, then apply the offset
    base_dt = fake.date_time_between(start_date="-10y", end_date="now", tzinfo=timezone.utc)
    final_dt = base_dt + timedelta(days=days_offset)
    return final_dt.replace(microsecond=0).strftime("%Y-%m-%dT%H:%M:%SZ")


def _generate_period_start(tag_name, xsd_element):
    """
    Generate a start date for a period element.
    Uses a date range (5-10 years ago) that's guaranteed to be before end dates.
    """
    fake = Faker()
    is_datetime = xsd_element.type.name == f"{XML_NS}dateTime"
    
    if is_datetime:
        # Generate a dateTime in the past (5-10 years ago)
        # This range is guaranteed to be before end dates (which are 0-4 years ago)
        start_dt = fake.date_time_between(start_date="-10y", end_date="-5y", tzinfo=timezone.utc)
        return start_dt.replace(microsecond=0).strftime("%Y-%m-%dT%H:%M:%SZ")
    else:
        # Generate a date in the past (5-10 years ago)
        # This range is guaranteed to be before end dates (which are 0-4 years ago)
        start_date = fake.date_between(start_date="-10y", end_date="-5y")
        return str(start_date)


def _generate_period_end(tag_name, xsd_element):
    """
    Generate an end date for a period element.
    Uses a date range (0-4 years ago to today) that's guaranteed to be after start dates.
    Start dates are 5-10 years ago, so end dates from 0-4 years ago are guaranteed to be after.
    """
    fake = Faker()
    is_datetime = xsd_element.type.name == f"{XML_NS}dateTime"
    
    if is_datetime:
        # Generate end date from 0-4 years ago to now
        # This is guaranteed to be after start dates (which are 5-10 years ago)
        end_dt = fake.date_time_between(start_date="-4y", end_date="now", tzinfo=timezone.utc)
        return end_dt.replace(microsecond=0).strftime("%Y-%m-%dT%H:%M:%SZ")
    else:
        # Generate end date from 0-4 years ago to today
        # This is guaranteed to be after start dates (which are 5-10 years ago)
        end_date = fake.date_between(start_date="-4y", end_date="today")
        return str(end_date)


def _builtin_temporal_type(xsd_element):
    """
    Return 'date', 'dateTime' or 'time' when the element resolves to that XSD built-in,
    otherwise None. Uses the root type so local restrictions (e.g. <simpleType name="date">
    restricting xs:date) are recognized too.
    """
    try:
        root_name = xsd_element.type.root_type.name or ""
    except AttributeError:
        return None
    if not root_name.startswith(XML_NS):
        return None
    primitive = root_name[len(XML_NS):]
    return primitive if primitive in ("date", "dateTime", "time") else None


def generate_value(tag_name, xsd_element=None, parent_xml_elem=None, context_dict=None):
    # handle static or pre-determined values (i.e., things that are not random, like schema version)
    if tag_name == f"{COCO_NS}schema_version":
        # Seeded from the schema's own version attribute at depth 0 (see build_element),
        # so a sample always reports the version of the schema it was built from.
        return (context_dict or {}).get("schema_version", DEFAULT_SCHEMA_VERSION)

    if tag_name == f"{COCO_NS}date_time_reported":
        # change: match XSD instant
        return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")

    fake = Faker()

    # normalize type name once
    type_name = str(xsd_element.type.name).lower(
    ) if xsd_element.type and xsd_element.type.name else ""

    # FIX: Handle Race/Ethnicity codes FIRST - before enum extraction
    # Valid OMB Race Category codes (from FHIR US Core) - separate NullFlavor from actual codes
    # Use helper functions from fhir_mappings module
    valid_race_codes = fhir_mappings.get_race_codes_without_nullflavor()
    # NullFlavor codes (from http://terminology.hl7.org/CodeSystem/v3-NullFlavor)
    null_flavor_codes = ["UNK", "ASKU"]
    # Valid OMB Ethnicity Category codes (from FHIR US Core) - separate NullFlavor from actual codes
    valid_ethnicity_codes = fhir_mappings.get_ethnicity_codes_without_nullflavor()
    # Note: NullFlavor codes are shared between race and ethnicity
    
    # Check for race/ethnicity context BEFORE enum extraction to prevent ASKU/UNK for ethnicity
    if tag_name == f"{COCO_NS}code":
        # Check parent element context (more reliable than element name)
        parent_context = ""
        if parent_xml_elem is not None:
            # Get parent tag name (strip namespace)
            parent_tag = parent_xml_elem.tag.split('}')[-1] if '}' in parent_xml_elem.tag else parent_xml_elem.tag
            parent_context = parent_tag.lower()
        
        # Also check element name as fallback
        elem_name_str = str(xsd_element.name) if hasattr(xsd_element, 'name') and xsd_element.name else ""
        context_str = f"{parent_context} {elem_name_str}".lower()
        
        # Determine if race or ethnicity based on context
        if "race" in context_str or "us_core_race" in context_str:
            # Prefer actual race codes (90% chance), otherwise use NullFlavor (10% chance)
            race_code = random.choice(valid_race_codes) if random.random() < 0.9 else random.choice(null_flavor_codes)
            # Store the FIRST code in context for display/text generation (XSLT uses first code)
            if context_dict is not None:
                if 'race_code' not in context_dict:  # Only store the first code
                    context_dict['race_code'] = race_code
            return race_code
        elif "ethnicity" in context_str or "us_core_ethnicity" in context_str:
            # Ethnicity codes must NEVER be UNK/ASKU - only valid codes (2135-2, 2186-5)
            eth_code = random.choice(valid_ethnicity_codes)
            # Store the code in context for display/text generation
            if context_dict is not None:
                context_dict['ethnicity_code'] = eth_code
            return eth_code

    # 1.Handle enum values (AFTER race/ethnicity check to prevent ASKU for ethnicity)
    if getattr(xsd_element.type, "is_simple", lambda: False)():  # can i remove this check?
        enum_values = getattr(xsd_element.type, "enumeration", None)
        if enum_values:
            # For ethnicity codes, filter out UNK/ASKU - check parent context
            if tag_name == f"{COCO_NS}code":
                parent_context = ""
                if parent_xml_elem is not None:
                    parent_tag = parent_xml_elem.tag.split('}')[-1] if '}' in parent_xml_elem.tag else parent_xml_elem.tag
                    parent_context = parent_tag.lower()
                elem_name_str = str(xsd_element.name) if hasattr(xsd_element, 'name') and xsd_element.name else ""
                context_str = f"{parent_context} {elem_name_str}".lower()
                if "ethnicity" in context_str or "us_core_ethnicity" in context_str:
                    # Filter enum values to only valid ethnicity codes
                    filtered_enum = [v for v in enum_values if v in valid_ethnicity_codes]
                    if filtered_enum:
                        eth_code = random.choice(filtered_enum)
                        if context_dict is not None:
                            context_dict['ethnicity_code'] = eth_code
                        return eth_code
            # this works great for strings, for objects will need to use [e.value for e in enum_facet.enumeration]
            return random.choice(enum_values)
    
    # Try to extract enum values from facets (more reliable method)
    if hasattr(xsd_element.type, 'facets'):
        for facet_name, facet in xsd_element.type.facets.items():
            if 'enumeration' in facet_name.lower():
                try:
                    if hasattr(facet, 'enumeration'):
                        enum_list = []
                        for e in facet.enumeration:
                            if hasattr(e, 'value'):
                                enum_list.append(e.value)
                            elif hasattr(e, 'text'):
                                enum_list.append(e.text)
                            else:
                                enum_list.append(str(e))
                        if enum_list:
                            # For ethnicity codes, filter out UNK/ASKU - check parent context
                            if tag_name == f"{COCO_NS}code":
                                parent_context = ""
                                if parent_xml_elem is not None:
                                    parent_tag = parent_xml_elem.tag.split('}')[-1] if '}' in parent_xml_elem.tag else parent_xml_elem.tag
                                    parent_context = parent_tag.lower()
                                elem_name_str = str(xsd_element.name) if hasattr(xsd_element, 'name') and xsd_element.name else ""
                                context_str = f"{parent_context} {elem_name_str}".lower()
                                if "ethnicity" in context_str or "us_core_ethnicity" in context_str:
                                    # Filter enum values to only valid ethnicity codes
                                    filtered_enum = [v for v in enum_list if v in valid_ethnicity_codes]
                                    if filtered_enum:
                                        eth_code = random.choice(filtered_enum)
                                        if context_dict is not None:
                                            context_dict['ethnicity_code'] = eth_code
                                        return eth_code
                            return random.choice(enum_list)
                except (AttributeError, TypeError):
                    pass

    # FIX: Handle display names based on context - ensure they match the code
    if tag_name == f"{COCO_NS}display":
        # Check parent element context (more reliable)
        parent_context = ""
        if parent_xml_elem is not None:
            parent_tag = parent_xml_elem.tag.split('}')[-1] if '}' in parent_xml_elem.tag else parent_xml_elem.tag
            parent_context = parent_tag.lower()
        elem_name_str = str(xsd_element.name) if hasattr(xsd_element, 'name') and xsd_element.name else ""
        context_str = f"{parent_context} {elem_name_str}".lower()
        
        # Check if we're in a language context - look for sibling language_code
        if "language" in context_str or "communication" in context_str:
            # First check context dict (most reliable)
            if context_dict is not None and 'language_code' in context_dict:
                lang_code = context_dict['language_code']
                display = fhir_mappings.get_language_display(lang_code)
                if display and display != lang_code:  # Only use if we got a real display, not the code fallback
                    return display
            # Fallback: look for language_code in parent's children (siblings)
            if parent_xml_elem is not None:
                # Look for language_code in parent's children (siblings)
                # Handle both namespaced and non-namespaced tags
                for child in parent_xml_elem:
                    # Get local name (strip namespace if present)
                    child_local_name = child.tag.split('}')[-1] if '}' in child.tag else child.tag
                    if child_local_name == "language_code" and child.text:
                        lang_code = child.text
                        display = fhir_mappings.get_language_display(lang_code)
                        if display and display != lang_code:  # Only use if we got a real display, not the code fallback
                            return display
            return random.choice(list(LANGUAGE_DISPLAY_MAP.values()))
        # For race/ethnicity, look for sibling code (parent_context already set above)
        if "race" in context_str or "us_core_race" in context_str:
            # First check context dict (most reliable) - use FIRST code (XSLT uses first code)
            if context_dict is not None and 'race_code' in context_dict:
                race_code = context_dict['race_code']
                display = fhir_mappings.get_race_display(race_code)
                if display:
                    return display
            # Fallback: look for FIRST code in parent's children (siblings) - XSLT uses first code
            if parent_xml_elem is not None:
                # Look for FIRST code in parent's children (siblings)
                # Handle both namespaced and non-namespaced tags
                for child in parent_xml_elem:
                    child_local_name = child.tag.split('}')[-1] if '}' in child.tag else child.tag
                    if child_local_name == "code" and child.text:
                        race_code = child.text
                        display = fhir_mappings.get_race_display(race_code)
                        if display:
                            return display
                        break  # Use first code only
            return random.choice(list(RACE_DISPLAY_MAP.values()))
        elif "ethnicity" in context_str or "us_core_ethnicity" in context_str:
            # First check context dict (most reliable)
            if context_dict is not None and 'ethnicity_code' in context_dict:
                eth_code = context_dict['ethnicity_code']
                display = fhir_mappings.get_ethnicity_display(eth_code)
                if display:
                    return display
            # Fallback: look for code in parent's children (siblings)
            if parent_xml_elem is not None:
                # Look for code in parent's children (siblings)
                # Handle both namespaced and non-namespaced tags
                for child in parent_xml_elem:
                    child_local_name = child.tag.split('}')[-1] if '}' in child.tag else child.tag
                    if child_local_name == "code" and child.text:
                        eth_code = child.text
                        display = fhir_mappings.get_ethnicity_display(eth_code)
                        if display:
                            return display
            return random.choice(list(ETHNICITY_DISPLAY_MAP.values()))
        # Default fallback
        return "English"

    # FIX: Handle text elements for Race/Ethnicity - ensure they match the code
    if tag_name == f"{COCO_NS}text":
        # Check parent element context (more reliable)
        parent_context = ""
        if parent_xml_elem is not None:
            parent_tag = parent_xml_elem.tag.split('}')[-1] if '}' in parent_xml_elem.tag else parent_xml_elem.tag
            parent_context = parent_tag.lower()
        elem_name_str = str(xsd_element.name) if hasattr(xsd_element, 'name') and xsd_element.name else ""
        context_str = f"{parent_context} {elem_name_str}".lower()
        
        if "race" in context_str or "us_core_race" in context_str:
            # First check context dict (most reliable) - use FIRST code (XSLT uses first code)
            if context_dict is not None and 'race_code' in context_dict:
                race_code = context_dict['race_code']
                display = fhir_mappings.get_race_display(race_code)
                if display:
                    return display
            # Fallback: look for FIRST code in parent's children (siblings) - XSLT uses first code
            if parent_xml_elem is not None:
                # Look for FIRST code in parent's children (siblings)
                # Handle both namespaced and non-namespaced tags
                for child in parent_xml_elem:
                    child_local_name = child.tag.split('}')[-1] if '}' in child.tag else child.tag
                    if child_local_name == "code" and child.text:
                        race_code = child.text
                        display = fhir_mappings.get_race_display(race_code)
                        if display:
                            return display
                        break  # Use first code only
            return random.choice(list(RACE_DISPLAY_MAP.values()))
        elif "ethnicity" in context_str or "us_core_ethnicity" in context_str:
            # First check context dict (most reliable)
            if context_dict is not None and 'ethnicity_code' in context_dict:
                eth_code = context_dict['ethnicity_code']
                display = fhir_mappings.get_ethnicity_display(eth_code)
                if display:
                    return display
            # Fallback: look for code in parent's children (siblings)
            if parent_xml_elem is not None:
                # Look for code in parent's children (siblings)
                # Handle both namespaced and non-namespaced tags
                for child in parent_xml_elem:
                    child_local_name = child.tag.split('}')[-1] if '}' in child.tag else child.tag
                    if child_local_name == "code" and child.text:
                        eth_code = child.text
                        display = fhir_mappings.get_ethnicity_display(eth_code)
                        if display:
                            return display
            return random.choice(list(ETHNICITY_DISPLAY_MAP.values()))
        # Default fallback
        return "American Indian or Alaska Native"

    # FIX: Handle language_code to return valid language codes
    if tag_name == f"{COCO_NS}language_code":
        # Get all language codes including compound codes
        all_lang_codes = list(LANGUAGE_DISPLAY_MAP.keys())
        lang_code = random.choice(all_lang_codes)
        # Store the code in context for display generation
        if context_dict is not None:
            context_dict['language_code'] = lang_code
        return lang_code

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
        
        # 'date' should be a date (YYYY-MM-DD), not a dateTime
        f"{COCO_NS}date": lambda: str(fake.date()),  # change: was iso_datetime_z()
        
        f"{COCO_NS}birth_date": lambda: str(fake.date()),
        f"{COCO_NS}period": lambda: str(fake.date()),
        # FIX: Ensure Start is always before End
        # Generate start dates in the past, and track them for end date generation
        f"{COCO_NS}start": lambda: _generate_period_start(tag_name, xsd_element),
        f"{COCO_NS}end": lambda: _generate_period_end(tag_name, xsd_element),
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
        
        # add specific email tags
        f"{COCO_NS}email_plan_contact": lambda: fake.email(),
        f"{COCO_NS}email_address": lambda: fake.email(),

        # added for eob
        # add 'timing' as a date type
        f"{COCO_NS}timing": lambda: str(fake.date()),

        f"{COCO_NS}timing_date": lambda: str(fake.date()),
        f"{COCO_NS}serviced_date": lambda: str(fake.date()),
        f"{COCO_NS}value_time": lambda: str(fake.time()),
        f"{COCO_NS}due_date": lambda: str(fake.date()),
        
        # FIX: Ensure member_id_system is an absolute reference (full URL)
        f"{COCO_NS}member_id_system": lambda: "http://terminology.cocodata.org/identifiers/member-id"
        
        # FIX: Race/Ethnicity codes - these will be handled by enum extraction above,
        # but adding here as explicit fallback for code elements in race/ethnicity contexts
        # Note: The enum handling should catch these, but this ensures valid codes are used
    }
    
    # Additional check: If this is a 'code' element and we haven't handled it yet,
    # and enum extraction didn't work, try to use race/ethnicity codes as fallback
    # This handles the case where the element is in a race/ethnicity context but
    # enum extraction failed
    if tag_name == f"{COCO_NS}code" and tag_name not in tag_map:
        # Try to infer from element name or type
        elem_str = str(xsd_element.name if hasattr(xsd_element, 'name') and xsd_element.name else "")
        type_str = type_name.lower()
        context_str = f"{elem_str} {type_str}".lower()
        
        if "race" in context_str:
            # Prefer actual race codes (90% chance), otherwise use NullFlavor (10% chance)
            if random.random() < 0.9:
                return random.choice(valid_race_codes)
            else:
                return random.choice(null_flavor_codes)
        elif "ethnicity" in context_str:
            # Ethnicity codes must NEVER be UNK/ASKU - only valid codes (2135-2, 2186-5)
            return random.choice(valid_ethnicity_codes)

    if tag_name in tag_map:
        return tag_map[tag_name]()

    # 5. Type-driven fallback for temporal elements.
    # The tag_map above matches by *element name*, so any date/time-typed element whose name
    # isn't listed there (e.g. 'start_date') would otherwise fall through to fake.word() and
    # emit a non-parseable value. Resolve the root (built-in) type instead, which also covers
    # the schemas' local restriction types named 'date'/'dateTime'.
    temporal = _builtin_temporal_type(xsd_element)
    if temporal == "date":
        return str(fake.date())
    if temporal == "dateTime":
        return iso_datetime_z()
    if temporal == "time":
        return str(fake.time())

    return fake.word()


def _effective_provider_directory_child(base_child, sibling_index):
    """
    Pick practitioner vs providing_organization for the nth top-level <provider> under <providers>.
    Ensures at least one of each when sibling_index reaches 1 (primary type from YAML on 0, opposite on 1).
    """
    normalized = None if base_child in (None, "None") else base_child
    branches = ("practitioner", "providing_organization")
    if normalized is None:
        return branches[sibling_index % 2]
    other = "providing_organization" if normalized == "practitioner" else "practitioner"
    if sibling_index == 0:
        return normalized
    if sibling_index == 1:
        return other
    return branches[sibling_index % 2]


def build_element(root_element_name, schema, xsd_element=None, depth=0, canonical_name="None", child_choice="None", parent_xml_elem=None, context_dict=None, version_dir=DEFAULT_VERSION_DIR):
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
        version_dir (str): schemas/ subfolder the schema lives in (e.g., 'v11.0'), used for xsi:schemaLocation

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
            f"{XSI_NS}schemaLocation", f"{COCO_NS_BARE} ../../schemas/{version_dir}/{schema.name}")

        # Seed the schema's own version so <schema_version> reports the version it was built
        # from, no matter which schemas/<version_dir>/ folder this schema came from.
        if context_dict is None:
            context_dict = {}
        context_dict.setdefault(
            "schema_version", schema.root.get("version") or DEFAULT_SCHEMA_VERSION)

    # change: Handle content generation based on type

    # Case 1: Simple type (xs:string, xs:int) OR Complex type with simple content (<elem attr="val">text</elem>)
    # These types should receive a generated text value.
    if getattr(xsd_element.type, "is_simple", lambda: False)() or \
       (getattr(xsd_element.type, "is_complex", lambda: False)() and getattr(xsd_element.type, "has_simple_content", lambda: False)()):

        # Create context dict if not provided (for storing codes to use in display generation)
        if context_dict is None:
            context_dict = {}
        xml_elem.text = generate_value(root_element_name, xsd_element, parent_xml_elem=parent_xml_elem, context_dict=context_dict)

    # Case 2: Complex type with complex content (child elements)
    # These types should have child elements added recursively.
    elif getattr(xsd_element.type, "is_complex", lambda: False)() and \
         (getattr(xsd_element.type, "has_complex_content", lambda: False)() or getattr(xsd_element.type, "has_mixed_content", lambda: False)()) and \
         hasattr(xsd_element.type, 'content') and xsd_element.type.content:

        content_model = xsd_element.type.content

        # Create context dict if not provided (for storing codes to use in display generation)
        if context_dict is None:
            context_dict = {}
        
        # change: NEW RECURSIVE FUNCTION TO PROCESS GROUPS
        # This helper function correctly walks the XSD content model tree (sequences, choices, elements)
        def process_particle(particle, parent_xml_elem, depth_level, choice_override=None, ctx_dict=None):
            """
            Recursively processes an XSD particle (Element, Choice, Sequence, All)
            """

            if isinstance(particle, XsdElement):
                # This is an <xs:element ...>

                # maxOccurs="0" declares an element that must not appear (upstream marks
                # removed fields this way). Note max_occurs of None means unbounded, so only
                # an explicit 0 is skipped.
                if particle.max_occurs == 0:
                    return

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

                child_local = (
                    particle.name.split("}")[-1] if "}" in particle.name else particle.name
                )
                is_providerdirectory_provider = (
                    canonical_name == "providerdirectory" and child_local == "provider"
                )
                if is_providerdirectory_provider:
                    # At least two <provider> rows so we can include both practitioner and organization
                    count = max(count, 2)

                for _ in range(count):
                    per_child_choice = choice_override
                    if is_providerdirectory_provider:
                        idx = ctx_dict.setdefault("_provider_sibling_index", 0)
                        per_child_choice = _effective_provider_directory_child(
                            choice_override, idx
                        )
                        ctx_dict["_provider_sibling_index"] = idx + 1

                    child_elem = build_element(
                        particle.name,
                        schema,
                        xsd_element=particle,
                        depth=depth_level,
                        child_choice=per_child_choice,
                        canonical_name=canonical_name,
                        parent_xml_elem=parent_xml_elem,
                        context_dict=ctx_dict,
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
                                        choice_child, parent_xml_elem, depth_level, choice_override, ctx_dict=ctx_dict)
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
                            chosen_particle, parent_xml_elem, depth_level, choice_override, ctx_dict=ctx_dict)

                elif group_model in ('sequence', 'all'):
                    # --- Handle <xs:sequence> or <xs:all> ---
                    # Process *all* sub-particles in order
                    for sub_particle in particle:
                        process_particle(
                            sub_particle, parent_xml_elem, depth_level, choice_override, ctx_dict=ctx_dict)

        # Start processing the *main* content model (e.g., the <xs:sequence> of 'patient')
        # We pass the 'child_choice' from the function args as the 'choice_override'
        process_particle(content_model, xml_elem, depth + 1, child_choice, ctx_dict=context_dict)

    # Case 3: Complex type with empty content (<elem attr="val"/>)
    # This element has no children and no text, so we do nothing.

    return xml_elem