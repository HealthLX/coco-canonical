"""Element parsing with support for choices, groups, and all."""
from typing import List
from lxml import etree
from .constants import ns, logger
from .exceptions import SchemaValidationError
from .utils import get_documentation
from .simple_types import extract_enumerations


def get_tag_name(elem) -> str:
    """Safely get the tag name from an lxml element."""
    try:
        # First try QName on the element itself - this is the most reliable
        try:
            qname = etree.QName(elem)
            return qname.localname
        except (TypeError, ValueError, AttributeError):
            pass
        
        # Fallback: try accessing tag attribute
        if not hasattr(elem, 'tag'):
            return ""
        
        tag = getattr(elem, 'tag', None)
        if tag is None:
            return ""
        
        # If tag is callable (a method), try calling it
        if callable(tag):
            try:
                tag = tag()
            except:
                return ""
        
        # Convert to string
        tag_str = str(tag)
        
        # Remove namespace prefix if present (format: {namespace}localname)
        if "}" in tag_str:
            return tag_str.split("}")[-1]
        
        return tag_str
    except Exception as e:
        # Silently return empty string on any error
        return ""


def extract_element_type_info(elem) -> str:
    """Extract type information. Returns '–' for enum types to match old doc style."""
    # Check for explicit type attribute
    elem_type = elem.get("type", "")
    if elem_type:
        return elem_type
    
    # Check for anonymous simpleType with enumerations
    simple_type = elem.find("xs:simpleType", ns)
    if simple_type is not None:
        restriction = simple_type.find("xs:restriction", ns)
        if restriction is not None:
            enumerations = extract_enumerations(restriction)
            # Return '–' for enum types to match old doc format
            if enumerations and enumerations != "–":
                return "–"
            base = restriction.get("base", "")
            return base if base else "–"
    
    return "–"


def parse_choice_or_all(container_elem, parent_name: str, container_type: str) -> List[List[str]]:
    """Parse xs:choice or xs:all container and return element rows."""
    rows = []
    try:
        children = []
        for child in container_elem:
            tag_name = get_tag_name(child)
            # If tag_name is empty, try to infer from attributes (elements have "name" or "ref")
            if not tag_name:
                # Fallback: check if it looks like an element (has name or ref attribute)
                if child.get("name") or child.get("ref"):
                    tag_name = "element"
                else:
                    # Try to get tag via string conversion as last resort
                    try:
                        tag_str = str(child.tag) if hasattr(child, 'tag') else ""
                        if "element" in tag_str.lower() or child.get("name") or child.get("ref"):
                            tag_name = "element"
                    except:
                        pass
            
            if tag_name == "element":
                children.append(child)
            elif tag_name in ("choice", "sequence", "all"):
                # Nested containers
                nested_rows = parse_choice_or_all(child, parent_name, tag_name)
                rows.extend(nested_rows)
            elif not tag_name:
                # If we still can't determine, but it has a name attribute, treat as element
                if child.get("name") or child.get("ref"):
                    children.append(child)
        
        if children:
            # Document as choice or all
            type_label = "One of:" if container_type == "choice" else "All of (any order):"
            child_names = [c.get("name", "?") for c in children if c.get("name")]
            if child_names:
                rows.append(["–", parent_name, "–", f"{type_label} {', '.join(child_names)}", "–", container_type])
            
            # Parse each child element
            for child in children:
                rows.extend(parse_element_recursive(child, 0, parent_name))
    except Exception as e:
        logger.warning(f"Error parsing {container_type}: {e}")
    
    return rows


def parse_group_reference(root, group_name: str) -> List[List[str]]:
    """Resolve and parse an xs:group reference."""
    try:
        # Find the group definition
        group_def = root.find(f"./xs:group[@name='{group_name}']", ns)
        if group_def is None:
            logger.warning(f"Group '{group_name}' not found")
            return []
        
        rows = []
        # Parse the group's content (sequence, choice, or all)
        for container in group_def:
            container_type = get_tag_name(container)
            if container_type in ("sequence", "choice", "all"):
                rows.extend(parse_choice_or_all(container, "", container_type))
        return rows
    except Exception as e:
        logger.warning(f"Error parsing group '{group_name}': {e}")
        return []


