"""
Simple script to fetch language codes from the FHIR languages ValueSet API.

Fetches language codes directly from http://hl7.org/fhir/ValueSet/languages
and displays them. This is better practice for scalability and readability.

Usage:
    python test_fhir_languages_valueset.py [--server <base_url>] [--save-json <file>]
    
Examples:
    # Fetch from default servers
    python test_fhir_languages_valueset.py
    
    # Fetch from specific server
    python test_fhir_languages_valueset.py --server http://hapi.fhir.org/baseR4
    
    # Save results to JSON
    python test_fhir_languages_valueset.py --save-json languages.json
"""

import requests
import json
import argparse
from typing import Dict, Optional

# FHIR API configuration
LANGUAGES_VALUESET_URL = "http://hl7.org/fhir/ValueSet/languages"
LANGUAGE_SYSTEM = "urn:ietf:bcp:47"

# Default FHIR servers to try (in order)
DEFAULT_SERVERS = [
    "http://hapi.fhir.org/baseR4",
    "http://hl7.org/fhir",
    "https://r4.smarthealthit.org",
]


def fetch_languages_from_fhir(server_url: str = None) -> Dict[str, str]:
    """
    Fetch language codes from FHIR languages ValueSet.
    
    Args:
        server_url: Optional FHIR server base URL. If None, tries direct URL first.
        
    Returns:
        Dictionary mapping language codes to display names
    """
    language_map = {}
    
    # Try direct URL first (hl7.org hosts resources directly)
    if not server_url:
        try:
            print(f"Fetching from: {LANGUAGES_VALUESET_URL}")
            response = requests.get(LANGUAGES_VALUESET_URL, 
                                   headers={"Accept": "application/fhir+json"}, 
                                   timeout=10)
            response.raise_for_status()
            valueset = response.json()
            
            if valueset.get("resourceType") == "ValueSet":
                language_map = _extract_from_compose(valueset)
                if language_map:
                    print(f"[OK] Retrieved {len(language_map)} language codes")
                    return language_map
        except Exception as e:
            print(f"  Direct fetch failed: {e}")
    
    # Try via FHIR server search
    servers_to_try = [server_url] if server_url else DEFAULT_SERVERS
    
    for server in servers_to_try:
        if not server:
            continue
            
        try:
            print(f"Fetching from: {server}/ValueSet?url={LANGUAGES_VALUESET_URL}")
            response = requests.get(
                f"{server}/ValueSet",
                params={"url": LANGUAGES_VALUESET_URL},
                headers={"Accept": "application/fhir+json"},
                timeout=10
            )
            response.raise_for_status()
            
            bundle = response.json()
            if bundle.get("resourceType") == "Bundle" and bundle.get("total", 0) > 0:
                valueset = bundle.get("entry", [{}])[0].get("resource")
                if valueset:
                    language_map = _extract_from_compose(valueset)
                    if language_map:
                        print(f"[OK] Retrieved {len(language_map)} language codes")
                        return language_map
        except Exception as e:
            print(f"  Server {server} failed: {e}")
            continue
    
    return language_map


def _extract_from_compose(valueset: dict) -> Dict[str, str]:
    """Extract language codes from ValueSet compose.include[].concept[]"""
    language_map = {}
    
    compose = valueset.get("compose", {})
    includes = compose.get("include", [])
    
    for include in includes:
        if include.get("system") == LANGUAGE_SYSTEM:
            for concept in include.get("concept", []):
                code = concept.get("code")
                display = concept.get("display")
                if code:
                    language_map[code] = display or code
    
    return language_map


def main():
    parser = argparse.ArgumentParser(
        description="Fetch language codes from FHIR languages ValueSet"
    )
    parser.add_argument(
        "--server",
        type=str,
        help="FHIR server base URL (default: tries multiple servers)"
    )
    parser.add_argument(
        "--save-json",
        type=str,
        help="Save results to JSON file"
    )
    
    args = parser.parse_args()
    
    print("=" * 70)
    print("FHIR Languages ValueSet Fetcher")
    print("=" * 70)
    print(f"\nValueSet: {LANGUAGES_VALUESET_URL}")
    print(f"CodeSystem: {LANGUAGE_SYSTEM}\n")
    
    # Fetch languages
    language_map = fetch_languages_from_fhir(args.server)
    
    if not language_map:
        print("\n[ERROR] Failed to retrieve languages from any source")
        return 1
    
    # Display results
    print(f"\n{'=' * 70}")
    print(f"Retrieved {len(language_map)} language codes")
    print("=" * 70)
    
    # Show sample
    print("\nSample codes (first 20):")
    for code, display in sorted(list(language_map.items())[:20]):
        print(f"  {code:8} -> {display}")
    
    if len(language_map) > 20:
        print(f"\n  ... and {len(language_map) - 20} more")
    
    # Save to JSON if requested
    if args.save_json:
        with open(args.save_json, 'w', encoding='utf-8') as f:
            json.dump(language_map, f, indent=2, sort_keys=True, ensure_ascii=False)
        print(f"\n[OK] Saved to {args.save_json}")
    
    print("\n" + "=" * 70)
    return 0


if __name__ == "__main__":
    exit(main())
