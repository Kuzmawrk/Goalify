import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    
    let onboardingItems = [
        OnboardingItem(
            title: "Track Your Goals",
            description: "Create and organize your personal goals with deadlines and progress tracking",
            imageName: "chart.bar.fill"
        ),
        OnboardingItem(
            title: "Break Down Tasks",
            description: "Split your goals into manageable tasks and track completion",
            imageName: "checklist"
        ),
        OnboardingItem(
            title: "Stay Organized",
            description: "Monitor your progress and celebrate achievements as you reach your goals",
            imageName: "star.fill"
        )
    ]
    
    var isLastPage: Bool {
        currentPage == onboardingItems.count - 1
    }
    
    func nextPage() {
        if currentPage < onboardingItems.count - 1 {
            currentPage += 1
        }
    }
    
    func markOnboardingComplete() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
    
    static func hasCompletedOnboarding() -> Bool {
        UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
}