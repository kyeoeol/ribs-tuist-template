import Foundation
import Networking
import Logging

public final class NetworkManager {
    
    public init(network: Networking = DefaultNetwork()) {
        self.network = network
    }
    
    // MARK: -
    
    public func configure(baseURL: String, userID: String?) {
        Log.info("Network configuration started.")
        let configuration = NetworkConfiguration(baseURL: baseURL, userID: userID)
        network.configure(with: configuration)
        Log.info("Network configuration completed.")
    }
    
    // MARK: - Private
    
    private let network: Networking
}
