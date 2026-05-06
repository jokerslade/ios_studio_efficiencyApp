import SwiftUI

struct VoiceListeningView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showingChatSession: Bool
    @Binding var inputText: String
    
    @State private var isRecording = false
    @State private var transcribedText = ""
    @State private var timer: Timer?
    @State private var secondsElapsed = 0
    
    var timeString: String {
        let minutes = secondsElapsed / 60
        let seconds = secondsElapsed % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.bgTop, .bgBottom], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
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
                
                Text("I'm Listening...")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .padding(.top, 20)
                
                // Animated Orb
                ZStack {
                    Circle()
                        .fill(
                            AngularGradient(gradient: Gradient(colors: [.blue, .purple, .pink, .orange, .blue]), center: .center)
                        )
                        .frame(width: 150, height: 150)
                        .blur(radius: 20)
                        .scaleEffect(isRecording ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isRecording)
                    
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 140, height: 140)
                }
                .padding(.vertical, 40)
                
                // Transcribed Text Card
                if !transcribedText.isEmpty {
                    Text(transcribedText)
                        .font(.system(size: 16, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .padding(20)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                }
                
                Spacer()
                
                // Recording Controls
                VStack(spacing: 20) {
                    Text("Press and hold")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        if isRecording {
                            stopRecording()
                        } else {
                            startRecording()
                        }
                    }) {
                        Image(systemName: isRecording ? "waveform" : "mic.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(isRecording ? Color.orangeAccent : Color.primaryBlue)
                            .clipShape(Circle())
                            .shadow(color: isRecording ? .orangeAccent.opacity(0.5) : .primaryBlue.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.1)
                            .onEnded { _ in
                                startRecording()
                            }
                    )
                    
                    HStack(spacing: 30) {
                        Button(action: {
                            transcribedText = ""
                            secondsElapsed = 0
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 20))
                                .foregroundColor(.textPrimary)
                                .padding(12)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        
                        Text(timeString)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .frame(width: 60)
                        
                        Button(action: {
                            if !transcribedText.isEmpty {
                                inputText = transcribedText
                                showingChatSession = true
                                dismiss()
                            }
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 20))
                                .foregroundColor(.textPrimary)
                                .padding(12)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    func startRecording() {
        isRecording = true
        secondsElapsed = 0
        transcribedText = "I feel really confused about the assignment requirement, can you explain it detailedly to me ?"
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            secondsElapsed += 1
        }
    }
    
    func stopRecording() {
        isRecording = false
        timer?.invalidate()
        timer = nil
    }
}
