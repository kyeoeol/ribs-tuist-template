import RIBs
import RxSwift
import UIKit
import SwiftUI

protocol SplashPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SplashViewController: UIViewController, SplashPresentable, SplashViewControllable, SplashViewListener {
    
    weak var listener: SplashPresentableListener?
    
    private lazy var viewModel = SplashViewModel(listener: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView(view: SplashView(viewModel: viewModel))
    }
    
    private func setupView<Content>(view: Content) where Content : View {
        let contentVC = UIHostingController<Content>(rootView: view)
        
        self.addChild(contentVC)
        contentVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(contentVC.view)
        contentVC.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            contentVC.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            contentVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            contentVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}
