import SwiftUI

struct DashboardView: View {
    @State private var tasks: [TaskModel] = [
        TaskModel(title: "Task 2", subtitle: "Main Report", durationString: "0:29", points: 50, state: .inProgress),
        TaskModel(
            title: "IDS Reflection",
            subtitle: "Report 6/6",
            durationString: "",
            points: 300,
            state: .completed,
            subtasks: [
                SubtaskModel(title: "Planning", subtitle: "COMPLETED MARCH 20", durationString: "", points: 50, isCompleted: true),
                SubtaskModel(title: "Research", subtitle: "COMPLETED MARCH 20", durationString: "", points: 50, isCompleted: true)
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
                            ForEach(tasks.filter { $0.state == .inProgress }) { task in
                                InProgressCard(task: task)
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
    var task: TaskModel
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
                
                Text(task.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text(task.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text(task.durationString)
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(.white)
                Text("\(task.points)Pt")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Button(action: {}) {
                Image(systemName: "pause.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.playPauseGreen)
                    .clipShape(Circle())
            }
            .padding(.leading, 10)
        }
        .padding(20)
        .background(
            LinearGradient(colors: [.inProgressStart, .inProgressEnd], startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(24)
        .padding(.horizontal)
        .shadow(color: .inProgressStart.opacity(0.3), radius: 10, x: 0, y: 5)
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
