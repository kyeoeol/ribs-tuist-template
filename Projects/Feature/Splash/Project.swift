import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    layer: .feature,
    name: "Splash",
    product: .framework,
    dependencies: [
        .RIBs,
        .RxSwift,
        .Core.Services,
        .Shared.Entities,
        .Shared.Logging,
    ]
)
