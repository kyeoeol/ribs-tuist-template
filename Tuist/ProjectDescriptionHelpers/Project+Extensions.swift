import ProjectDescription

extension Project {
    public static func makeApplication(
        name: String,
        dependencies: [TargetDependency]
    ) -> Project {
        return Project(
            name: "Application",
            organizationName: Config.organizationName,
            settings: .default,
            targets: [
                .target(
                    name: name,
                    destinations: [.iPhone],
                    product: .app,
                    bundleId: Config.bundleId(for: name),
                    deploymentTargets: Config.deploymentTargets,
                    infoPlist: Config.appInfoPlist,
                    sources: ["Sources/**"],
                    resources: ["Resources/**"],
                    dependencies: dependencies
                )
            ]
        )
    }
    
    public static func makeModule(
        layer: Layer,
        name: String,
        product: Product,
        dependencies: [TargetDependency],
        customSettings: SettingsDictionary = [:]
    ) -> Project {
        return Project(
            name: name,
            organizationName: Config.organizationName,
            options: .options(
                automaticSchemesOptions: .disabled
            ),
            settings: .framework(with: customSettings),
            targets: [
                .target(
                    name: name,
                    destinations: [.iPhone],
                    product: product,
                    bundleId: layer.bundleId(for: name),
                    deploymentTargets: Config.deploymentTargets,
                    sources: ["Sources/**"],
                    resources: layer == .feature ? ["Resources/**"] : nil,
                    dependencies: dependencies
                )
            ]
        )
    }
}
