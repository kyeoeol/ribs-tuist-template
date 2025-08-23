import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    layer: .shared,
    name: "Logging",
    product: .framework
)
