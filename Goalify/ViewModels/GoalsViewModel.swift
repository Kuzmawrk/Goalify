import Foundation
import SwiftUI

@MainActor
class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var showSuccessNotification = false
    
    private let goalsKey = "savedGoals"
    
    init() {
        loadGoals()
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        saveGoals()
        showSuccessNotification = true
        
        // Auto-hide notification after 2 seconds
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            showSuccessNotification = false
        }
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            saveGoals()
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
        saveGoals()
    }
    
    func toggleTaskCompletion(goalId: UUID, taskId: UUID) {
        if let goalIndex = goals.firstIndex(where: { $0.id == goalId }),
           let taskIndex = goals[goalIndex].tasks.firstIndex(where: { $0.id == taskId }) {
            goals[goalIndex].tasks[taskIndex].isCompleted.toggle()
            
            // Update progress and completion status
            let completedTasks = goals[goalIndex].tasks.filter { $0.isCompleted }.count
            let totalTasks = goals[goalIndex].tasks.count
            
            goals[goalIndex].progress = totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0.0
            goals[goalIndex].isCompleted = totalTasks > 0 && completedTasks == totalTasks
            
            saveGoals()
        }
    }
    
    private func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: goalsKey)
        }
    }
    
    private func loadGoals() {
        if let data = UserDefaults.standard.data(forKey: goalsKey),
           let decoded = try? JSONDecoder().decode([Goal].self, from: data) {
            goals = decoded
        }
    }
}