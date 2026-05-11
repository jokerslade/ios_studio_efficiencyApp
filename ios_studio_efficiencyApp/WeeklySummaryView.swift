import SwiftUI

struct WeeklySummaryView: View {
    @Environment(\.dismiss) private var dismiss
    
    let categories: [TaskCategoryProgress] = [
        TaskCategoryProgress(title: "Essay", iconName: "pencil", timeSpent: "17 h 43 min", totalTime: "14h", completedTasks: 6, totalTasks: 6, gradientStart: .blue, gradientEnd: .cyan),
        TaskCategoryProgress(title: "Interview Video & Report", iconName: "square.and.pencil", timeSpent: "15 h 07 min", totalTime: "12h", completedTasks: 4, totalTasks: 4, gradientStart: .orangeAccent, gradientEnd: .yellow),
        TaskCategoryProgress(title: "Case Study", iconName: "book", timeSpent: "15 h 02 min", totalTime: "10h", completedTasks: 6, totalTasks: 6, gradientStart: .playPauseGreen, gradientEnd: .green),
        TaskCategoryProgress(title: "Programming", iconName: "desktopcomputer", timeSpent: "1h", totalTime: "8h", completedTasks: 0, totalTasks: 2, gradientStart: .gray, gradientEnd: .gray)
    ]
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(colors: [Color.bgTop, Color.bgBottom],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Nav Bar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 5)
                    }
                    
                    Text("Weekly summary")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                // Summary Card
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tasks\nCompleted:")
                            .font(.system(size: 16, weight: .bold))
                        Text("80%")
                            .font(.system(size: 24, weight: .bold))
                        
                        Text("Points:\n2300 Pt")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.top, 4)
                        
                        HStack(spacing: 12) {
                            BadgeCountView(type: .gold, count: 2)
                            BadgeCountView(type: .silver, count: 1)
                            BadgeCountView(type: .bronze, count: 1)
                        }
                    }
                    
                    Spacer()
                    
                    // Pie Chart Placeholder
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                        
                        Circle()
                            .trim(from: 0, to: 0.8)
                            .stroke(
                                LinearGradient(colors: [.primaryBlue, .playPauseGreen, .orangeAccent], startPoint: .top, endPoint: .bottom),
                                style: StrokeStyle(lineWidth: 15, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("Essay")
                                .font(.system(size: 16, weight: .semibold))
                            Text("20%")
                                .font(.system(size: 24, weight: .bold))
                        }
                    }
                    .frame(width: 120, height: 120)
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                .padding(.horizontal, 24)
                
                // Tasks Category List
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tasks Category")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.horizontal, 24)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(categories) { category in
                                CategoryProgressRow(category: category)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct BadgeCountView: View {
    var type: BadgeType
    var count: Int
    
    var color: Color {
        switch type {
        case .gold: return .yellow
        case .silver: return .gray
        case .bronze: return .orangeAccent
        case .none: return .clear
        }
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "medal.fill")
                .foregroundColor(color)
                .font(.system(size: 16))
            Text("\(count)")
                .font(.system(size: 14, weight: .bold))
        }
    }
}

struct CategoryProgressRow: View {
    var category: TaskCategoryProgress
    
    var progress: Double {
        if category.totalTasks == 0 { return 0 }
        return Double(category.completedTasks) / Double(category.totalTasks)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(category.gradientStart.opacity(0.1))
                    .frame(width: 50, height: 50)
                Image(systemName: category.iconName)
                    .foregroundColor(category.gradientStart)
                    .font(.system(size: 24))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(category.title)
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    if category.completedTasks == category.totalTasks {
                        Text("Completed")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    } else {
                        Text("Not Finished")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                HStack {
                    HStack(spacing: 0) {
                        Text("\(category.timeSpent) / ")
                            .font(.system(size: 12, weight: .bold))
                        Text(category.totalTime)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("\(category.completedTasks) / \(category.totalTasks)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 6)
                        
                        Capsule()
                            .fill(LinearGradient(colors: [category.gradientStart, category.gradientEnd], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * CGFloat(progress), height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    WeeklySummaryView()
}
