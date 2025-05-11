import SwiftUI

struct GoalsListView: View {
    @EnvironmentObject private var viewModel: GoalsViewModel
    
    var body: some View {
        Group {
        ScrollView {
            LazyVStack(spacing: 16) {
                   NavigationLink(value: goal) {
                    GoalCardView(goal: goal)
                }estination: GoalDetailView(goal: goal)) {
                        GoalCardView(goal: goal)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("My Goals")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(value: "addGoal") {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
            }
        }
        .overlay {
            if viewModel.goals.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "target")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("No Goals Yet")
                        .font(.title2)
                    Text("Tap the + tab to add your first goal")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .overlay(alignment: .top) {
            if viewModel.showSuccessNotification {
                NotificationBanner(text: "Goal added successfully!")
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3), value: viewModel.showSuccessNotification)
        }
        .navigationDestination(for: Goal.self) { goal in
            GoalDetailView(goal: goal)
        }
        .navigationDestination(for: String.self) { value in
            if value == "addGoal" {
                AddGoalView()
            }
        }
    }
}

struct GoalCardView: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                Spacer()
                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(goal.isCompleted ? .green : .gray)
            }
            
            Text(goal.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            ProgressView(value: goal.progress)
                .tint(.green)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.secondary)
                Text(goal.deadline, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(Int(goal.progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(.systemBackground),
                            Color(.systemBackground).opacity(0.95)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
        }
        .cornerRadius(12)
        .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct NotificationBanner: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.subheadline.bold())
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(8)
            .shadow(radius: 2)
            .padding(.top)
    }
}