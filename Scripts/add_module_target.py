#!/usr/bin/env python3
import re
import sys

if len(sys.argv) != 3:
    print("Usage: add_module_target.py <layer_name> <module_name>")
    sys.exit(1)

layer_name = sys.argv[1]
module_name = sys.argv[2]

# Read the file
with open('Tuist/ProjectDescriptionHelpers/TargetDependency+Extensions.swift', 'r') as f:
    content = f.read()

# Find the Internal Project Dependencies section
mark_pos = content.find('// MARK: - Internal Project Dependencies')
if mark_pos == -1:
    print("Error: Internal Project Dependencies section not found")
    sys.exit(1)

section = content[mark_pos:]
ext_pos = section.find('extension TargetDependency {')
if ext_pos == -1:
    print("Error: TargetDependency extension not found")
    sys.exit(1)

# Find the specific enum for the layer
enum_pattern = r'public enum ' + re.escape(layer_name) + r' \{([^}]*)\}'
enum_match = re.search(enum_pattern, section, re.DOTALL)

if not enum_match:
    print(f"Error: {layer_name} enum not found in TargetDependency+Extensions.swift")
    sys.exit(1)

# Get existing enum content
enum_content = enum_match.group(1)

# Parse existing static properties
property_pattern = r'public static let (\w+): TargetDependency = \.module\(layer: \.\w+, "(\w+)"\)'
properties = re.findall(property_pattern, enum_content)

# Add new property and sort
new_property_name = module_name
properties.append((new_property_name, module_name))

# Remove duplicates and sort by property name
properties = sorted(list(set(properties)), key=lambda x: x[0])

# Generate new enum content with proper indentation
new_enum_lines = []
for prop_name, module_name_val in properties:
    layer_enum = layer_name[0].lower() + layer_name[1:] if layer_name != "DesignSystem" else "designSystem"
    new_enum_lines.append(f'        public static let {prop_name}: TargetDependency = .module(layer: .{layer_enum}, "{module_name_val}")')

# Construct new enum
new_enum_content = '\n' + '\n'.join(new_enum_lines) + '\n    '

# Replace the enum content
new_enum = f'public enum {layer_name} {{' + new_enum_content + '}'
content = re.sub(enum_pattern, new_enum, content, flags=re.DOTALL)

# Write back
with open('Tuist/ProjectDescriptionHelpers/TargetDependency+Extensions.swift', 'w') as f:
    f.write(content)

# print(f"Successfully added {module_name} to {layer_name} enum")