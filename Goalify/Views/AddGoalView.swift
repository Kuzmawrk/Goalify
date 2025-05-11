import SwiftUI

struct AddGoalView: View {
    @EnvironmentObject private var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.tabSelection) private var tabSelection: Int
    
    @State private var title = ""
    @State private var description = ""
    @State private var deadline = Date()
    @State private var tasks: [Goal.Task] = []
    @State private var newTask = ""
    
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
        .navigationTitle("Add Goal")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let goal = Goal(
                        title: title,
                        description: description,
                        deadline: deadline,
                        tasks: tasks
                    )
                    viewModel.addGoal(goal)
                    
                    // Reset form
                    title = ""
                    description = ""
                    deadline = Date()
                    tasks = []
                    newTask = ""
                    
                    // Switch to first tab
                    tabSelection = 0
                }
                .disabled(title.isEmpty)
            }
        }
    }
}