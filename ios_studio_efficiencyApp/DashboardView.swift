import SwiftUI
import Combine

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
    @State private var showingCongratsPopup = false
    @State private var recentlyEarnedPoints = 0
    
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
                                    SwipeableCard(
                                        onFinish: {
                                            withAnimation(.spring()) {
                                                task.state = .completed
                                                task.progress = 1.0
                                                for i in 0..<task.subtasks.count {
                                                    task.subtasks[i].isCompleted = true
                                                }
                                            }
                                            recentlyEarnedPoints = task.points
                                            withAnimation { showingCongratsPopup = true }
                                        },
                                        onDelete: {
                                            withAnimation(.spring()) {
                                                if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                                    tasks.remove(at: index)
                                                }
                                            }
                                        }
                                    ) {
                                        InProgressCard(task: $task) {
                                            withAnimation(.spring()) {
                                                task.state = .completed
                                                task.progress = 1.0
                                                for i in 0..<task.subtasks.count {
                                                    task.subtasks[i].isCompleted = true
                                                }
                                            }
                                            recentlyEarnedPoints = task.points
                                            withAnimation { showingCongratsPopup = true }
                                        }
                                    }
                                }
                            }
                            
                            // Pending Tasks Section
                            ForEach($tasks) { $task in
                                if task.state == .pending {
                                    SwipeableCard(
                                        onFinish: {
                                            withAnimation(.spring()) {
                                                task.state = .completed
                                                task.progress = 1.0
                                                for i in 0..<task.subtasks.count {
                                                    task.subtasks[i].isCompleted = true
                                                }
                                            }
                                            recentlyEarnedPoints = task.points
                                            withAnimation { showingCongratsPopup = true }
                                        },
                                        onDelete: {
                                            withAnimation(.spring()) {
                                                if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                                    tasks.remove(at: index)
                                                }
                                            }
                                        }
                                    ) {
                                        PendingTaskCard(task: $task)
                                    }
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
                                    SwipeableCard(
                                        primaryIcon: "arrow.counterclockwise",
                                        onFinish: {
                                            withAnimation(.spring()) {
                                                task.state = .pending
                                                task.progress = 0.0
                                                for i in 0..<task.subtasks.count {
                                                    task.subtasks[i].isCompleted = false
                                                }
                                            }
                                        },
                                        onDelete: {
                                            withAnimation(.spring()) {
                                                if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                                    tasks.remove(at: index)
                                                }
                                            }
                                        }
                                    ) {
                                        CompletedTaskCard(task: $task)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
                
                // Popup Overlay
                if showingCongratsPopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { showingCongratsPopup = false }
                        }
                    
                    CongratsPopupView(points: recentlyEarnedPoints) {
                        withAnimation { showingCongratsPopup = false }
                    }
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(2)
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
    var onComplete: (() -> Void)? = nil
    @State private var isPlaying = false
    @State private var timeRemainingSeconds: Int = 29 * 60
    @State private var totalTimeSeconds: Int = 29 * 60
    
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
                                .hueRotation(.degrees(Double(max(0, totalTimeSeconds - timeRemainingSeconds)) * 0.025))
                        )
                        .mask(
                            GeometryReader { geo in
                                Rectangle()
                                    .frame(width: max(0, geo.size.width * CGFloat(timeRemainingSeconds) / CGFloat(max(1, totalTimeSeconds))))
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
                if isPlaying && timeRemainingSeconds > 0 {
                    timeRemainingSeconds -= 1
                    task.durationString = formatDuration(timeRemainingSeconds)
                    if timeRemainingSeconds == 0 {
                        isPlaying = false
                        onComplete?()
                    }
                } else if timeRemainingSeconds == 0 {
                    isPlaying = false
                }
            }
            .onAppear {
                let total = seconds(from: task.durationString)
                if total > 0 {
                    timeRemainingSeconds = total
                    totalTimeSeconds = total
                    task.durationString = formatDuration(total)
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
    
    private func seconds(from duration: String) -> Int {
        let parts = duration.split(separator: ":")
        if parts.count == 2, let hours = Int(parts[0]), let minutes = Int(parts[1]) {
            return ((hours * 60) + minutes) * 60
        }
        
        let digits = duration.filter(\.isNumber)
        if let minutes = Int(digits) {
            return minutes * 60
        }
        
        return 0
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let minutesRemaining = Int(ceil(Double(seconds) / 60.0))
        return String(format: "%d:%02d", minutesRemaining / 60, minutesRemaining % 60)
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

struct PendingTaskCard: View {
    @Binding var task: TaskModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Badges
            HStack(spacing: 8) {
                Text("23 March 2026")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.primaryBlue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.primaryBlue.opacity(0.1))
                    .cornerRadius(4)
                
                Text("\(task.points) Pt")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.primaryBlue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.primaryBlue.opacity(0.1))
                    .cornerRadius(4)
                
                Spacer()
            }
            
            // Middle section
            HStack {
                Text(task.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text(task.durationString)
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(.textPrimary)
                
                Button(action: {
                    withAnimation(.spring()) {
                        task.state = .inProgress
                    }
                }) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.black.opacity(0.7))
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Circle())
                }
                .padding(.leading, 8)
            }
            
            // Bottom section
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.brown)
                        .frame(width: 8, height: 8)
                    Text(task.subtitle.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.textSecondary)
                }
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.primaryBlue)
                        .frame(width: 8, height: 8)
                    Text("SUB-TASK:\(task.subtasks.count)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.textSecondary)
                }
                Spacer()
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct SwipeableCard<Content: View>: View {
    var primaryIcon: String = "checkmark.circle"
    var onFinish: () -> Void
    var onDelete: () -> Void
    @ViewBuilder var content: Content
    
    @State private var offset: CGFloat = 0
    @State private var isSwiped: Bool = false
    
    let buttonWidth: CGFloat = 50
    let spacing: CGFloat = 12
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Action Buttons
            HStack(spacing: spacing) {
                Button(action: {
                    withAnimation(.spring()) { offset = 0; isSwiped = false }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onFinish()
                    }
                }) {
                    Image(systemName: primaryIcon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: buttonWidth, height: buttonWidth)
                        .background(Color.primaryBlue)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                
                Button(action: {
                    withAnimation(.spring()) { offset = 0; isSwiped = false }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onDelete()
                    }
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: buttonWidth, height: buttonWidth)
                        .background(Color(red: 1.0, green: 0.4, blue: 0.4))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
            }
            .padding(.trailing, 20)
            .opacity(offset < 0 ? 1 : 0)
            
            // Content Card
            content
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let maxOffset = -((buttonWidth * 2) + spacing + 10)
                            if value.translation.width < 0 {
                                // Swiping left
                                if isSwiped {
                                    offset = maxOffset + value.translation.width * 0.2
                                } else {
                                    offset = value.translation.width
                                }
                            } else {
                                // Swiping right
                                if isSwiped {
                                    offset = maxOffset + value.translation.width
                                    if offset > 0 { offset = 0 }
                                } else {
                                    offset = value.translation.width * 0.2
                                }
                            }
                        }
                        .onEnded { value in
                            let maxOffset = -((buttonWidth * 2) + spacing + 10)
                            withAnimation(.spring()) {
                                if value.translation.width < -50 {
                                    offset = maxOffset
                                    isSwiped = true
                                } else if isSwiped && value.translation.width > 30 {
                                    offset = 0
                                    isSwiped = false
                                } else {
                                    offset = isSwiped ? maxOffset : 0
                                }
                            }
                        }
                )
        }
    }
}

struct CongratsPopupView: View {
    var points: Int
    var onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Medal Graphic
            ZStack {
                Image(systemName: "seal.fill")
                    .font(.system(size: 100))
                    .foregroundColor(Color.orangeAccent)
                Image(systemName: "star.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            .padding(.top, 40)
            
            // Text
            VStack(spacing: 8) {
                Text("GREAT JOB !!!")
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundColor(Color(hex: "5B21B6")) // Deep purple
                
                Text("You've Earned\n\(points)pts In Total")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "6D28D9"))
                    .multilineTextAlignment(.center)
            }
            
            // Button
            Button(action: onDismiss) {
                Text("Finished")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primaryBlue)
                    .cornerRadius(100)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
            .padding(.top, 20)
        }
        .frame(width: 320)
        .background(
            LinearGradient(
                colors: [Color(hex: "C084FC"), Color(hex: "E9D5FF"), .white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
    }
}
