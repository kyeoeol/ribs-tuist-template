//___FILEHEADER___

import RIBs
import RxSwift
import UIKit
import SwiftUI

protocol ___VARIABLE_productName___PresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ___VARIABLE_productName___ViewController: UIViewController, ___VARIABLE_productName___Presentable, ___VARIABLE_productName___ViewControllable, ___VARIABLE_productName___ViewListener {
    
    weak var listener: ___VARIABLE_productName___PresentableListener?
    
    private lazy var viewModel = ___VARIABLE_productName___ViewModel(listener: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView(view: ___VARIABLE_productName___View(viewModel: viewModel))
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
