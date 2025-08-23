#!/usr/bin/env python3
import re
import sys

if len(sys.argv) != 2:
    sys.exit(1)

layer_name = sys.argv[1]

# Read the file
with open('Tuist/ProjectDescriptionHelpers/TargetDependency+Extensions.swift', 'r') as f:
    content = f.read()

# Find the Internal Project Dependencies section
mark_pos = content.find('// MARK: - Internal Project Dependencies')
if mark_pos == -1:
    sys.exit(1)

section = content[mark_pos:]
ext_pos = section.find('extension TargetDependency {')
if ext_pos == -1:
    sys.exit(1)

# Find all existing public enums
enums = re.findall(r'public enum (\w+) \{', section)

# Add new enum if not exists and sort
if layer_name not in enums:
    enums.append(layer_name)
enums.sort()

# Get existing enum contents with proper indentation
enum_contents = {}
for enum in enums:
    match = re.search(r'public enum ' + re.escape(enum) + r' \{([^}]*)\}', section, re.DOTALL)
    if match:
        enum_contents[enum] = match.group(1)
    elif enum == layer_name:
        # New enum with proper indentation - empty content with 8-space indented comment placeholder
        enum_contents[enum] = '\n\n    '

# Rebuild the extension with proper indentation
new_ext = 'extension TargetDependency {\n'
for i, enum in enumerate(enums):
    # Add spacing between enums (except for the first one)
    if i > 0:
        new_ext += '    \n'
    
    # Add the enum with proper 4-space indentation
    new_ext += '    public enum ' + enum + ' {'
    
    # Add enum content
    content_lines = enum_contents[enum].rstrip()
    if content_lines:
        new_ext += content_lines
    
    # Close enum with proper indentation
    new_ext += '\n    }\n'

# Remove the trailing newline and close extension
new_ext = new_ext.rstrip() + '\n}'

# Replace in the full content
before = content[:mark_pos + ext_pos]
after_match = re.search(r'extension TargetDependency \{.*?\n\}', content[mark_pos:], re.DOTALL)
after = content[mark_pos + after_match.end():] if after_match else ''

new_content = before + new_ext + after

# Write back
with open('Tuist/ProjectDescriptionHelpers/TargetDependency+Extensions.swift', 'w') as f:
    f.write(new_content)