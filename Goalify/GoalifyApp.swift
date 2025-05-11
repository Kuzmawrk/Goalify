import SwiftUI
import Extension

@main
struct GoalifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                ContentView()
            }
        }
    }
}