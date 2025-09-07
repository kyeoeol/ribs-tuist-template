.PHONY: clean generate generate-clean layer module feature

# Remove all files generated during tuist clean and generate processes
clean:
	@echo "🧹 Cleaning all generated files"
	@tuist clean
	@rm -rf *.xcworkspace
	@find . -name ".build" -type d -exec rm -rf {} +
	@rm -rf DerivedData
	@find Projects -name "*.xcodeproj" -o -name "Derived" | xargs rm -rf 2>/dev/null || true
	@find . -name "*.xcuserdata" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name "project.xcworkspace" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Clean completed!"

# Run tuist generate after tuist clean
generate:
	@echo "🔨 Generating project"
	@tuist clean
	@echo "📦 Installing dependencies"
	@tuist install
	@tuist generate
	@echo "✅ Generate completed!"

# Run tuist generate after clean task
generate-clean: clean
	@echo "🔨 Generating project after clean"
	@echo "📦 Installing dependencies"
	@tuist install
	@tuist generate
	@echo "✅ Generate-clean completed!"

# Generate new layer scaffold
layer:
	@echo "🏗️  Creating new layer"
	@while true; do \
		read -p "Enter layer name: " layer_name; \
		if [[ ! "$$layer_name" =~ ^[a-zA-Z]+$$ ]] || [[ -z "$${layer_name// }" ]]; then \
			echo "❌ Error: Layer name must contain only alphabetic characters with no spaces or whitespace"; \
			continue; \
		fi; \
		first_char=$$(echo "$$layer_name" | cut -c1); \
		if [[ "$$first_char" =~ [a-z] ]]; then \
			first_upper=$$(echo "$$first_char" | tr '[:lower:]' '[:upper:]'); \
			rest=$$(echo "$$layer_name" | cut -c2-); \
			layer_name="$$first_upper$$rest"; \
			echo "📝 Auto-capitalized first letter following convention: $$layer_name"; \
		fi; \
		if [[ -d "Projects/$$layer_name" ]]; then \
			echo "❌ Error: $$layer_name layer already exists"; \
			continue; \
		fi; \
		echo ""; \
		echo "📣 Layer '$$layer_name' will be created with the following:"; \
		echo "   • Directory: Projects/$$layer_name"; \
		echo "   • Layer case: $$(echo "$$layer_name" | tr '[:upper:]' '[:lower:]') = \"$$layer_name\""; \
		echo "   • TargetDependency path: public enum $$layer_name"; \
		echo ""; \
		while true; do \
			read -p "Do you want to proceed? (y/n): " confirm; \
			case $$confirm in \
				[Yy]|[Yy][Ee][Ss]) \
					break 2; \
					;; \
				[Nn]|[Nn][Oo]) \
					echo "🚫 Layer creation cancelled"; \
					exit 0; \
					;; \
				*) \
					echo "Please answer y (yes) or n (no)"; \
					;; \
			esac; \
		done; \
	done; \
	echo "📁 Creating Projects/$$layer_name directory"; \
	mkdir -p "Projects/$$layer_name"; \
	echo "📝 Adding new case to 'Layer.swift' enum in alphabetical order"; \
	python3 Scripts/add_layer_enum.py "$$layer_name"; \
	echo "📝 Adding public enum to 'TargetDependency+Extensions.swift' in alphabetical order"; \
	python3 Scripts/add_target_enum.py "$$layer_name"; \
	echo "✅ Layer $$layer_name created successfully!"

