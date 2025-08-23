import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeApplication(
    name: "MyDemoApp",
    dependencies: [
        .Core.Services,
        .Feature.Splash,
        .Shared.Entities,
        .Shared.Logging,
        .RxSwift,
        .RIBs,
    ]
)
