import SwiftUI

struct ChatHomeView: View {
    @State private var inputText = ""
    @State private var showingVoice = false
    @State private var showingActionList = false
    @State private var actionListType: ActionListType = .assignment
    @State private var showingChatSession = false
    
    enum ActionListType {
        case assignment
        case rescheduling
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.bgTop, .bgBottom], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack {
                    // Header
                    HStack {
                        Button(action: {}) {
                            Text("History")
                                .font(.system(size: 14, weight: .bold))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                                .foregroundColor(.textPrimary)
                        }
                        Spacer()
                        HStack {
                            Image(systemName: "bolt.fill") // Using bolt instead of custom robot icon
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
                    
                    Spacer()
                    
                    // Main Greeting
                    Text("Hi XXX !\nHow can I help you\ntoday?")
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textPrimary)
                    
                    // Orb Placeholder
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 180, height: 180)
                            .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 0)
                        
                        Circle()
                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                            .frame(width: 160, height: 160)
                        
                        // Eyes
                        HStack(spacing: 20) {
                            Capsule()
                                .fill(Color.white)
                                .frame(width: 10, height: 30)
                            Capsule()
                                .fill(Color.white)
                                .frame(width: 10, height: 30)
                        }
                    }
                    .padding(.vertical, 40)
                    
                    // Quick Actions
                    HStack(spacing: 16) {
                        Button(action: {
                            actionListType = .rescheduling
                            showingActionList = true
                        }) {
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                    .foregroundColor(.orangeAccent)
                                Text("Tasks Re-\nscheduling")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        
                        Button(action: {
                            actionListType = .assignment
                            showingActionList = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.playPauseGreen)
                                Text("Assignment\nConsultation")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Input Bar
                    ChatInputBar(text: $inputText, onVoicePress: {
                        showingVoice = true
                    }, onSubmit: {
                        showingChatSession = true
                    })
                    .padding(.bottom, 80) // Space for TabBar
                }
            }
            .navigationDestination(isPresented: $showingActionList) {
                ChatActionListView(type: actionListType, showingChatSession: $showingChatSession)
            }
            .navigationDestination(isPresented: $showingChatSession) {
                ChatSessionView(initialText: inputText)
            }
            .fullScreenCover(isPresented: $showingVoice) {
                VoiceListeningView(showingChatSession: $showingChatSession, inputText: $inputText)
            }
        }
    }
}
