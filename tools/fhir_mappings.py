"""
FHIR Code-Display Mappings for Sample Data Generation

This module contains mappings between codes and their official display names
as required by FHIR US Core profiles. These mappings ensure that generated
sample data passes FHIR validation.

All mappings follow the official terminology standards:
- Race: OMB Race Categories (urn:oid:2.16.840.1.113883.6.238)
- Ethnicity: OMB Ethnicity Categories (urn:oid:2.16.840.1.113883.6.238)
- Language: IETF BCP 47 language tags (urn:ietf:bcp:47)
"""

# OMB Race Category Codes (from urn:oid:2.16.840.1.113883.6.238)
# Source: https://www.hl7.org/fhir/us/core/ValueSet-omb-race-category.html
RACE_DISPLAY_MAP = {
    "1002-5": "American Indian or Alaska Native",
    "2028-9": "Asian",
    "2054-5": "Black or African American",
    "2076-8": "Native Hawaiian or Other Pacific Islander",
    "2106-3": "White",
    "UNK": "unknown",  # NullFlavor
    "ASKU": "asked but unknown"  # NullFlavor
}

# OMB Ethnicity Category Codes (from urn:oid:2.16.840.1.113883.6.238)
# Source: https://www.hl7.org/fhir/us/core/ValueSet-omb-ethnicity-category.html
ETHNICITY_DISPLAY_MAP = {
    "2135-2": "Hispanic or Latino",
    "2186-5": "Not Hispanic or Latino",
    "UNK": "unknown",  # NullFlavor
    "ASKU": "asked but unknown"  # NullFlavor
}

# IETF BCP 47 Language Codes (from urn:ietf:bcp:47)
# Complete language codes with their official display names
# Source: ISO 639-1 and HL7 FHIR Language ValueSet
# Reference: http://hl7.org/fhir/R4/valueset-languages.html
LANGUAGE_DISPLAY_MAP = {
    # A
    "aa": "Afar",
    "ab": "Abkhazian",
    "ae": "Avestan",
    "af": "Afrikaans",
    "ak": "Akan",
    "am": "Amharic",
    "an": "Aragonese",
    "ar": "Arabic",
    "as": "Assamese",
    "av": "Avaric",
    "ay": "Aymara",
    "az": "Azerbaijani",
    # B
    "ba": "Bashkir",
    "be": "Belarusian",
    "bg": "Bulgarian",
    "bi": "Bislama",
    "bm": "Bambara",
    "bn": "Bengali",
    "bo": "Tibetan",
    "br": "Breton",
    "bs": "Bosnian",
    # C
    "ca": "Catalan",
    "ce": "Chechen",
    "ch": "Chamorro",
    "co": "Corsican",
    "cr": "Cree",
    "cs": "Czech",
    "cu": "Church Slavic",
    "cv": "Chuvash",
    "cy": "Welsh",
    # D
    "da": "Danish",
    "de": "German",
    "dv": "Dhivehi",
    "dz": "Dzongkha",
    # E
    "ee": "Ewe",
    "el": "Greek",
    "en": "English",
    "eo": "Esperanto",
    "es": "Spanish",
    "et": "Estonian",
    "eu": "Basque",
    # F
    "fa": "Persian",
    "ff": "Fulah",
    "fi": "Finnish",
    "fj": "Fijian",
    "fo": "Faroese",
    "fr": "French",
    "fy": "Western Frisian",
    # G
    "ga": "Irish",
    "gd": "Scottish Gaelic",
    "gl": "Galician",
    "gn": "Guarani",
    "gu": "Gujarati",
    "gv": "Manx",
    # H
    "ha": "Hausa",
    "he": "Hebrew",
    "hi": "Hindi",
    "ho": "Hiri Motu",
    "hr": "Croatian",
    "ht": "Haitian",
    "hu": "Hungarian",
    "hy": "Armenian",
    "hz": "Herero",
    # I
    "ia": "Interlingua",
    "id": "Indonesian",
    "ie": "Interlingue",
    "ig": "Igbo",
    "ii": "Sichuan Yi",
    "ik": "Inupiaq",
    "io": "Ido",
    "is": "Icelandic",
    "it": "Italian",
    "iu": "Inuktitut",
    # J
    "ja": "Japanese",
    "jv": "Javanese",
    # K
    "ka": "Georgian",
    "kg": "Kongo",
    "ki": "Kikuyu",
    "kj": "Kuanyama",
    "kk": "Kazakh",
    "kl": "Kalaallisut",
    "km": "Khmer",
    "kn": "Kannada",
    "ko": "Korean",
    "kr": "Kanuri",
    "ks": "Kashmiri",
    "ku": "Kurdish",
    "kv": "Komi",
    "kw": "Cornish",
    "ky": "Kyrgyz",
    # L
    "la": "Latin",
    "lb": "Luxembourgish",
    "lg": "Ganda",
    "li": "Limburgish",
    "ln": "Lingala",
    "lo": "Lao",
    "lt": "Lithuanian",
    "lu": "Luba-Katanga",
    "lv": "Latvian",
    # M
    "mg": "Malagasy",
    "mh": "Marshallese",
    "mi": "Maori",
    "mk": "Macedonian",
    "ml": "Malayalam",
    "mn": "Mongolian",
    "mr": "Marathi",
    "ms": "Malay",
    "mt": "Maltese",
    "my": "Burmese",
    # N
    "na": "Nauru",
    "nb": "Norwegian Bokmål",
    "nd": "North Ndebele",
    "ne": "Nepali",
    "ng": "Ndonga",
    "nl": "Dutch",
    "nn": "Norwegian Nynorsk",
    "no": "Norwegian",
    "nr": "South Ndebele",
    "nv": "Navajo",
    "ny": "Nyanja",
    # O
    "oc": "Occitan",
    "oj": "Ojibwa",
    "om": "Oromo",
    "or": "Oriya",
    "os": "Ossetian",
    # P
    "pa": "Punjabi",
    "pi": "Pali",
    "pl": "Polish",
    "ps": "Pashto",
    "pt": "Portuguese",
    # Q
    "qu": "Quechua",
    # R
    "rm": "Romansh",
    "rn": "Kirundi",
    "ro": "Romanian",
    "ru": "Russian",
    "rw": "Kinyarwanda",
    # S
    "sa": "Sanskrit",
    "sc": "Sardinian",
    "sd": "Sindhi",
    "se": "Northern Sami",
    "sg": "Sango",
    "si": "Sinhala",
    "sk": "Slovak",
    "sl": "Slovenian",
    "sm": "Samoan",
    "sn": "Shona",
    "so": "Somali",
    "sq": "Albanian",
    "sr": "Serbian",
    "ss": "Swati",
    "st": "Southern Sotho",
    "su": "Sundanese",
    "sv": "Swedish",
    "sw": "Swahili",
    # T
    "ta": "Tamil",
    "te": "Telugu",
    "tg": "Tajik",
    "th": "Thai",
    "ti": "Tigrinya",
    "tk": "Turkmen",
    "tl": "Tagalog",
    "tn": "Tswana",
    "to": "Tongan",
    "tr": "Turkish",
    "ts": "Tsonga",
    "tt": "Tatar",
    "tw": "Twi",
    "ty": "Tahitian",
    # U
    "ug": "Uyghur",
    "uk": "Ukrainian",
    "ur": "Urdu",
    "uz": "Uzbek",
    # V
    "ve": "Venda",
    "vi": "Vietnamese",
    "vo": "Volapük",
    # W
    "wa": "Walloon",
    "wo": "Wolof",
    # X
    "xh": "Xhosa",
    # Y
    "yi": "Yiddish",
    "yo": "Yoruba",
    # Z
    "za": "Zhuang",
    "zh": "Chinese",
    "zu": "Zulu",
    # Compound language codes (language-region)
    "zh-CN": "Chinese (Region=China)",
    "zh-HK": "Chinese (Region=Hong Kong)",
    "zh-SG": "Chinese (Region=Singapore)",
    "zh-TW": "Chinese (Region=Taiwan)",
    "en-AU": "English (Region=Australia)",
    "en-CA": "English (Region=Canada)",
    "en-GB": "English (Region=United Kingdom)",
    "en-IN": "English (Region=India)",
    "en-NZ": "English (Region=New Zealand)",
    "en-SG": "English (Region=Singapore)",
    "en-US": "English (Region=United States)",
    "es-AR": "Spanish (Region=Argentina)",
    "es-ES": "Spanish (Region=Spain)",
    "es-UY": "Spanish (Region=Uruguay)",
    "fr-BE": "French (Region=Belgium)",
    "fr-CH": "French (Region=Switzerland)",
    "fr-FR": "French (Region=France)",
    "de-AT": "German (Region=Austria)",
    "de-CH": "German (Region=Switzerland)",
    "de-DE": "German (Region=Germany)",
    "it-CH": "Italian (Region=Switzerland)",
    "it-IT": "Italian (Region=Italy)",
    "nl-BE": "Dutch (Region=Belgium)",
    "nl-NL": "Dutch (Region=Netherlands)",
    "pt-BR": "Portuguese (Region=Brazil)",
    "ru-RU": "Russian (Region=Russia)",
    "sr-RS": "Serbian (Region=Serbia)",
    "sv-SE": "Swedish (Region=Sweden)",
    "no-NO": "Norwegian (Region=Norway)",
    "fy-NL": "Frisian (Region=Netherlands)"
}

