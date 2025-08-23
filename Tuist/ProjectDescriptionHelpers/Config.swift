import Foundation
import ProjectDescription

// MARK: - Project Configuration

public struct Config {
    // Basic Info
    public static let organizationName = "MyDemoOrg"
    public static let bundleIdPrefix = "com.demo"
    
    // Deployment Targets
    public static let deploymentTargets: DeploymentTargets = .iOS("15.0")
    
    // Versioning
    public static let marketingVersion = "1.0.0"
    public static let buildVersion = "1"
    
    // Swift Configuration
    public static let swiftVersion = "5.10"
}

// MARK: - Bundle ID Generators

extension Config {
    public static func bundleId(for name: String) -> String {
        let cleanName = name.lowercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
        return "\(bundleIdPrefix).\(cleanName)"
    }
}

// MARK: - InfoPlist Configurations

extension Config {
    public static let baseInfoPlist: [String: Plist.Value] = [
        "UIApplicationSupportsIndirectInputEvents": "YES",
        "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
        "CFBundleName": "$(PRODUCT_NAME)",
        "CFBundleInfoDictionaryVersion": "6.0",
        "CFBundleVersion": "\(buildVersion)",
        "UILaunchStoryboardName": "LaunchScreen",
        "CFBundleExecutable": "$(EXECUTABLE_NAME)",
        "LSRequiresIPhoneOS": "YES",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": "NO",
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                        "UISceneConfigurationName": "Default Configuration"
                    ]
                ]
            ]
        ],
        "UISupportedInterfaceOrientations": [
            "UIInterfaceOrientationPortrait"
        ],
        "CFBundlePackageType": "$(PRODUCT_BUNDLE_PACKAGE_TYPE)",
        "CFBundleDevelopmentRegion": "$(DEVELOPMENT_LANGUAGE)",
        "CFBundleShortVersionString": "\(marketingVersion)",
    ]
    
    public static let appInfoPlist: InfoPlist = .extendingDefault(with: baseInfoPlist.merging(
        [:]
    ) { _, new in new })
}

// MARK: - Settings

extension Config {
    // Base
    public static let baseBuildSettings: SettingsDictionary = [
        "SWIFT_VERSION": "\(Config.swiftVersion)",
        "CODE_SIGN_STYLE": "Manual",
        "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
        "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
    ]
    
    public static let baseDebugBuildSettings: SettingsDictionary = [:]
    
    public static let baseReleaseBuildSettings: SettingsDictionary = [:]
    
    // Framework
    public static let frameworkBuildSettings: SettingsDictionary = baseBuildSettings.merging([
        "ENABLE_MODULE_VERIFIER": "YES",
    ]) { _, new in new }
}

// MARK: - Settings Presets

extension Settings {
    public static let `default`: Settings = .settings(
        base: Config.baseBuildSettings,
        configurations: [
            .debug(name: "Debug", settings: Config.baseDebugBuildSettings),
            .release(name: "Release", settings: Config.baseReleaseBuildSettings)
        ]
    )
    
    // Framework
    public static let framework: Settings = .settings(base: Config.frameworkBuildSettings)
    
    public static func framework(with customSettings: SettingsDictionary) -> Settings {
        return .settings(
            base: Config.frameworkBuildSettings.merging(customSettings) { _, new in new }
        )
    }
}
