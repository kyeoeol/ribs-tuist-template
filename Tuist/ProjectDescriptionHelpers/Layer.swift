import Foundation
import ProjectDescription

public enum Layer: String, CaseIterable {
    case application = "Application"
    case core = "Core"
    case feature = "Feature"
    case shared = "Shared"
}

extension Layer {
    public var path: String { "Projects/\(rawValue)" }
    
    public static var allLayersPath: [Path] { Self.allCases.map { "\($0.path)/**" } }
    
    public func bundleId(for name: String) -> String {
        return "com.\(rawValue.lowercased()).\(name.lowercased())"
    }
}
