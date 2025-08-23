import SwiftUI

protocol SplashViewListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with ViewController.
}

final class SplashViewModel: ObservableObject {
    private weak var listener: SplashViewListener?
    
    // TODO: Add @Published properties for UI state management
    // Example: @Published var hello: String = "Hello, world!"
    
    init(listener: SplashViewListener? = nil) {
        self.listener = listener
    }
    
    // TODO: Add methods to handle user interactions and communicate with listener
    // Example: func doSomething() { listener?.didSomething() }
}

struct SplashView: View {
    
    @ObservedObject private var viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("SplashView")
    }
}
