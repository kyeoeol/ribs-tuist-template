#!/usr/bin/env python3
import re
import sys

if len(sys.argv) != 2:
    sys.exit(1)

layer_name = sys.argv[1]

# Read the file
with open('Tuist/ProjectDescriptionHelpers/Layer.swift', 'r') as f:
    content = f.read()

# Find existing cases
case_pattern = r'case (\w+) = "(\w+)"'
cases = re.findall(case_pattern, content)

# Add new case and sort
new_case_lower = layer_name[0].lower() + layer_name[1:]
new_case_value = layer_name
cases.append((new_case_lower, new_case_value))

# Remove duplicates and sort
cases = sorted(list(set(cases)), key=lambda x: x[0])

# Generate new enum content
enum_lines = []
for case_lower, case_value in cases:
    enum_lines.append(f'    case {case_lower} = "{case_value}"')

# Replace the enum content
new_enum = 'public enum Layer: String, CaseIterable {\n' + '\n'.join(enum_lines) + '\n}'
content = re.sub(r'public enum Layer: String, CaseIterable \{[^}]+\}', new_enum, content)

# Write back
with open('Tuist/ProjectDescriptionHelpers/Layer.swift', 'w') as f:
    f.write(content)