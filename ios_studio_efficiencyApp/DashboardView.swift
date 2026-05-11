import SwiftUI

struct DashboardView: View {
    @State private var tasks: [TaskModel] = [
        TaskModel(
            title: "Task 2", 
            subtitle: "Main Report", 
            durationString: "0:29", 
            points: 50, 
            state: .inProgress,
            subtasks: [
                SubtaskModel(title: "Draft Outline", subtitle: "TODAY", durationString: "", points: 10, isCompleted: true),
                SubtaskModel(title: "Research Sources", subtitle: "TODAY", durationString: "", points: 15, isCompleted: true),
                SubtaskModel(title: "Write Introduction", subtitle: "UPCOMING", durationString: "", points: 25, isCompleted: false)
            ]
        ),
        TaskModel(
            title: "IDS Reflection",
            subtitle: "Report 6/6",
            durationString: "",
            points: 300,
            state: .completed,
            subtasks: [
                SubtaskModel(title: "Planning", subtitle: "COMPLETED MARCH 20", durationString: "", points: 50, isCompleted: true),
                SubtaskModel(title: "Research", subtitle: "COMPLETED MARCH 20", durationString: "", points: 50, isCompleted: true),
                SubtaskModel(title: "Drafting", subtitle: "COMPLETED MARCH 21", durationString: "", points: 50, isCompleted: true),
                SubtaskModel(title: "Review", subtitle: "COMPLETED MARCH 21", durationString: "", points: 50, isCompleted: true),
                SubtaskModel(title: "Edits", subtitle: "COMPLETED MARCH 22", durationString: "", points: 50, isCompleted: true),
                SubtaskModel(title: "Final Polish", subtitle: "COMPLETED MARCH 22", durationString: "", points: 50, isCompleted: true)
            ],
            isExpanded: true,
            progress: 1.0
        )
    ]
    
    @State private var showingCreateTask = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.bgTop, .bgBottom], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("Dashboard")
                            .font(.system(size: 32, weight: .bold))
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "calendar")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                                .padding(12)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            // In Progress Section
                            ForEach($tasks) { $task in
                                if task.state == .inProgress {
                                    InProgressCard(task: $task)
                                }
                            }
                            
                            // Add Button
                            Button(action: {
                                showingCreateTask = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.primaryBlue)
                                    .clipShape(Capsule())
                            }
                            .padding(.horizontal, 40)
                            
                            // Completed Tasks
                            HStack {
                                Text("Completed Tasks")
                                    .font(.system(size: 20, weight: .bold))
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            
                            ForEach($tasks) { $task in
                                if task.state == .completed {
                                    CompletedTaskCard(task: $task)
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationDestination(isPresented: $showingCreateTask) {
                CreateTaskView(tasks: $tasks)
            }
        }
    }
}

struct InProgressCard: View {
    @Binding var task: TaskModel
    @State private var isPlaying = false
    @State private var timeRemaining: Int = 29
    @State private var totalTime: Int = 60
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Card
            ZStack(alignment: .trailing) {
                ZStack(alignment: .leading) {
                    // Bottom Layer (White)
                    InProgressCardContent(task: task, textColor: .black, subtextColor: .gray)
                        .background(Color.white)
                    
                    // Top Layer (Blue, masked)
                    InProgressCardContent(task: task, textColor: .white, subtextColor: .white.opacity(0.8))
                        .background(
                            LinearGradient(colors: [.inProgressStart, .inProgressEnd], startPoint: .leading, endPoint: .trailing)
                                .hueRotation(.degrees(Double(max(0, totalTime - timeRemaining)) * 1.5))
                        )
                        .mask(
                            GeometryReader { geo in
                                Rectangle()
                                    .frame(width: max(0, geo.size.width * CGFloat(timeRemaining) / CGFloat(max(1, totalTime))))
                            }
                        )
                }
                
                // Play/Pause Button
                Button(action: {
                    isPlaying.toggle()
                }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.playPauseGreen)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding(.trailing, 20)
            }
            .cornerRadius(24)
            .padding(.horizontal)
            .shadow(color: .inProgressStart.opacity(0.3), radius: 10, x: 0, y: 5)
            .zIndex(1)
            .onTapGesture {
                withAnimation(.spring()) {
                    task.isExpanded.toggle()
                }
            }
            .onReceive(timer) { _ in
                if isPlaying && timeRemaining > 0 {
                    timeRemaining -= 1
                    task.durationString = String(format: "%d:%02d", timeRemaining / 60, timeRemaining % 60)
                } else if timeRemaining == 0 {
                    isPlaying = false
                }
            }
            .onAppear {
                let parts = task.durationString.split(separator: ":")
                if parts.count == 2, let m = Int(parts[0]), let s = Int(parts[1]) {
                    let total = m * 60 + s
                    if total > 0 {
                        timeRemaining = total
                        totalTime = total > 60 ? total : 60
                    }
                }
            }
            
            // Subtasks
            if task.isExpanded {
                VStack(spacing: 12) {
                    ForEach(task.subtasks) { subtask in
                        HStack {
                            if subtask.isCompleted {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.playPauseGreen)
                                    .padding(6)
                                    .background(Color.playPauseGreen.opacity(0.1))
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                                    .frame(width: 24, height: 24)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(subtask.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                Text(subtask.subtitle)
                                    .font(.system(size: 10))
                                    .foregroundColor(.textSecondary)
                            }
                            Spacer()
                            Text("+\(subtask.points)Pt")
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, -10)
                .padding(.bottom, 10)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(0)
            }
        }
    }
}

struct CompletedTaskCard: View {
    @Binding var task: TaskModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Card
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.playPauseGreen)
                    Text(task.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.textPrimary)
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            task.isExpanded.toggle()
                        }
                    }) {
                        Image(systemName: task.isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                
                HStack {
                    Text(task.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text("+\(task.points) Pt")
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Text("OVERALL PROGRESS")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text("\(Int(task.progress * 100))%")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primaryBlue)
                    }
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 8)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.primaryBlue)
                                .frame(width: geometry.size.width * task.progress, height: 8)
                        }
                    }
                    .frame(height: 8)
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
            .zIndex(1)
            
            // Subtasks
            if task.isExpanded {
                VStack(spacing: 12) {
                    ForEach(task.subtasks) { subtask in
                        HStack {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.playPauseGreen)
                                .padding(6)
                                .background(Color.playPauseGreen.opacity(0.1))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(subtask.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                Text(subtask.subtitle)
                                    .font(.system(size: 10))
                                    .foregroundColor(.textSecondary)
                            }
                            Spacer()
                            Text("+\(subtask.points)Pt")
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, -10)
                .padding(.bottom, 10)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(0)
            }
        }
    }
}

#Preview {
    DashboardView()
}

struct InProgressCardContent: View {
    var task: TaskModel
    var textColor: Color
    var subtextColor: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("In Progress")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.teal)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                
                Text(task.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(textColor)
                
                Text(task.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(subtextColor)
            }
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text(task.durationString)
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(textColor)
                Text("\(task.points)Pt")
                    .font(.system(size: 14))
                    .foregroundColor(subtextColor)
            }
            
            Spacer().frame(width: 50) // Space for the Play/Pause button
        }
        .padding(20)
    }
}
