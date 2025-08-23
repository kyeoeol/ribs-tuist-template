import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        let welcomeMessages = [
           "🚀 App launched successfully! Happy coding! 🎉✨",
           "🎯 Ready to code magic! Happy coding! 🪄✨",
           "☕️ Fresh start, fresh code! Happy coding! 🚀💻",
           "🌟 Another day, another awesome feature! Happy coding! 🎨🔥",
           "💡 Time to turn ideas into reality! Happy coding! ⚡️🎊",
           "🔧 Let's build something incredible today! Happy coding! 🏗️✨"
        ]
        print(welcomeMessages.randomElement() ?? "🚀 Happy coding! 🎉")
        #endif
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
