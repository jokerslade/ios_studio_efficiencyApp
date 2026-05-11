import SwiftUI

struct TaskPerformanceView: View {
    let days = [16, 17, 18, 19, 20, 21, 22]
    
    // Mock data for point transactions
    let transactions: [PointTransaction] = [
        PointTransaction(title: "Essay Task Finished", points: 100, type: .essay),
        PointTransaction(title: "Finished On Time", points: 20, type: .time),
        PointTransaction(title: "Interview Task Finished", points: -100, type: .interview),
        PointTransaction(title: "Research Task Finished", points: -100, type: .research)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(colors: [Color.bgTop, Color.bgBottom],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Text("Task Performance")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        NavigationLink(destination: WeeklySummaryView()) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.black)
                                .padding(12)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 5)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Calendar/Badges row
                    HStack(spacing: 0) {
                        ForEach(days, id: \.self) { day in
                            VStack(spacing: 8) {
                                Text("\(day)")
                                    .font(.system(size: 14, weight: day == 20 ? .bold : .regular))
                                    .foregroundColor(day == 20 ? .primaryBlue : .gray)
                                
                                // Badge
                                if day == 16 || day == 17 {
                                    Image(systemName: "medal.fill")
                                        .foregroundColor(.orangeAccent)
                                        .font(.system(size: 18))
                                } else if day == 19 {
                                    Image(systemName: "medal.fill")
                                        .foregroundColor(.gray.opacity(0.5))
                                        .font(.system(size: 18))
                                } else if day == 20 {
                                    Image(systemName: "medal.fill")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 24))
                                        .shadow(color: .yellow.opacity(0.5), radius: 5)
                                } else {
                                    // Empty placeholder for alignment
                                    Image(systemName: "circle")
                                        .foregroundColor(.clear)
                                        .font(.system(size: 18))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(day == 20 ? Color.white : Color.clear)
                                    .shadow(color: day == 20 ? .black.opacity(0.1) : .clear, radius: 5, x: 0, y: 2)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, -8)
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Circular Progress
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.gray)
                                .font(.system(size: 20, weight: .semibold))
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                            
                            Circle()
                                .trim(from: 0, to: 1.0)
                                .stroke(
                                    LinearGradient(colors: [.primaryBlue, .playPauseGreen, .yellow], startPoint: .leading, endPoint: .trailing),
                                    style: StrokeStyle(lineWidth: 15, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                            
                            VStack {
                                Text("Daily Tasks\nCompleted:")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                
                                Text("100%")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("Well Done !")
                                    .font(.system(size: 12))
                                    .foregroundColor(.purple) // Assuming a purple tone for "Well Done" based on design
                            }
                            
                            // Large Badge overlapping bottom
                            Image(systemName: "medal.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.yellow)
                                .shadow(color: .yellow.opacity(0.5), radius: 10)
                                .offset(y: 80)
                        }
                        .frame(width: 160, height: 160)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.system(size: 20, weight: .semibold))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Points List Card
                    VStack(spacing: 16) {
                        HStack {
                            Text("Points Achieved:")
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                            Text("420 Pt")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .padding(.bottom, 8)
                        
                        ForEach(transactions) { tx in
                            HStack {
                                Circle()
                                    .fill(tx.type.color)
                                    .frame(width: 8, height: 8)
                                
                                Text(tx.title)
                                    .font(.system(size: 14))
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                Text("\(tx.points > 0 ? "+" : "")\(tx.points) Pt")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }
                        }
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                    .padding(.horizontal, 24)
                    
                    // Bottom Buttons
                    VStack(spacing: 12) {
                        NavigationLink(destination: RankingView()) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(.black)
                                Text("Ranking")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.05), radius: 5)
                        }
                        
                        NavigationLink(destination: PointsShopView()) {
                            HStack {
                                Image(systemName: "gift.fill")
                                    .foregroundColor(.black)
                                Text("Points Shop")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.05), radius: 5)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 100) // Space for TabBar
                }
            }
        }
    }
}

#Preview {
    TaskPerformanceView()
}
