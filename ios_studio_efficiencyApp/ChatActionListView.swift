import SwiftUI

struct ChatActionListView: View {
    @Environment(\.dismiss) var dismiss
    var type: ChatHomeView.ActionListType
    @Binding var showingChatSession: Bool
    
    @State private var inputText = ""
    @State private var showingVoice = false
    
    var title: String {
        switch type {
        case .assignment: return "Assignment Consultation"
        case .rescheduling: return "Re-scheduling Tasks"
        }
    }
    
    struct ActionItem: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let color: Color
    }
    
    var items: [ActionItem] {
        switch type {
        case .assignment:
            return [
                ActionItem(title: "Generate Skeleton", icon: "text.alignleft", color: .orangeAccent),
                ActionItem(title: "Check Your Work", icon: "globe", color: .playPauseGreen),
                ActionItem(title: "Search References", icon: "book", color: .primaryBlue)
            ]
        case .rescheduling:
            return [
                ActionItem(title: "Tasks Break-down", icon: "square.grid.2x2", color: .orangeAccent),
                ActionItem(title: "Change Time Periods", icon: "clock", color: .playPauseGreen),
                ActionItem(title: "Amend Points", icon: "medal", color: .primaryBlue),
                ActionItem(title: "Reflect Issues", icon: "face.smiling", color: .primaryBlue) // Assuming a blue sad/neutral face in mockup
            ]
        }
    }
    
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
                    HStack {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.gray)
                        Text("10")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .foregroundColor(.textPrimary)
                }
                .padding()
                
                // Title
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .padding(.vertical, 20)
                
                // List
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(items) { item in
                            Button(action: {
                                inputText = item.title
                                showingChatSession = true
                            }) {
                                HStack(spacing: 16) {
                                    Image(systemName: item.icon)
                                        .font(.system(size: 20))
                                        .foregroundColor(item.color)
                                        .frame(width: 24)
                                    
                                    Text(item.title)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                // Input Bar
                ChatInputBar(text: $inputText, onVoicePress: {
                    showingVoice = true
                }, onSubmit: {
                    showingChatSession = true
                })
                .padding(.bottom, 80)
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingVoice) {
            VoiceListeningView(showingChatSession: $showingChatSession, inputText: $inputText)
        }
    }
}
