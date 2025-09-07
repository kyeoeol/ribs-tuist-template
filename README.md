# RIBs Tuist Template

A comprehensive iOS project template built with **RIBs architecture** and **Tuist** for modular, scalable iOS app development. This template provides automated scripts and structured layers to help iOS developers build maintainable applications.

## 📋 Table of Contents

- [Project Structure](#-project-structure)
- [Requirements](#-requirements)
- [Getting Started](#-getting-started)
- [Makefile Commands](#-makefile-commands)
- [Development Guide](#-development-guide)
- [Scripts](#-scripts)
- [RIB Xcode Templates](#-rib-xcode-templates)

## 🏗 Project Structure

This template follows a **4-layer modular architecture** designed for iOS development best practices:

```
Projects/
├── Application/         # App entry point and main configuration
├── Core/                # Core services (Networking, APIs, etc.)
├── Feature/             # Business logic and feature modules
└── Shared/              # Common utilities and entities
```

### Layer Responsibilities

| Layer | Purpose | Contains |
|-------|---------|----------|
| **Application** | App entry point | `AppDelegate`, `SceneDelegate`, Root RIB |
| **Core** | Core infrastructure | Networking, Service managers, API clients |
| **Feature** | Business features | Feature-specific RIBs and business logic |
| **Shared** | Common utilities | Entities, Logging, Utility functions |

## 📋 Requirements

- **Xcode** 15.0+
- **iOS Deployment Target** 15.0+
- **Tuist** 4.0+ ([Installation guide](https://docs.tuist.dev/ko/guides/quick-start/install-tuist))
- **Python** 3.x (for automation scripts)

## 🚀 Getting Started

### Download the template
   - Click **"Use this template"** → **"Create a new repository"** on GitHub, OR
   - Download ZIP from GitHub and extract to your desired location

## 🔨 Makefile Commands

The template includes powerful Makefile commands to streamline your iOS development workflow:

### Essential Commands

| Command | Description | When to use |
|---------|-------------|-------------|
| `make generate` | Generate Xcode project | After cloning or pulling changes |
| `make generate-clean` | Clean everything + generate | When having build issues |
| `make clean` | Remove generated files | Before switching branches |
| `make layer` | Create new layer | Adding new architectural layer |
| `make module` | Create new module (non-Feature) | Adding modules in Core/Shared |
| `make feature` | Create Feature-layer module | Adding new features to Feature layer |

### Quick Reference

```bash
# Daily development
make generate              # Fast project generation
make generate-clean        # Full clean + generate (slower but safer)

# Architecture expansion  
make layer                 # Add new layer (e.g., "Infrastructure")
make module                # Add new module (Core/Shared)
make feature               # Add new Feature module (Layer fixed to Feature)

# Cleanup
make clean                 # Clean all generated files
```

### Detailed Command Breakdown

#### `make clean` 🧹
**Purpose**: Clean up all generated files and caches
- Removes `.xcworkspace`, `.xcodeproj`, `.build`, `DerivedData`
- Clears Tuist cache and temporary files
- **Use when**: Switching branches, resolving build issues

#### `make generate` ⚡️
**Purpose**: Quick project generation
- Runs `tuist clean` → `tuist install` → `tuist generate`
- **Use when**: Daily development, after pulling changes

#### `make generate-clean` 🔄
**Purpose**: Complete clean + generation
- Combines `make clean` + `make generate`
- **Use when**: Experiencing build issues, major changes

#### `make layer` 🏗️
**Purpose**: Create new architectural layer
- Interactive script with input validation
- Auto-updates `Layer.swift` and `TargetDependency+Extensions.swift`
- **Example**: Creating "Infrastructure" or "Analytics" layer

#### `make module` 📦
**Purpose**: Create new module in non-Feature layers
- Interactive script for module creation
- Choose target layer (Feature excluded) and configure dependencies
- Option to include Resources folder
- **Example**: Adding Core/Shared modules (e.g., "Networking", "Services", "Resources")

#### `make feature` 🎯
**Purpose**: Create new module in Feature layer
- Same interactive flow as `make module`, but layer selection is skipped
- Layer is fixed to `Feature` and enum `.feature`
- Option to include Resources folder and select dependencies
- **Example**: Adding "Login", "Profile", or "Settings" feature under Feature layer

## 📚 Development Guide

### Adding a New Feature

Follow this workflow for adding new features to your iOS app:

#### Step 1: Create Module
```bash
make module
```

Or, if the module belongs to the Feature layer:
```bash
make feature
```

#### Step 2: Configure Module
The interactive script will guide you through:
- **Module name** (e.g., `Login`, `Profile`, `Settings`)
- **Target layer** (Feature excluded here — use `make feature` for Feature layer)
- **Resources needed** (for images, colors, etc.)
- **Dependencies** (other modules this feature needs)

#### Step 3: Generated Structure
```
Projects/Feature/Login/
├── Project.swift             # Tuist project configuration
├── Sources/
│   └── DELETE_ME.swift       # Placeholder (replace with your code)
└── Resources/ (optional)
    └── Assets.xcassets/      # Images, colors, etc.
```

### Dependency Management

Dependencies are managed in `Tuist/ProjectDescriptionHelpers/TargetDependency+Extensions.swift`:

#### External Dependencies
```swift
// Third-party libraries
public static let RIBs: TargetDependency = .external(name: "RIBs")
public static let RxSwift: TargetDependency = .external(name: "RxSwift")
```

#### Internal Dependencies
```swift
// Your own modules
public enum Core {
    public static let Networking: TargetDependency = .module(layer: .core, "Networking")
    public static let Services: TargetDependency = .module(layer: .core, "Services")
}
```

## 🔧 Scripts

The template includes Python automation scripts for common iOS development tasks:

### Script Overview

| Script | Purpose | Auto-triggered by |
|--------|---------|------------------|
| `add_layer_enum.py` | Adds new layer case to `Layer.swift` | `make layer` |
| `add_module_target.py` | Adds module dependency to appropriate layer | `make module` |
| `add_target_enum.py` | Creates TargetDependency enum for new layers | `make layer` |

### What They Do

#### `add_layer_enum.py`
- Updates `Tuist/ProjectDescriptionHelpers/Layer.swift`
- Adds new layer case in alphabetical order
- Ensures proper Swift enum syntax

#### `add_module_target.py`
- Updates `Tuist/ProjectDescriptionHelpers/TargetDependency+Extensions.swift`
- Adds module reference to the correct layer enum
- Maintains alphabetical ordering

#### `add_target_enum.py`
- Creates new TargetDependency enum for layers
- Maintains proper Swift enum structure
- Alphabetically orders enums

> **Note**: These scripts are automatically executed by the Makefile commands. You typically won't need to run them manually.

## 📱 RIB Xcode Templates

This template includes comprehensive Xcode templates for rapid RIB development:

### Available Templates

| Template | Description | Generates |
|----------|-------------|-----------|
| **RIB.xctemplate** | Core RIB components | Builder, Interactor, Router |
| **RIB (ownsView)** | RIB with UIKit view | + ViewController |
| **RIB (SwiftUI)** | RIB with SwiftUI view | + SwiftUI View + ViewController wrapper |
| **Component Extension** | Child RIB integration | Component+ChildRIB.swift |
| **RIB Unit Tests** | Test scaffolding | InteractorTests, RouterTests |

### Installation & Usage

#### One-time Setup
```bash
cd tooling
./install-xcode-template.sh
```

#### Using in Xcode
1. **File** → **New** → **File**
2. Scroll to **Custom Templates** section
3. Select your desired RIB template
4. Fill in the RIB name (e.g., "Login")
5. Choose destination folder

The templates will generate properly structured RIB files with all the boilerplate code ready to use. 🚀

## 📄 License & Credits

This template is built on top of:
- **RIBs Architecture** by Uber ([GitHub](https://github.com/uber/RIBs-iOS))
- **Tuist** for project generation ([Documentation](https://docs.tuist.dev/en/))

Hope this template helps you build scalable iOS projects. Happy coding! 🚀
