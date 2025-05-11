import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject private var viewModel: GoalsViewModel
    
    private var totalGoals: Int {
        viewModel.goals.count
    }
    
    private var completedGoals: Int {
        viewModel.goals.filter { $0.isCompleted }.count
    }
    
    private var inProgressGoals: Int {
        viewModel.goals.filter { !$0.isCompleted }.count
    }
    
    private var averageProgress: Int {
        let goals = viewModel.goals
        guard !goals.isEmpty else { return 0 }
        
        let totalProgress = goals.reduce(0.0) { $0 + $1.progress }
        return Int((totalProgress / Double(goals.count)) * 100)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Total Goals Card
                StatCard(
                    title: "Total Goals",
                    value: "\(totalGoals)",
                    icon: "target"
                )
                
                // Completed Goals Card
                StatCard(
                    title: "Completed Goals",
                    value: "\(completedGoals)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                // In Progress Goals Card
                StatCard(
                    title: "In Progress",
                    value: "\(inProgressGoals)",
                    icon: "hourglass",
                    color: .orange
                )
                
                // Average Progress Card
                StatCard(
                    title: "Average Progress",
                    value: "\(averageProgress)%",
                    icon: "chart.bar.fill",
                    color: .blue
                )
            }
            .padding()
        }
        .navigationTitle("Statistics")
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var color: Color = .primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
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