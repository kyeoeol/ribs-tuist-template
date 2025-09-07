import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeApplication(
    name: "MyDemoApp",
    dependencies: [
        .RIBs,
        .RxSwift,
        .Core.Services,
        .Feature.Splash,
        .Shared.Entities,
        .Shared.Logging,
    ]
)
