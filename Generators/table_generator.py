import xml.etree.ElementTree as ET
import random

# Original table data (you can copy the `tables` array from earlier)
tables = [
    {
        "name": "Addresses",
        "columns": [
            ("ID", "Int", None, False),
            ("Region", "VarChar", N, True),
            ("StreetName", "VarChar", N, False),
            ("BuildingNumber", "Int", None, False),
            ("ApartmentNumber", "Int", None, True),
            ("PostalCode", "VarChar", 9, False)
        ],
        "pk": "ID",
        "fks": None,
        "description": "Addresses table."
    },
    {
        "name": "Students",
        "columns": [
            ("ID", "Int", None, False),
            ("FirstName", "VarChar", N, False),
            ("LastName", "VarChar", N, False),
            ("AddressID", "Int", None, True),
            ("CityID", "Int", None, True),
            ("Phone", "VarChar", 17, False)
        ],
        "pk": "ID",
        "fks": [("AddressID", "Addresses", "ID"), ("CityID", "City", "ID")],
        "description": "Students table."
    }
]

# Initialize the root for the Vertabelo XML
root = ET.Element("DatabaseLogicalModel", VersionId="1.0")

# Add general settings and properties
ET.SubElement(root, "Description")
counter = ET.SubElement(root, "Counter", Value="42")

properties = ET.SubElement(root, "Properties")
property_items = [
    ("pdf-printer-paper-size", "A4"),
    ("pdf-printer-margin-top", "10"),
    ("pdf-printer-margin-bottom", "10"),
    ("pdf-printer-margin-left", "10"),
    ("pdf-printer-margin-right", "10"),
    ("pdf-printer-page-orientation", "landscape"),
    ("pdf-printer-show-pages", "false"),
    ("pdf-printer-include-footer", "true"),
    ("reference-notation", "crows-foot"),
    ("show-only-pk-fk", "false"),
    ("pages-line-color", "#CC0000"),
    ("show-grid", "false"),
    ("grid-color", "#D9D9D9"),
    ("grid-style", "solid"),
    ("grid-spacing", "2"),
    ("grid-spacing-units", "cm"),
    ("grid-subdivisions", "1")
]
for name, value in property_items:
    prop = ET.SubElement(properties, "Property")
    ET.SubElement(prop, "Name").text = name
    ET.SubElement(prop, "Value").text = value

# Define the entities
entities = ET.SubElement(root, "Entities")

# Generate entities dynamically from the `tables` list
for table in tables:
    entity = ET.SubElement(entities, "Entity", Id=f"entity_{table['name']}")
    ET.SubElement(entity, "Name").text = table["name"]
    ET.SubElement(entity, "Description")

    # Primary identifier
    primary_identifier = ET.SubElement(entity, "PrimaryIdentifier")
    ET.SubElement(primary_identifier, "Name").text = f"{table['name']}_PI"
    pi_attributes = ET.SubElement(primary_identifier, "Attributes")
    ET.SubElement(pi_attributes, "Attribute").text = f"attribute_{table['pk']}"

    # Table attributes
    entity_attributes = ET.SubElement(entity, "Attributes")
    for idx, (col_name, col_type, col_size, nullable) in enumerate(table["columns"]):
        attribute = ET.SubElement(entity_attributes, "Attribute", Id=f"attribute_{idx}")
        ET.SubElement(attribute, "Name").text = col_name
        ET.SubElement(attribute, "Datatype").text = col_type
        ET.SubElement(attribute, "Mandatory").text = "false" if nullable else "true"
        ET.SubElement(attribute, "Comment")

    # Inheritance details
    inheritance_details = ET.SubElement(entity, "InheritanceDetails")
    ET.SubElement(inheritance_details, "ExclusiveChildren").text = "false"
    ET.SubElement(inheritance_details, "Complete").text = "false"
    ET.SubElement(inheritance_details, "GenerationStrategy").text = "OneTablePerWholeHierarchy"
    ET.SubElement(inheritance_details, "DiscriminatorName")
    ET.SubElement(inheritance_details, "DiscriminatorType").text = "Integer"

# Entity displays with random positions and sizes
entity_displays = ET.SubElement(root, "EntityDisplays")

for table in tables:
    entity_display = ET.SubElement(entity_displays, "EntityDisplay", Id=f"entityDisplay_{table['name']}")
    
    # Randomize X, Y, Width, Height
    X = round(random.uniform(6000, 7500), 2)
    Y = round(random.uniform(6500, 7000), 2)
    Width = round(random.uniform(200.0, 300.0), 2)
    Height = round(random.uniform(70.0, 150.0), 2)
    
    ET.SubElement(entity_display, "X").text = str(X)
    ET.SubElement(entity_display, "Y").text = str(Y)
    ET.SubElement(entity_display, "Width").text = str(Width)
    ET.SubElement(entity_display, "Height").text = str(Height)
    ET.SubElement(entity_display, "LineColor").text = "#000000"  # Constant line color
    ET.SubElement(entity_display, "FillColor").text = "#FFFFFF"
    ET.SubElement(entity_display, "Entity").text = f"entity_{table['name']}"
    ET.SubElement(entity_display, "FixedSize").text = "false"

# Empty sections for other parts of the schema
for tag in ["Associations", "Inheritances", "EntityRelationships", "AssociationRelationships", "Notes", "Areas"]:
    ET.SubElement(root, tag)

# Empty displays for other sections
for tag in ["AssociationDisplays", "InheritanceDisplays", "EntityRelationshipsDisplays", "AssociationRelationshipsDisplays", "NoteDisplays", "AreaDisplays"]:
    ET.SubElement(root, tag)

# Convert to string
xml_output = ET.tostring(root, encoding="unicode", method="xml")

# Save to file
with open("vertabelo_dynamic_generated.xml", "w") as f:
    f.write(xml_output)
