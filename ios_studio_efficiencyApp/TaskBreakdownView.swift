import SwiftUI

struct TaskBreakdownView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tasks: [TaskModel]
    @State var task: TaskModel
    
    @State private var selectedTab = 1
    @State private var selectedDate = 22
    
    // Using simple integers for the mockup dates
    let dates = [21, 22, 23, 24, 25]
    let days = ["SUN", "MON", "TUE", "WED", "THU"]
    
    // To navigate back to root
    @Environment(\.isPresented) var isPresented
    
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
                    Text("Task Breakdown")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.left").opacity(0).padding(12)
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Task Info
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("DUE DATE")
                                    .font(.system(size: 10, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(4)
                                Text("3 APRIL 2026")
                                    .font(.system(size: 12, weight: .bold))
                            }
                            
                            Text(task.title)
                                .font(.system(size: 32, weight: .bold))
                            
                            HStack(spacing: 20) {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                    Text("5 hours")
                                }
                                HStack(spacing: 4) {
                                    Text("Subs:")
                                    Text("\(task.subtasks.count)")
                                }
                                Spacer()
                                Text("Total: \(task.points) Pt")
                                    .fontWeight(.bold)
                            }
                            .font(.system(size: 14))
                            .foregroundColor(.textPrimary)
                        }
                        
                        // Tabs
                        HStack {
                            Button(action: { selectedTab = 0 }) {
                                Text("Finish Today")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(selectedTab == 0 ? .primaryBlue : .gray)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(selectedTab == 0 ? Color.white : Color.clear)
                                    .cornerRadius(12)
                                    .shadow(color: selectedTab == 0 ? .black.opacity(0.05) : .clear, radius: 5, x: 0, y: 2)
                            }
                            Button(action: { selectedTab = 1 }) {
                                Text("Finish In\nMulti-Days")
                                    .font(.system(size: 14, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(selectedTab == 1 ? .primaryBlue : .gray)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(selectedTab == 1 ? Color.white : Color.clear)
                                    .cornerRadius(12)
                                    .shadow(color: selectedTab == 1 ? .black.opacity(0.05) : .clear, radius: 5, x: 0, y: 2)
                            }
                        }
                        .padding(4)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(16)
                        
                        // Schedule
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "chevron.down")
                                Text("SELECT SCHEDULE FOR EACH TASK")
                                    .font(.system(size: 10, weight: .bold))
                                Spacer()
                                Text("MARCH")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.primaryBlue)
                            }
                            .foregroundColor(.textSecondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(0..<dates.count, id: \.self) { index in
                                        let date = dates[index]
                                        let day = days[index]
                                        let isSelected = selectedDate == date
                                        
                                        VStack(spacing: 8) {
                                            Text(day)
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(isSelected ? .white : .gray)
                                            Text("\(date)")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(isSelected ? .white : .textPrimary)
                                        }
                                        .frame(width: 60, height: 80)
                                        .background(isSelected ? Color.primaryBlue : Color.white)
                                        .cornerRadius(16)
                                        .shadow(color: isSelected ? .primaryBlue.opacity(0.3) : .black.opacity(0.05), radius: 5, x: 0, y: 2)
                                        .onTapGesture {
                                            selectedDate = date
                                        }
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        
                        // Breakdown
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "chevron.down")
                                Text("TASK BREAKDOWN & ESTIMATED TIME 8/6")
                                    .font(.system(size: 10, weight: .bold))
                            }
                            .foregroundColor(.textSecondary)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(Array(task.subtasks.enumerated()), id: \.offset) { index, subtask in
                                    HStack(alignment: .top, spacing: 16) {
                                        // Timeline visual
                                        VStack(spacing: 0) {
                                            ZStack {
                                                Circle()
                                                    .stroke(Color.primaryBlue, lineWidth: 2)
                                                    .frame(width: 16, height: 16)
                                                if index == 0 {
                                                    Circle()
                                                        .fill(Color.primaryBlue)
                                                        .frame(width: 8, height: 8)
                                                }
                                            }
                                            if index != task.subtasks.count - 1 {
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.3))
                                                    .frame(width: 2, height: 80)
                                            }
                                        }
                                        .padding(.top, 24)
                                        
                                        // Card
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Text(subtask.title)
                                                    .font(.system(size: 16, weight: .bold))
                                                Spacer()
                                                Text("\(subtask.points) Pt")
                                                    .font(.system(size: 10, weight: .bold))
                                                    .foregroundColor(.primaryBlue)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(Color.primaryBlue.opacity(0.1))
                                                    .cornerRadius(4)
                                                Text(subtask.durationString)
                                                    .font(.system(size: 10, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(Color.primaryBlue)
                                                    .cornerRadius(4)
                                            }
                                            Text(subtask.subtitle)
                                                .font(.system(size: 12))
                                                .foregroundColor(.textSecondary)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        .padding(16)
                                        .background(Color.white)
                                        .cornerRadius(16)
                                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                                        .padding(.bottom, 16)
                                    }
                                }
                            }
                        }
                        
                        // Actions
                        HStack(spacing: 16) {
                            Button(action: {
                                // Add task to dashboard and dismiss
                                task.state = .pending // Or inProgress based on logic
                                tasks.append(task)
                                
                                // To pop to root in SwiftUI 16+, we typically pass a binding or use NavigationPath.
                                // A quick workaround is to just reset the array or hack dismiss.
                                // Here, we'll dismiss multiple times or ideally use a NavigationStack path.
                                // For the mockup, we will just dismiss back to the Create View which then should be dismissed.
                                NotificationCenter.default.post(name: NSNotification.Name("PopToRoot"), object: nil)
                            }) {
                                Text("Finished")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.primaryBlue)
                                    .cornerRadius(16)
                                    .shadow(color: .primaryBlue.opacity(0.3), radius: 5, x: 0, y: 5)
                            }
                            
                            Button(action: {
                                // Regenerate action
                            }) {
                                Text("Re-Generate\nBreakdown")
                                    .font(.system(size: 14, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(Color.orangeAccent)
                                    .cornerRadius(16)
                                    .shadow(color: .orangeAccent.opacity(0.3), radius: 5, x: 0, y: 5)
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 40)
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
}
