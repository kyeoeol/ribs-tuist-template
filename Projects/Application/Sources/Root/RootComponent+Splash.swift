import RIBs
import Splash

/// The dependencies needed from the parent scope of Root to provide for the Splash scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol RootDependencySplash: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the Splash scope.
}

extension RootComponent: SplashDependency {

    // TODO: Implement properties to provide for Splash scope.
}
