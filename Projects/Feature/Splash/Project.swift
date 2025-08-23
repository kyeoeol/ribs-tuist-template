import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    layer: .feature,
    name: "Splash",
    product: .framework,
    dependencies: [
        .Core.Services,
        .DesignSystem.Resources,
        .Shared.Logging,
        .RxSwift,
        .RIBs,
    ]
)
