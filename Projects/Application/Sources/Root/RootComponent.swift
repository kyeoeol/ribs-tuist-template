import RIBs
import Services
import Splash

final class RootComponent: Component<RootDependency>, RootInteractorDependency {
    
    var splashBuilder: SplashBuilder {
        SplashBuilder(dependency: self)
    }
    
    var userDefaultsManager: UserDefaultsManager {
        shared { UserDefaultsManager() }
    }
    
    var networkManager: NetworkManager {
        shared { NetworkManager() }
    }
    
    var baseURL: String {
        "https://api.demo.com"
    }
    
    var userID: String? {
        userDefaultsManager.string(forKey: .userID)
    }
}
