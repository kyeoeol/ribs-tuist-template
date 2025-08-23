import RIBs
import Splash

protocol RootInteractable: Interactable, SplashListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func embedSplashView(_ splashViewController: SplashViewControllable)
    func removeSplashView(_ splashViewController: SplashViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        splashBuilder: SplashBuildable
    ) {
        self.splashBuilder = splashBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - RootRouting
    
    func routeToSplash() {
        let splashRouter = splashBuilder.build(withListener: interactor)
        self.splashRouter = splashRouter
        let splashViewController = splashRouter.splashViewController
        viewController.embedSplashView(splashViewController)
        attachChild(splashRouter)
    }
    
    func routeAwayFromSplash() {
        if let splashRouter = splashRouter {
            self.splashRouter = nil
            viewController.removeSplashView(splashRouter.splashViewController)
            detachChild(splashRouter)
        }
    }
    
    // MARK: - Private
    
    private let splashBuilder: SplashBuildable
    private var splashRouter: SplashRouting?
}
