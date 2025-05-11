import SwiftUI

struct MainTabView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var goalsViewModel = GoalsViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                GoalsListView()
            }
            .tabItem {
                Label("Goals", systemImage: "target")
            }
            .tag(0)
            
            NavigationStack {
                AddGoalView()
            }
            .tabItem {
                Label("Add Goal", systemImage: "plus.circle.fill")
            }
            .tag(1)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(2)
        }
        .environmentObject(goalsViewModel)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .environment(\.tabSelection, selectedTab)
    }
}