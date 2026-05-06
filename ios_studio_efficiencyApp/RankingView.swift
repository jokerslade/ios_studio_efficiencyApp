import SwiftUI

struct RankingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var timeRange: String = "Weekly"
    @State private var selectedTab: Int = 0 // 0: Following, 1: Worldwide
    
    let timeRanges = ["Weekly", "Monthly", "Yearly"]
    
    // Current user mock data
    let currentUser = UserRanking(rank: 1120, name: "User 1", avatarName: "person.circle.fill", isCurrentUser: true, goldBadges: 31, silverBadges: 35, bronzeBadges: 10, points: 24000, upvotes: 0, trend: 0)
    
    // Mock list
    let rankings: [UserRanking] = [
        UserRanking(rank: 1117, name: "User Name", avatarName: "person.circle.fill", gold: 4, silver: 2, bronze: 1, points: 2700, upvotes: 100, trend: 1),
        UserRanking(rank: 1118, name: "User Name", avatarName: "person.circle.fill", gold: 4, silver: 2, bronze: 1, points: 2600, upvotes: 100, trend: 1),
        UserRanking(rank: 1119, name: "User Name", avatarName: "person.circle.fill", gold: 4, silver: 2, bronze: 1, points: 2550, upvotes: 100, trend: 1),
        UserRanking(rank: 1120, name: "User 1", avatarName: "person.circle.fill", isCurrentUser: true, gold: 4, silver: 2, bronze: 1, points: 2300, upvotes: 100, trend: -1),
        UserRanking(rank: 1121, name: "User Name", avatarName: "person.circle.fill", gold: 4, silver: 2, bronze: 1, points: 2300, upvotes: 100, trend: 1),
        UserRanking(rank: 1122, name: "User Name", avatarName: "person.circle.fill", gold: 4, silver: 2, bronze: 1, points: 2300, upvotes: 100, trend: 1),
        UserRanking(rank: 1123, name: "User Name", avatarName: "person.circle.fill", gold: 4, silver: 2, bronze: 1, points: 2300, upvotes: 100, trend: 1),
        UserRanking(rank: 1124, name: "User Name", avatarName: "person.circle.fill", gold: 4, silver: 2, bronze: 1, points: 2300, upvotes: 100, trend: 1)
    ]
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(colors: [Color.bgTop, Color.bgBottom],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Nav Bar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 5)
                    }
                    
                    Text("Ranking")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    // Picker
                    Menu {
                        ForEach(timeRanges, id: \.self) { range in
                            Button(action: { timeRange = range }) {
                                Text(range)
                            }
                        }
                    } label: {
                        HStack {
                            Text(timeRange)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.05), radius: 5)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                // Current User Header
                VStack(spacing: 8) {
                    HStack(alignment: .top, spacing: 20) {
                        // Avatar (Placeholder)
                        Circle()
                            .fill(Color.orange.opacity(0.3))
                            .frame(width: 70, height: 70)
                            .overlay(
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 70))
                                    .foregroundColor(.orange)
                            )
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 16) {
                                BadgeDisplayView(icon: "medal.fill", color: .yellow, count: currentUser.goldBadges)
                                BadgeDisplayView(icon: "medal.fill", color: .gray, count: currentUser.silverBadges)
                                BadgeDisplayView(icon: "medal.fill", color: .orangeAccent, count: currentUser.bronzeBadges)
                            }
                            
                            Text("Total Earned: \(currentUser.points) Pt")
                                .font(.system(size: 14, weight: .bold))
                            
                            HStack(spacing: 16) {
                                Text("Following: 232")
                                    .font(.system(size: 12, weight: .semibold))
                                Text("Followers: 12")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                        }
                    }
                    
                    Text(currentUser.name)
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 16)
                
                // Segmented Control
                HStack(spacing: 0) {
                    Button(action: { selectedTab = 0 }) {
                        Text("Following")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(selectedTab == 0 ? .primaryBlue : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedTab == 0 ? Color.white : Color.white.opacity(0.5))
                            .cornerRadius(15, corners: [.topLeft, .bottomLeft])
                    }
                    
                    Button(action: { selectedTab = 1 }) {
                        Text("Worldwide")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(selectedTab == 1 ? .primaryBlue : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedTab == 1 ? Color.white : Color.white.opacity(0.5))
                            .cornerRadius(15, corners: [.topRight, .bottomRight])
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                
                // Ranking List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(rankings) { user in
                            RankingRowView(user: user)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// Helper Extension for UserRanking to initialize easily with mock data
extension UserRanking {
    init(rank: Int, name: String, avatarName: String, isCurrentUser: Bool = false, gold: Int, silver: Int, bronze: Int, points: Int, upvotes: Int, trend: Int) {
        self.init(rank: rank, name: name, avatarName: avatarName, isCurrentUser: isCurrentUser, goldBadges: gold, silverBadges: silver, bronzeBadges: bronze, points: points, upvotes: upvotes, isUpvoted: false, trend: trend)
    }
}

struct BadgeDisplayView: View {
    var icon: String
    var color: Color
    var count: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 18))
            Text("\(count)")
                .font(.system(size: 14, weight: .bold))
        }
    }
}

struct RankingRowView: View {
    var user: UserRanking
    
    var body: some View {
        HStack {
            Text("\(user.rank)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(user.isCurrentUser ? .white : .black)
                .frame(width: 40, alignment: .leading)
            
            Circle()
                .fill(Color.orange.opacity(0.3))
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(user.name)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(user.isCurrentUser ? .white : .black)
                    
                    HStack(spacing: 2) {
                        Image(systemName: "medal.fill").foregroundColor(.yellow).font(.system(size: 10))
                        Text("\(user.goldBadges)").font(.system(size: 10, weight: .bold)).foregroundColor(user.isCurrentUser ? .white : .black)
                        Image(systemName: "medal.fill").foregroundColor(.gray).font(.system(size: 10))
                        Text("\(user.silverBadges)").font(.system(size: 10, weight: .bold)).foregroundColor(user.isCurrentUser ? .white : .black)
                        Image(systemName: "medal.fill").foregroundColor(.orangeAccent).font(.system(size: 10))
                        Text("\(user.bronzeBadges)").font(.system(size: 10, weight: .bold)).foregroundColor(user.isCurrentUser ? .white : .black)
                    }
                }
                
                HStack(spacing: 4) {
                    Text("\(user.points) Pt")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(user.isCurrentUser ? .white : .black)
                    
                    if user.trend > 0 {
                        Image(systemName: "arrowtriangle.up.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 10))
                    } else if user.trend < 0 {
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 10))
                    }
                }
            }
            
            Spacer()
            
            // Upvote Button
            Button(action: {}) {
                VStack(spacing: 2) {
                    Image(systemName: "hand.thumbsup")
                        .font(.system(size: 14))
                    Text("\(user.upvotes)")
                        .font(.system(size: 10))
                }
                .foregroundColor(user.isCurrentUser ? .white : .gray)
            }
            
            if user.isCurrentUser {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                    .padding(.leading, 8)
            } else {
                Image(systemName: "plus")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .bold))
                    .padding(.leading, 8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(user.isCurrentUser ? Color.primaryBlue : Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

// Helper to round specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    RankingView()
}
