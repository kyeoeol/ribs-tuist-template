import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    layer: .core,
    name: "Networking",
    product: .framework,
    dependencies: [
        .Shared.Entities,
        .Shared.Logging,
    ]
)
