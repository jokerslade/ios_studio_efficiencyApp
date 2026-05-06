import SwiftUI

struct ChatSessionView: View {
    @Environment(\.dismiss) var dismiss
    var initialText: String = ""
    
    @State private var inputText = ""
    @State private var showingVoice = false
    @State private var messages: [ChatMessage] = []
    
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
                    Text("Assignment consultation")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.textPrimary)
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
                
                // Messages List
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) {
                        withAnimation {
                            proxy.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                
                // Input Bar
                ChatInputBar(text: $inputText, onVoicePress: {
                    showingVoice = true
                }, onSubmit: {
                    sendMessage()
                })
                .padding(.bottom, 10)
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingVoice) {
            VoiceListeningView(showingChatSession: .constant(false), inputText: $inputText)
        }
        .onAppear {
            if !initialText.isEmpty {
                inputText = initialText
                sendMessage()
            }
        }
    }
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        let userMessage = ChatMessage(text: inputText, isUser: true)
        messages.append(userMessage)
        inputText = ""
        
        // Show loading bubble
        let loadingMessage = ChatMessage(text: "I'm checking your assignment requirements now, wait for a moment..", isUser: false, isLoading: true)
        messages.append(loadingMessage)
        
        // Simulate response
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let index = messages.firstIndex(where: { $0.isLoading }) {
                messages.remove(at: index)
            }
            let aiMessage = ChatMessage(text: "Based on the rubric, you need to include at least 3 peer-reviewed sources and structure it into Intro, Body, and Conclusion. Would you like me to generate a skeleton?", isUser: false)
            messages.append(aiMessage)
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                if message.isUser {
                    Spacer()
                }
                
                VStack(alignment: message.isUser ? .trailing : .leading, spacing: 8) {
                    Text(message.text)
                        .font(.system(size: 16))
                        .foregroundColor(message.isUser ? .white : .textPrimary)
                        .padding(16)
                        .background(message.isUser ? Color.primaryBlue : Color.white)
                        .clipShape(ChatBubbleShape(isUser: message.isUser))
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    if message.isLoading {
                        ProgressView()
                            .padding(.horizontal, 16)
                    }
                }
                .frame(maxWidth: geometry.size.width * 0.75, alignment: message.isUser ? .trailing : .leading)
                
                if !message.isUser {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ChatBubbleShape: Shape {
    let isUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: isUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        return Path(path.cgPath)
    }
}
