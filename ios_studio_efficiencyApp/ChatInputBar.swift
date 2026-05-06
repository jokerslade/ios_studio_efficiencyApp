import SwiftUI

struct ChatInputBar: View {
    @Binding var text: String
    var onVoicePress: () -> Void
    var onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                // Attach action
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            
            TextField("Tell me more~", text: $text)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(24)
            
            if text.isEmpty {
                Button(action: onVoicePress) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.orangeAccent)
                        .clipShape(Circle())
                        .shadow(color: .orangeAccent.opacity(0.4), radius: 5, x: 0, y: 2)
                }
            } else {
                Button(action: onSubmit) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.primaryBlue)
                        .clipShape(Circle())
                        .shadow(color: .primaryBlue.opacity(0.4), radius: 5, x: 0, y: 2)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
