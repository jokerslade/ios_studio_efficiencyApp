import SwiftUI

struct CreateTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tasks: [TaskModel]
    
    @State private var taskDescription = ""
    @State private var assignmentType = "Essay"
    @State private var estimatedHours = "0"
    @State private var startDate = Date()
    @State private var dueDate = Date().addingTimeInterval(86400 * 7) // +1 week
    
    let assignmentTypes = ["Essay", "Report", "Project", "Study"]
    
    // For navigation to the breakdown view
    @State private var showingBreakdown = false
    @State private var generatedTask: TaskModel?
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.bgTop, .bgBottom], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                    Spacer()
                    Text("Enter Task Name")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.textPrimary)
                    Spacer()
                    // Invisible button for alignment
                    Image(systemName: "chevron.left").opacity(0).padding(12)
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Task Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("TASK DESCRIPTION")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.textSecondary)
                            
                            VStack {
                                TextEditor(text: $taskDescription)
                                    .frame(height: 100)
                                    .padding(8)
                                    .background(Color.clear)
                                
                                Button(action: {}) {
                                    HStack {
                                        Image(systemName: "doc.viewfinder")
                                        Text("Upload Assignment Description/ Rubric")
                                            .font(.system(size: 12))
                                    }
                                    .foregroundColor(.textPrimary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                }
                                .padding(.bottom, 12)
                            }
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        
                        // Assignment Type & Estimated Hours
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("ASSIGNMENT TYPE")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.textSecondary)
                                
                                Menu {
                                    ForEach(assignmentTypes, id: \.self) { type in
                                        Button(type) { assignmentType = type }
                                    }
                                } label: {
                                    HStack {
                                        Text(assignmentType)
                                            .foregroundColor(.textPrimary)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("ESTIMATED HOURS")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.textSecondary)
                                
                                HStack {
                                    TextField("0", text: $estimatedHours)
                                        .keyboardType(.numberPad)
                                    Text("HRS")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                        
                        // Set Dates
                        VStack(alignment: .leading, spacing: 8) {
                            Text("SET DATES")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.textSecondary)
                            
                            VStack(spacing: 0) {
                                DatePicker(selection: $startDate, displayedComponents: .date) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(.primaryBlue)
                                        Text("Start Date")
                                            .foregroundColor(.textPrimary)
                                    }
                                }
                                .padding()
                                
                                Divider().padding(.horizontal)
                                
                                DatePicker(selection: $dueDate, displayedComponents: [.date, .hourAndMinute]) {
                                    HStack {
                                        Image(systemName: "alarm")
                                            .foregroundColor(.red)
                                        Text("Due Date & Time")
                                            .foregroundColor(.textPrimary)
                                    }
                                }
                                .padding()
                            }
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        
                        Spacer(minLength: 40)
                        
                        // Action Buttons
                        VStack(spacing: 16) {
                            Button(action: {
                                // Generate Task logic
                                let newTask = TaskModel(
                                    title: "Biology Essay", // Placeholder for actual input or generation
                                    subtitle: "ESSAY",
                                    durationString: "05:00",
                                    points: 400,
                                    state: .pending,
                                    subtasks: [
                                        SubtaskModel(title: "Initial Research", subtitle: "Do research and collect relevant sources", durationString: "2 hours", points: 50),
                                        SubtaskModel(title: "Structure Essay", subtitle: "Structure essay into different sections", durationString: "45 mins", points: 50),
                                        SubtaskModel(title: "Essay Writing", subtitle: "Start writing essay", durationString: "3 hours", points: 50)
                                    ]
                                )
                                self.generatedTask = newTask
                                self.showingBreakdown = true
                            }) {
                                Text("Generate Task")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.primaryBlue)
                                    .cornerRadius(16)
                                    .shadow(color: .primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            
                            Button(action: {
                                dismiss()
                            }) {
                                Text("Cancel")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showingBreakdown) {
            if let task = generatedTask {
                TaskBreakdownView(tasks: $tasks, task: task)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PopToRoot"))) { _ in
            dismiss()
        }
    }
}
