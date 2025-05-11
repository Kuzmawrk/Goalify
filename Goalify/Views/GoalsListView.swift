import SwiftUI

struct GoalsListView: View {
    @EnvironmentObject private var viewModel: GoalsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.goals) { goal in
                    NavigationLink(value: goal) {
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
    @EnvironmentObject private var viewModel: GoalsViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    private var progressColor: Color {
        if goal.isCompleted {
            return .green
        }
        switch goal.progress {
        case 0..<0.33: return .red
        case 0.33..<0.66: return .orange
        default: return .green
        }
    }
    
    private var daysRemaining: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: goal.deadline).day ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                    
                    Text(goal.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(goal.isCompleted ? .green : .gray)
            }
            
            if !goal.tasks.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(goal.tasks) { task in
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                viewModel.toggleTaskCompletion(goalId: goal.id, taskId: task.id)
                            }
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                        }) {
                            HStack {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .green : .gray)
                                    .font(.system(size: 16))
                                Text(task.title)
                                    .font(.subheadline)
                                    .strikethrough(task.isCompleted)
                                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                                Spacer()
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .padding(.vertical, 4)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.secondary.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(progressColor)
                            .frame(width: geometry.size.width * goal.progress, height: 8)
                    }
                }
                .frame(height: 8)
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .foregroundColor(.secondary)
                            .font(.system(size: 14))
                        Text("\(daysRemaining) days left")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("\(Int(goal.progress * 100))%")
                        .font(.caption.bold())
                        .foregroundColor(progressColor)
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            colorScheme == .dark ? 
                                Color(.systemGray6) : Color(.systemBackground),
                            colorScheme == .dark ? 
                                Color(.systemGray6).opacity(0.8) : Color(.systemBackground).opacity(0.9)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(progressColor.opacity(0.2), lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(
            color: progressColor.opacity(colorScheme == .dark ? 0.1 : 0.05),
            radius: 8,
            x: 0,
            y: 4
        )
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