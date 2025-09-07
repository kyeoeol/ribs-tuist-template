import UIKit
import RIBs
import RxSwift
import Splash

protocol RootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    // MARK: - RootViewControllable
    
    func embedSplashView(_ splashViewController: SplashViewControllable) {
        let view = splashViewController.uiviewController
        view.modalPresentationStyle = .fullScreen
        present(view, animated: false)
    }
    
    func removeSplashView(_ splashViewController: SplashViewControllable) {
        splashViewController.uiviewController.dismiss(animated: false)
    }
}
