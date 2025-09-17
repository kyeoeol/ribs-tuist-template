//___FILEHEADER___

import RIBs

public protocol ___VARIABLE_productName___Dependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ___VARIABLE_productName___Component: Component<___VARIABLE_productName___Dependency> {
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol ___VARIABLE_productName___Buildable: Buildable {
    func build(withListener listener: ___VARIABLE_productName___Listener) -> ___VARIABLE_productName___Routing
}

public final class ___VARIABLE_productName___Builder: Builder<___VARIABLE_productName___Dependency>, ___VARIABLE_productName___Buildable {
    
    public override init(dependency: ___VARIABLE_productName___Dependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: ___VARIABLE_productName___Listener) -> ___VARIABLE_productName___Routing {
        let component = ___VARIABLE_productName___Component(dependency: dependency)
        let viewController = ___VARIABLE_productName___ViewController()
        let interactor = ___VARIABLE_productName___Interactor(presenter: viewController)
        interactor.listener = listener
        return ___VARIABLE_productName___Router(interactor: interactor, viewController: viewController)
    }
}
