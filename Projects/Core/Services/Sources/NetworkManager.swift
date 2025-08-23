import Foundation
import Logging
import Networking

public final class NetworkManager {
    
    public init(network: Networking = DefaultNetwork()) {
        self.network = network
    }
    
    // MARK: -
    
    public func configure(baseURL: String, userID: String?) {
        Log.shared.core.info("Network configuration started.")
        let configuration = NetworkConfiguration(baseURL: baseURL, userID: userID)
        network.configure(with: configuration)
        Log.shared.core.info("Network configuration completed.")
    }
    
    // MARK: - Private
    
    private let network: Networking
}
