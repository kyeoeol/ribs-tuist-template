import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    layer: .designSystem,
    name: "Resources",
    product: .framework,
    requiresResources: true
)
