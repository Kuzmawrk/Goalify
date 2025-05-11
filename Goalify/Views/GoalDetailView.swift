import SwiftUI

struct GoalDetailView: View {
    @EnvironmentObject private var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    
    let goal: Goal
    @State private var isEditing = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
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
                        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true)
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
                EditGoalView(goal: goal)
            }
        }
        .alert("Delete Goal", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteGoal(goal)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this goal? This action cannot be undone.")
        }
    }
}

struct EditGoalView: View {
    @EnvironmentObject private var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    
    let goal: Goal
    @State private var title: String
    @State private var description: String
    @State private var deadline: Date
    @State private var tasks: [Goal.Task]
    @State private var newTask = ""
    
    init(goal: Goal) {
        self.goal = goal
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
                    let updatedGoal = Goal(
                        id: goal.id,
                        title: title,
                        description: description,
                        deadline: deadline,
                        progress: goal.progress,
                        tasks: tasks,
                        isCompleted: goal.isCompleted
                    )
                    viewModel.updateGoal(updatedGoal)
                    dismiss()
                }
                .disabled(title.isEmpty)
            }
        }
    }
}