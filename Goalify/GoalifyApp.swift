import SwiftUI
import Extension

@main
struct GoalifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                if !hasCompletedOnboarding {
                    OnboardingView(isOnboardingComplete: $hasCompletedOnboarding)
                } else {
                    MainTabView()
                }
            }
        }
    }
}