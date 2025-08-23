import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    layer: .core,
    name: "Services",
    product: .framework,
    dependencies: [
        .Core.Networking,
        .Shared.Entities,
        .Shared.Logging,
        .RxSwift,
    ]
)