# Generate new module scaffold
module:
	@echo "🏗️  Creating new module"
	@while true; do \
		read -p "Enter module name: " module_name; \
		if [[ ! "$$module_name" =~ ^[a-zA-Z]+$$ ]] || [[ -z "$${module_name// }" ]]; then \
			echo "❌ Error: Module name must contain only alphabetic characters with no spaces or whitespace"; \
			continue; \
		fi; \
		first_char=$$(echo "$$module_name" | cut -c1); \
		if [[ "$$first_char" =~ [a-z] ]]; then \
			first_upper=$$(echo "$$first_char" | tr '[:lower:]' '[:upper:]'); \
			rest=$$(echo "$$module_name" | cut -c2-); \
			module_name="$$first_upper$$rest"; \
			echo "📝 Auto-capitalized first letter following convention: $$module_name"; \
		fi; \
		break; \
	done; \
	echo ""; \
	echo "📋 Available layers (excluding Application and Feature):"; \
	available_layers=(); \
	layer_enums=(); \
	counter=1; \
	while IFS= read -r line; do \
		if [[ $$line =~ ^[[:space:]]*case[[:space:]]+([a-zA-Z]+)[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then \
			enum_name=$${BASH_REMATCH[1]}; \
			layer_name=$${BASH_REMATCH[2]}; \
			if [[ "$$layer_name" != "Application" && "$$layer_name" != "Feature" ]]; then \
				echo "   $$counter) $$layer_name"; \
				available_layers+=("$$layer_name"); \
				layer_enums+=("$$enum_name"); \
				((counter++)); \
			fi; \
		fi; \
	done < "Tuist/ProjectDescriptionHelpers/Layer.swift"; \
	total_layers=$$((counter - 1)); \
	echo ""; \
	while true; do \
		read -p "Select layer (1-$$total_layers): " layer_choice; \
		if [[ "$$layer_choice" =~ ^[0-9]+$$ ]] && [ "$$layer_choice" -ge 1 ] && [ "$$layer_choice" -le "$$total_layers" ]; then \
			array_index=$$((layer_choice - 1)); \
			selected_layer="$${available_layers[$$array_index]}"; \
			layer_enum="$${layer_enums[$$array_index]}"; \
			break; \
		else \
			echo "Please select a valid option (1-$$total_layers)"; \
		fi; \
	done; \
	if [[ -d "Projects/$$selected_layer/$$module_name" ]]; then \
		echo "❌ Error: Module $$module_name already exists in $$selected_layer layer"; \
		exit 1; \
	fi; \
	echo ""; \
	echo "📋 Available dependencies:"; \
	declare -a external_deps; \
	declare -a internal_deps; \
	declare -a all_deps; \
	dep_counter=1; \
	echo "   External:"; \
	while IFS= read -r line; do \
		if [[ $$line =~ ^[[:space:]]*public[[:space:]]+static[[:space:]]+let[[:space:]]+([a-zA-Z0-9_]+):[[:space:]]*TargetDependency[[:space:]]*=[[:space:]]*\.external\(name:[[:space:]]*\"([^\"]+)\"\) ]]; then \
			dep_name=$${BASH_REMATCH[1]}; \
			echo "     $$dep_counter) $$dep_name"; \
			external_deps+=(".$$dep_name"); \
			all_deps+=(".$$dep_name"); \
			((dep_counter++)); \
		fi; \
	done < "Tuist/ProjectDescriptionHelpers/TargetDependency+Extensions.swift"; \
	echo "   Internal:"; \
	while IFS= read -r line; do \
		if [[ $$line =~ ^[[:space:]]*public[[:space:]]+enum[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]*\{ ]]; then \
			current_enum=$${BASH_REMATCH[1]}; \
		elif [[ $$line =~ ^[[:space:]]*public[[:space:]]+static[[:space:]]+let[[:space:]]+([a-zA-Z0-9_]+):[[:space:]]*TargetDependency[[:space:]]*=[[:space:]]*\.module\( ]] && [[ -n "$$current_enum" ]] && [[ "$$current_enum" != "Feature" ]]; then \
			prop_name=$${BASH_REMATCH[1]}; \
			dep_path="$$current_enum.$$prop_name"; \
			echo "     $$dep_counter) $$dep_path"; \
			internal_deps+=(".$$dep_path"); \
			all_deps+=(".$$dep_path"); \
			((dep_counter++)); \
		elif [[ $$line =~ ^\} ]]; then \
			current_enum=""; \
		fi; \
	done < "Tuist/ProjectDescriptionHelpers/TargetDependency+Extensions.swift"; \
	total_deps=$$((dep_counter - 1)); \
	echo ""; \
	echo "Select dependencies (comma-separated numbers, or press Enter for none):"; \
	read -p "Dependencies: " deps_input; \
	dependencies=""; \
	dep_list=""; \
	if [[ -n "$$deps_input" ]]; then \
		IFS=',' read -ra DEPS <<< "$$deps_input"; \
		for dep in "$${DEPS[@]}"; do \
			dep=$$(echo "$$dep" | xargs); \
			if [[ "$$dep" =~ ^[0-9]+$$ ]] && [ "$$dep" -ge 1 ] && [ "$$dep" -le "$$total_deps" ]; then \
				array_index=$$((dep - 1)); \
				selected_dep="$${all_deps[$$array_index]}"; \
				dependencies="$$dependencies        $$selected_dep,\n"; \
				if [[ -z "$$dep_list" ]]; then \
					dep_list="$$selected_dep"; \
				else \
					dep_list="$$dep_list, $$selected_dep"; \
				fi; \
			fi; \
		done; \
		dependencies=$$(printf "$$dependencies" | sed '$$s/,$$//'); \
	fi; \
	echo ""; \
	echo "📣 Module '$$module_name' will be created with the following:"; \
	echo "   • Layer: $$selected_layer"; \
	echo "   • Directory: Projects/$$selected_layer/$$module_name"; \
	if [[ -n "$$dep_list" ]]; then \
		echo "   • Dependencies: $$dep_list"; \
	else \
		echo "   • Dependencies: none"; \
	fi; \
	echo ""; \
	while true; do \
		read -p "Do you want to proceed? (y/n): " confirm; \
		case $$confirm in \
			[Yy]|[Yy][Ee][Ss]) break;; \
			[Nn]|[Nn][Oo]) echo "🚫 Module creation cancelled"; exit 0;; \
			*) echo "Please answer y (yes) or n (no)";; \
		esac; \
	done; \
	echo "📁 Creating Projects/$$selected_layer/$$module_name directory structure"; \
	mkdir -p "Projects/$$selected_layer/$$module_name/Sources"; \
	echo "// TODO: Implement this module" > "Projects/$$selected_layer/$$module_name/Sources/DELETE_ME.swift"; \
	echo "📝 Creating Project.swift file"; \
	project_content="import ProjectDescription\nimport ProjectDescriptionHelpers\n\nlet project = Project.makeModule(\n    layer: .$$layer_enum,\n    name: \"$$module_name\",\n    product: .framework,"; \
	if [[ -n "$$dependencies" ]]; then \
		project_content="$$project_content\n    dependencies: [\n$$dependencies\n    ]"; \
	else \
		project_content="$$project_content\n    dependencies: []"; \
	fi; \
	project_content="$$project_content\n)"; \
	printf "$$project_content" > "Projects/$$selected_layer/$$module_name/Project.swift"; \
	echo "📝 Adding module to TargetDependency+Extensions.swift"; \
	python3 Scripts/add_module_target.py "$$selected_layer" "$$module_name"; \
	echo "✅ Module $$module_name created successfully in $$selected_layer layer!"

# Generate new Feature-layer module scaffold (layer preselected)
feature:
	@echo "🏗️  Creating new Feature module"
	@while true; do \
		read -p "Enter module name: " module_name; \
		if [[ ! "$$module_name" =~ ^[a-zA-Z]+$$ ]] || [[ -z "$${module_name// }" ]]; then \
			echo "❌ Error: Module name must contain only alphabetic characters with no spaces or whitespace"; \
			continue; \
		fi; \
		first_char=$$(echo "$$module_name" | cut -c1); \
		if [[ "$$first_char" =~ [a-z] ]]; then \
			first_upper=$$(echo "$$first_char" | tr '[:lower:]' '[:upper:]'); \
			rest=$$(echo "$$module_name" | cut -c2-); \
			module_name="$$first_upper$$rest"; \
			echo "📝 Auto-capitalized first letter following convention: $$module_name"; \
		fi; \
		break; \
	done; \
	selected_layer="Feature"; \
	layer_enum="feature"; \
	if [[ -d "Projects/$$selected_layer/$$module_name" ]]; then \
		echo "❌ Error: Module $$module_name already exists in $$selected_layer layer"; \
		exit 1; \
	fi; \
	echo ""; \
	echo "📋 Available dependencies:"; \
	declare -a external_deps; \
	declare -a internal_deps; \
	declare -a all_deps; \
	dep_counter=1; \
	echo "   External:"; \
	while IFS= read -r line; do \
		if [[ $$line =~ ^[[:space:]]*public[[:space:]]+static[[:space:]]+let[[:space:]]+([a-zA-Z0-9_]+):[[:space:]]*TargetDependency[[:space:]]*=[[:space:]]*\.external\(name:[[:space:]]*\"([^\"]+)\"\) ]]; then \
			dep_name=$${BASH_REMATCH[1]}; \
			echo "     $$dep_counter) $$dep_name"; \
			external_deps+=(".$$dep_name"); \
			all_deps+=(".$$dep_name"); \
			((dep_counter++)); \
		fi; \
	done < "Tuist/ProjectDescriptionHelpers/TargetDependency+Extensions.swift"; \
	echo "   Internal:"; \
	current_enum=""; \
	while IFS= read -r line; do \
		if [[ $$line =~ ^[[:space:]]*public[[:space:]]+enum[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]*\{ ]]; then \
			current_enum=$${BASH_REMATCH[1]}; \
		elif [[ $$line =~ ^[[:space:]]*public[[:space:]]+static[[:space:]]+let[[:space:]]+([a-zA-Z0-9_]+):[[:space:]]*TargetDependency[[:space:]]*=[[:space:]]*\.module\( ]] && [[ -n "$$current_enum" ]]; then \
			prop_name=$${BASH_REMATCH[1]}; \
			dep_path="$$current_enum.$$prop_name"; \
			echo "     $$dep_counter) $$dep_path"; \
			internal_deps+=(".$$dep_path"); \
			all_deps+=(".$$dep_path"); \
			((dep_counter++)); \
		elif [[ $$line =~ ^\} ]]; then \
			current_enum=""; \
		fi; \
	done < "Tuist/ProjectDescriptionHelpers/TargetDependency+Extensions.swift"; \
	total_deps=$$((dep_counter - 1)); \
	echo ""; \
	echo "Select dependencies (comma-separated numbers, or press Enter for none):"; \
	read -p "Dependencies: " deps_input; \
	dependencies=""; \
	dep_list=""; \
	if [[ -n "$$deps_input" ]]; then \
		IFS=',' read -ra DEPS <<< "$$deps_input"; \
		for dep in "$${DEPS[@]}"; do \
			dep=$$(echo "$$dep" | xargs); \
			if [[ "$$dep" =~ ^[0-9]+$$ ]] && [ "$$dep" -ge 1 ] && [ "$$dep" -le "$$total_deps" ]; then \
				array_index=$$((dep - 1)); \
				selected_dep="$${all_deps[$$array_index]}"; \
				dependencies="$$dependencies        $$selected_dep,\n"; \
				if [[ -z "$$dep_list" ]]; then \
					dep_list="$$selected_dep"; \
				else \
					dep_list="$$dep_list, $$selected_dep"; \
				fi; \
			fi; \
		done; \
		dependencies=$$(printf "$$dependencies" | sed '$$s/,$$//'); \
	fi; \
	echo ""; \
	echo "📣 Module '$$module_name' will be created with the following:"; \
	echo "   • Layer: $$selected_layer"; \
	echo "   • Directory: Projects/$$selected_layer/$$module_name"; \
	echo "   • Resources folder: yes"; \
	if [[ -n "$$dep_list" ]]; then \
		echo "   • Dependencies: $$dep_list"; \
	else \
		echo "   • Dependencies: none"; \
	fi; \
	echo ""; \
	while true; do \
		read -p "Do you want to proceed? (y/n): " confirm; \
		case $$confirm in \
			[Yy]|[Yy][Ee][Ss]) break;; \
			[Nn]|[Nn][Oo]) echo "🚫 Module creation cancelled"; exit 0;; \
			*) echo "Please answer y (yes) or n (no)";; \
		esac; \
	done; \
	echo "📁 Creating Projects/$$selected_layer/$$module_name directory structure"; \
	mkdir -p "Projects/$$selected_layer/$$module_name/Sources"; \
	mkdir -p "Projects/$$selected_layer/$$module_name/Resources/Assets.xcassets"; \
	printf '{\n  "info" : {\n    "author" : "xcode",\n    "version" : 1\n  }\n}\n' > "Projects/$$selected_layer/$$module_name/Resources/Assets.xcassets/Contents.json"; \
	echo "// TODO: Implement this module" > "Projects/$$selected_layer/$$module_name/Sources/DELETE_ME.swift"; \
	echo "📝 Creating Project.swift file"; \
	project_content="import ProjectDescription\nimport ProjectDescriptionHelpers\n\nlet project = Project.makeModule(\n    layer: .$$layer_enum,\n    name: \"$$module_name\",\n    product: .framework,"; \
	if [[ -n "$$dependencies" ]]; then \
		project_content="$$project_content\n    dependencies: [\n$$dependencies\n    ]"; \
	else \
		project_content="$$project_content\n    dependencies: []"; \
	fi; \
	project_content="$$project_content\n)"; \
	printf "$$project_content" > "Projects/$$selected_layer/$$module_name/Project.swift"; \
	echo "📝 Adding module to TargetDependency+Extensions.swift"; \
	python3 Scripts/add_module_target.py "$$selected_layer" "$$module_name"; \
	echo "✅ Feature module $$module_name created successfully!"
