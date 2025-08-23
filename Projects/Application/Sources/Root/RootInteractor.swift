import Entities
import RIBs
import RxSwift
import Services
import Splash

protocol RootRouting: ViewableRouting {
    func routeToSplash()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RootInteractorDependency {
    var networkManager: NetworkManager { get }
    var baseURL: String { get }
    var userID: String? { get }
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {
    
    weak var router: RootRouting?
    weak var listener: RootListener?
    
    init(
        presenter: RootPresentable,
        dependency: RootInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        configureNetwork()
        router?.routeToSplash()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    // MARK: - Private
    
    private let dependency: RootInteractorDependency
    
    private func configureNetwork() {
        let baseURL = dependency.baseURL
        let userID = dependency.userID
        dependency.networkManager.configure(baseURL: baseURL, userID: userID)
    }
}
