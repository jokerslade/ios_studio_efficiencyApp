import Foundation
import SwiftUI

enum TaskState {
    case inProgress
    case pending
    case completed
}

struct TaskModel: Identifiable {
    let id = UUID()
    var title: String
    var subtitle: String
    var durationString: String
    var points: Int
    var state: TaskState
    var subtasks: [SubtaskModel] = []
    var isExpanded: Bool = false
    var progress: Double = 0.0 // 0.0 to 1.0
}

struct SubtaskModel: Identifiable {
    let id = UUID()
    var title: String
    var subtitle: String
    var durationString: String
    var points: Int
    var isCompleted: Bool = false
    var dateString: String?
}

struct ChatMessage: Identifiable {
    let id = UUID()
    var text: String
    var isUser: Bool
    var isLoading: Bool = false
}

// MARK: - Rewards System Models

enum BadgeType {
    case gold, silver, bronze, none
}

struct PointTransaction: Identifiable {
    let id = UUID()
    var title: String
    var points: Int
    var type: TransactionType
    
    enum TransactionType {
        case essay, time, interview, research
        
        var color: Color {
            switch self {
            case .essay, .time: return .primaryBlue
            case .interview: return .orangeAccent
            case .research: return .playPauseGreen
            }
        }
    }
}

struct TaskCategoryProgress: Identifiable {
    let id = UUID()
    var title: String
    var iconName: String
    var timeSpent: String
    var totalTime: String
    var completedTasks: Int
    var totalTasks: Int
    var gradientStart: Color
    var gradientEnd: Color
}

struct ShopItem: Identifiable {
    let id = UUID()
    var title: String
    var iconName: String
    var points: Int
    var isPurchased: Bool = false
    var quantity: String?
}

struct UserRanking: Identifiable {
    let id = UUID()
    var rank: Int
    var name: String
    var avatarName: String
    var isCurrentUser: Bool = false
    var goldBadges: Int
    var silverBadges: Int
    var bronzeBadges: Int
    var points: Int
    var upvotes: Int
    var isUpvoted: Bool = false
    var trend: Int // positive = up, negative = down, 0 = no change
}
