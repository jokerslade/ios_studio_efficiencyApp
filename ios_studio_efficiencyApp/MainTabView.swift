import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0 // 0: Home, 1: Chat, 2: Achieve
    
    var body: some View {
        ZStack {
            // Main Content
            Group {
                switch selectedTab {
                case 0:
                    DashboardView()
                case 1:
                    ChatHomeView()
                case 2:
                    TaskPerformanceView()
                default:
                    DashboardView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Tab Bar Overlay
            VStack {
                Spacer()
                CustomTabBarOverlay(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct CustomTabBarOverlay: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            TabBarOverlayItem(iconName: "house", title: "HOME", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            Spacer()
            TabBarOverlayItem(iconName: "message", title: "CHAT", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            Spacer()
            TabBarOverlayItem(iconName: "trophy", title: "ACHIEVE", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 15)
        .padding(.bottom, 30)
        .background(Color.white)
        .clipShape(RoundedCornerOverlay(radius: 30, corners: [.topLeft, .topRight]))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
    }
}

struct TabBarOverlayItem: View {
    var iconName: String
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? "\(iconName).fill" : iconName)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .primaryBlue : .gray)
                Text(title)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(isSelected ? .primaryBlue : .gray)
            }
        }
    }
}

struct RoundedCornerOverlay: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
