import SwiftUI

struct PointsShopView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let shopItems: [ShopItem] = [
        ShopItem(title: "AI Consult X 1", iconName: "desktopcomputer", points: 500, quantity: "x 99"),
        ShopItem(title: "New Skin", iconName: "tshirt", points: 3000, quantity: "x 1"),
        ShopItem(title: "AI Consult X 10", iconName: "desktopcomputer", points: 5000, quantity: "x 99"),
        ShopItem(title: "New Skin", iconName: "tshirt", points: 3000, quantity: "x 1"),
        ShopItem(title: "New Skin", iconName: "tshirt", points: 3000, quantity: "x 1"),
        ShopItem(title: "Pro Version", iconName: "gearshape.2", points: 10000, quantity: "x 1")
    ]
    
    // Grid layout: 2 columns
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(colors: [Color.bgTop, Color.bgBottom],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Nav Bar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 5)
                    }
                    
                    Text("Points Shop")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                // Top Bar for Points and Badges
                HStack {
                    HStack(spacing: 16) {
                        BadgeMiniView(icon: "medal.fill", color: .yellow, count: 10)
                        BadgeMiniView(icon: "medal.fill", color: .gray, count: 2)
                        BadgeMiniView(icon: "medal.fill", color: .orangeAccent, count: 0)
                    }
                    
                    Spacer()
                    
                    Text("2500 Pt")
                        .font(.system(size: 20, weight: .bold))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal, 24)
                .shadow(color: .black.opacity(0.05), radius: 5)
                
                // Shop Items Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(shopItems) { item in
                            ShopItemCard(item: item)
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

struct BadgeMiniView: View {
    var icon: String
    var color: Color
    var count: Int
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16))
            Text("\(count)")
                .font(.system(size: 14, weight: .bold))
        }
    }
}

struct ShopItemCard: View {
    var item: ShopItem
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if let qty = item.quantity {
                    Text(qty)
                        .font(.system(size: 10, weight: .semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .padding([.top, .trailing], 12)
            
            // Large Icon Placeholder
            Image(systemName: item.iconName)
                .font(.system(size: 50))
                .foregroundColor(.black)
                .frame(height: 80)
            
            Text(item.title)
                .font(.system(size: 16, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
                .frame(height: 40)
            
            Button(action: {
                // Buy action
            }) {
                Text("\(item.points) Pt")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.primaryBlue)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

#Preview {
    PointsShopView()
}