# Reverse mappings for looking up codes from display names (if needed)
RACE_CODE_MAP = {v: k for k, v in RACE_DISPLAY_MAP.items()}
ETHNICITY_CODE_MAP = {v: k for k, v in ETHNICITY_DISPLAY_MAP.items()}
LANGUAGE_CODE_MAP = {v: k for k, v in LANGUAGE_DISPLAY_MAP.items()}


def get_race_display(code):
    """Get the official display name for a race code."""
    return RACE_DISPLAY_MAP.get(code, "unknown")


def get_ethnicity_display(code):
    """Get the official display name for an ethnicity code."""
    return ETHNICITY_DISPLAY_MAP.get(code, "unknown")


def get_language_display(code):
    """Get the official display name for a language code."""
    return LANGUAGE_DISPLAY_MAP.get(code, code)  # Fallback to code if not found


def get_race_code(display):
    """Get the code for a race display name."""
    return RACE_CODE_MAP.get(display)


def get_ethnicity_code(display):
    """Get the code for an ethnicity display name."""
    return ETHNICITY_CODE_MAP.get(display)


def get_language_code(display):
    """Get the code for a language display name."""
    return LANGUAGE_CODE_MAP.get(display)


def get_all_race_codes():
    """Get all valid race codes."""
    return list(RACE_DISPLAY_MAP.keys())


def get_all_ethnicity_codes():
    """Get all valid ethnicity codes."""
    return list(ETHNICITY_DISPLAY_MAP.keys())


def get_all_language_codes():
    """Get all valid language codes."""
    return list(LANGUAGE_DISPLAY_MAP.keys())


def get_race_codes_without_nullflavor():
    """Get race codes excluding NullFlavor codes."""
    return [code for code in RACE_DISPLAY_MAP.keys() if code not in ["UNK", "ASKU"]]


def get_ethnicity_codes_without_nullflavor():
    """Get ethnicity codes excluding NullFlavor codes."""
    return [code for code in ETHNICITY_DISPLAY_MAP.keys() if code not in ["UNK", "ASKU"]]
