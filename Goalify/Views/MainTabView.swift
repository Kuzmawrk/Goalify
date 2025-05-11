import SwiftUI

struct MainTabView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var goalsViewModel = GoalsViewModel()
    
    var body: some View {
        TabView {
            NavigationStack {
                GoalsListView()
            }
            .tabItem {
                Label("Goals", systemImage: "target")
            }
            
            NavigationStack {
                AddGoalView()
            }
            .tabItem {
                Label("Add Goal", systemImage: "plus.circle.fill")
            }
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .environmentObject(goalsViewModel)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}