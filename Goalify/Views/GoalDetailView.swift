import SwiftUI

struct GoalDetailView: View {
    @EnvironmentObject private var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    
    let goalId: UUID
    @State private var isEditing = false
    @State private var showingDeleteAlert = false
    
    private var goal: Goal? {
        viewModel.goals.first { $0.id == goalId }
    }
    
    var body: some View {
        Group {
            if let goal = goal {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text(goal.title)
                                .font(.title.bold())
                            Text(goal.description)
                                .foregroundColor(.secondary)
                        }
                        
                        // Progress
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Progress")
                                .font(.headline)
                            ProgressView(value: goal.progress)
                                .tint(.green)
                            Text("\(Int(goal.progress * 100))% Complete")
                                .foregroundColor(.secondary)
                        }
                        
                        // Deadline
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Deadline")
                                .font(.headline)
                            Text(goal.deadline, style: .date)
                                .foregroundColor(.secondary)
                        }
                        
                        // Tasks
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tasks")
                                .font(.headline)
                            
                            ForEach(goal.tasks) { task in
                                HStack {
                                    Button {
                                        viewModel.toggleTaskCompletion(goalId: goal.id, taskId: task.id)
                                    } label: {
                                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(task.isCompleted ? .green : .gray)
                                    }
                                    
                                    Text(task.title)
                                        .strikethrough(task.isCompleted)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.toggleTaskCompletion(goalId: goal.id, taskId: task.id)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button {
                                isEditing = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                showingDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                let items = [goal.title, goal.description]
                                let av = UIActivityViewController(activityItems: items, applicationActivities: nil)
                                
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let window = windowScene.windows.first,
                                   let rootVC = window.rootViewController {
                                    rootVC.present(av, animated: true)
                                }
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
                .sheet(isPresented: $isEditing) {
                    NavigationStack {
                        EditGoalView(goal: goal, goalId: goalId)
                    }
                }
                .alert("Delete Goal", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        withAnimation {
                            viewModel.deleteGoal(goal)
                            dismiss()
                        }
                    }
                } message: {
                    Text("Are you sure you want to delete this goal? This action cannot be undone.")
                }
            } else {
                // Goal not found view
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    Text("Goal Not Found")
                        .font(.title2)
                    Text("This goal may have been deleted")
                        .foregroundColor(.secondary)
                    Button("Go Back") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .padding(.top)
                }
                .padding()
            }
        }
    }
}

struct EditGoalView: View {
    @EnvironmentObject private var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    
    let goal: Goal
    let goalId: UUID
    @State private var title: String
    @State private var description: String
    @State private var deadline: Date
    @State private var tasks: [Goal.Task]
    @State private var newTask = ""
    
    init(goal: Goal, goalId: UUID) {
        self.goal = goal
        self.goalId = goalId
        _title = State(initialValue: goal.title)
        _description = State(initialValue: goal.description)
        _deadline = State(initialValue: goal.deadline)
        _tasks = State(initialValue: goal.tasks)
    }
    
    var body: some View {
        Form {
            Section("Goal Details") {
                TextField("Title", text: $title)
                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(3...6)
                DatePicker("Deadline", selection: $deadline, in: Date()...)
            }
            
            Section("Tasks") {
                ForEach(tasks) { task in
                    Text(task.title)
                }
                .onDelete { indexSet in
                    tasks.remove(atOffsets: indexSet)
                }
                
                HStack {
                    TextField("Add task", text: $newTask)
                    Button("Add") {
                        if !newTask.isEmpty {
                            tasks.append(Goal.Task(title: newTask))
                            newTask = ""
                        }
                    }
                    .disabled(newTask.isEmpty)
                }
            }
        }
        .navigationTitle("Edit Goal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    // Calculate new progress based on completed tasks
                    let completedTasks = tasks.filter { $0.isCompleted }.count
                    let newProgress = tasks.isEmpty ? 0.0 : Double(completedTasks) / Double(tasks.count)
                    
                    let updatedGoal = Goal(
                        id: goal.id,
                        title: title,
                        description: description,
                        deadline: deadline,
                        progress: newProgress,
                        tasks: tasks,
                        isCompleted: !tasks.isEmpty && completedTasks == tasks.count
                    )
                    viewModel.updateGoal(updatedGoal)
                    dismiss()
                }
                .disabled(title.isEmpty)
            }
        }
    }
}