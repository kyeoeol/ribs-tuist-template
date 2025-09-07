import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    layer: .shared,
    name: "Entities",
    product: .framework,
    dependencies: []
)
