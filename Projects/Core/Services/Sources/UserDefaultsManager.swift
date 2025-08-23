import Foundation
import Logging

public enum UserDefaultsKeys: String {
    case userID = "mydemo_user_id"
    case isFirstLaunch = "mydemo_is_first_launch"
}

public final class UserDefaultsManager {
    
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Generic Codable Support
    
    public func save<T>(_ value: T, forKey key: UserDefaultsKeys) where T: Codable {
        do {
            let data = try JSONEncoder().encode(value)
            userDefaults.set(data, forKey: key.rawValue)
        } catch {
            Log.shared.core.error("Failed to encode value for key \(key): \(error)")
        }
    }
    
    public func load<T>(_ type: T.Type, forKey key: UserDefaultsKeys) -> T? where T: Codable {
        guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            Log.shared.core.error("Failed to decode value for key \(key): \(error)")
            return nil
        }
    }
    
    // MARK: - Basic Types
    
    public func string(forKey key: UserDefaultsKeys) -> String? {
        return userDefaults.string(forKey: key.rawValue)
    }
    
    public func integer(forKey key: UserDefaultsKeys) -> Int {
        return userDefaults.integer(forKey: key.rawValue)
    }
    
    public func bool(forKey key: UserDefaultsKeys) -> Bool {
        return userDefaults.bool(forKey: key.rawValue)
    }
    
    public func array(forKey key: UserDefaultsKeys) -> [Any]? {
        return userDefaults.array(forKey: key.rawValue)
    }
    
    public func dictionary(forKey key: UserDefaultsKeys) -> [String: Any]? {
        return userDefaults.dictionary(forKey: key.rawValue)
    }
    
    // MARK: - Utilities
    
    public func remove(forKey key: UserDefaultsKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
    public func exists(key: UserDefaultsKeys) -> Bool {
        return userDefaults.object(forKey: key.rawValue) != nil
    }
    
    public func removeAll() {
        let keys = getAllKeys()
        keys.forEach { userDefaults.removeObject(forKey: $0) }
    }
    
    // MARK: - Private
    
    private func getAllKeys() -> [String] {
        return Array(userDefaults.dictionaryRepresentation().keys)
    }
}
