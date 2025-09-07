import ProjectDescription

extension TargetDependency {
    static func module(layer: Layer, _ moduleName: String) -> TargetDependency {
        let path = "\(layer.path)/\(moduleName)"
        return .project(target: moduleName, path: .relativeToRoot(path))
    }
}

// MARK: - External Dependencies (Swift Package Manager)

extension TargetDependency {
    // Architecture
    public static let RIBs: TargetDependency = .external(name: "RIBs")
    // Reactive
    public static let RxSwift: TargetDependency = .external(name: "RxSwift")
}

// MARK: - System Dependencies

extension TargetDependency {
    //...
}

// MARK: - Internal Project Dependencies

extension TargetDependency {
    public enum Core {
        public static let Networking: TargetDependency = .module(layer: .core, "Networking")
        public static let Services: TargetDependency = .module(layer: .core, "Services")
    }
    
    public enum Feature {
        public static let Splash: TargetDependency = .module(layer: .feature, "Splash")
    }
    
    public enum Shared {
        public static let Entities: TargetDependency = .module(layer: .shared, "Entities")
        public static let Logging: TargetDependency = .module(layer: .shared, "Logging")
    }
}
