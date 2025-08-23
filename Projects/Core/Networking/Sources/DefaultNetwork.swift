import Entities
import Foundation
import Logging

public struct NetworkConfiguration {
    public let baseURL: String
    public let userID: String?
    
    public init(
        baseURL: String,
        userID: String?
    ) {
        self.baseURL = baseURL
        self.userID = userID
    }
}

public protocol Networking {
    func configure(with configuration: NetworkConfiguration)
}

public final class DefaultNetwork: Networking {
    
    public init() {}
    
    // MARK: -
    
    public func configure(with configuration: NetworkConfiguration) {
        Log.shared.core.info("Configuring DefaultNetwork...")
    }
}
