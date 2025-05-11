import Foundation

struct Goal: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var title: String
    var description: String
    var deadline: Date
    var progress: Double
    var tasks: [Task]
    var isCompleted: Bool
    
    struct Task: Identifiable, Codable, Equatable, Hashable {
        var id: UUID
        var title: String
        var isCompleted: Bool
        
        init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
            self.id = id
            self.title = title
            self.isCompleted = isCompleted
        }
    }
    
    init(id: UUID = UUID(), title: String, description: String, deadline: Date, progress: Double = 0.0, tasks: [Task] = [], isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.deadline = deadline
        self.progress = progress
        self.tasks = tasks
        self.isCompleted = isCompleted
    }
}