def parse_element_recursive(elem, depth=0, parent_name=""):
    """Parse elements recursively with parent tracking, handling choices, groups, and all."""
    rows = []
    try:
        name = elem.get("name", "–")
        if not name or name == "–":
            logger.warning(f"Element without name attribute at depth {depth}")
            return rows
        
        # Extract type information (handles anonymous simple types)
        elem_type = extract_element_type_info(elem)
        
        min_occurs = elem.get("minOccurs", "1")
        max_occurs = elem.get("maxOccurs", "1")
        doc = get_documentation(elem)
        
        # Build cardinality string
        cardinality = f"{min_occurs}..{max_occurs}"
        
        # For PDF-style table: Name, Parent, Cardinality, Description, Examples, Data Type
        rows.append([name, parent_name, cardinality, doc, "–", elem_type])

        # Check for anonymous complexType
        complex_type = elem.find("xs:complexType", ns)
        if complex_type is not None:
            # Check for sequence, choice, all, or group
            for container in complex_type:
                container_tag = get_tag_name(container)
                
                if container_tag == "sequence":
                    # Parse sequence children
                    for child in container:
                        child_tag = get_tag_name(child)
                        # Fallback: if tag_name is empty but has name/ref, treat as element
                        if not child_tag and (child.get("name") or child.get("ref")):
                            child_tag = "element"
                        
                        if child_tag == "element":
                            rows.extend(parse_element_recursive(child, depth + 1, name))
                        elif child_tag in ("choice", "all"):
                            rows.extend(parse_choice_or_all(child, name, child_tag))
                        elif child_tag == "group":
                            group_ref = child.get("ref", "")
                            if group_ref:
                                group_name = group_ref.split(":")[-1] if ":" in group_ref else group_ref
                                # Need root to resolve group - will handle in caller
                                logger.warning(f"Group reference '{group_ref}' found but root not available in recursive context")
                        elif not child_tag and (child.get("name") or child.get("ref")):
                            # Last resort: treat as element if it has name/ref
                            rows.extend(parse_element_recursive(child, depth + 1, name))
                
                elif container_tag in ("choice", "all"):
                    rows.extend(parse_choice_or_all(container, name, container_tag))
                
                elif container_tag == "group":
                    group_ref = container.get("ref", "")
                    if group_ref:
                        group_name = group_ref.split(":")[-1] if ":" in group_ref else group_ref
                        logger.warning(f"Group reference '{group_ref}' found but root not available in recursive context")
    except Exception as e:
        logger.warning(f"Error parsing element '{name if 'name' in locals() else 'unknown'}': {e}")
    
    return rows


def parse_element_with_groups(elem, root, depth=0, parent_name=""):
    """Parse element recursively with group resolution support."""
    rows = []
    try:
        name = elem.get("name", "–")
        if not name or name == "–":
            return rows
        
        elem_type = extract_element_type_info(elem)
        min_occurs = elem.get("minOccurs", "1")
        max_occurs = elem.get("maxOccurs", "1")
        doc = get_documentation(elem)
        cardinality = f"{min_occurs}..{max_occurs}"
        
        rows.append([name, parent_name, cardinality, doc, "–", elem_type])

        complex_type = elem.find("xs:complexType", ns)
        if complex_type is not None:
            # Check for extension
            extension = complex_type.find("xs:extension", ns)
            if extension is not None:
                base_type = extension.get("base", "")
                if base_type:
                    logger.info(f"Complex type extends {base_type}")
            
            # Parse content model
            for container in complex_type:
                container_tag = get_tag_name(container)
                
                if container_tag == "sequence":
                    for child in container:
                        child_tag = get_tag_name(child)
                        # Fallback: if tag_name is empty but has name/ref, treat as element
                        if not child_tag and (child.get("name") or child.get("ref")):
                            child_tag = "element"
                        
                        if child_tag == "element":
                            rows.extend(parse_element_with_groups(child, root, depth + 1, name))
                        elif child_tag in ("choice", "all"):
                            rows.extend(parse_choice_or_all(child, name, child_tag))
                        elif child_tag == "group":
                            group_ref = child.get("ref", "")
                            if group_ref:
                                group_name = group_ref.split(":")[-1] if ":" in group_ref else group_ref
                                group_rows = parse_group_reference(root, group_name)
                                # Update parent names for group elements
                                for row in group_rows:
                                    if row[1] == "":  # Empty parent means it's a direct child
                                        row[1] = name
                                rows.extend(group_rows)
                        elif not child_tag and (child.get("name") or child.get("ref")):
                            # Last resort: treat as element if it has name/ref
                            rows.extend(parse_element_with_groups(child, root, depth + 1, name))
                
                elif container_tag in ("choice", "all"):
                    rows.extend(parse_choice_or_all(container, name, container_tag))
                
                elif container_tag == "group":
                    group_ref = container.get("ref", "")
                    if group_ref:
                        group_name = group_ref.split(":")[-1] if ":" in group_ref else group_ref
                        group_rows = parse_group_reference(root, group_name)
                        for row in group_rows:
                            if row[1] == "":
                                row[1] = name
                        rows.extend(group_rows)
    except Exception as e:
        logger.warning(f"Error parsing element '{name if 'name' in locals() else 'unknown'}': {e}")
    
    return rows


def parse_root_element(root, schema_info):
    """Parse root element with full support for groups, choices, and all."""
    try:
        root_elem = root.find(f"./xs:element[@name='{schema_info.root_element}']", ns)
        if root_elem is None:
            logger.warning(f"Root element '{schema_info.root_element}' not found in schema")
            return []
        
        return parse_element_with_groups(root_elem, root)
    except Exception as e:
        logger.error(f"Error parsing root element: {e}")
        raise SchemaValidationError(f"Failed to parse root element: {e}")


def parse_required_elements(root, schema_info):
    """Extract only required elements (minOccurs >= 1) for PDF-style table."""
    all_elements = parse_root_element(root, schema_info)
    required = []
    
    for elem in all_elements:
        # elem format: [name, parent, cardinality, description, examples, data_type]
        cardinality = elem[2]
        min_occurs = cardinality.split("..")[0]
        
        # Include if minOccurs >= 1
        if min_occurs != "0":
            required.append(elem)
    
    return required


def parse_all_elements(root, schema_info):
    """Extract all elements for PDF-style table."""
    return parse_root_element(root, schema_info)

