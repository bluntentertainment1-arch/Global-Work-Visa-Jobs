import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isAnimating = false
    @State private var planeOffset1: CGFloat = -200
    @State private var planeOffset2: CGFloat = -300
    @State private var planeOffset3: CGFloat = -250
    @State private var globeRotation: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var subtitleOpacity: Double = 0
    @State private var scaleEffect: CGFloat = 0.8
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var taglineOffset: CGFloat = 50
    @State private var featuresOpacity: Double = 0
    @State private var progressValue: Double = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "#0F2027"),
                    Color(hex: "#203A43"),
                    Color(hex: "#2C5364")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 50,
                                endRadius: 200
                            )
                        )
                        .frame(width: 400, height: 400)
                        .blur(radius: 30)
                        .opacity(logoOpacity)
                    
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 160, height: 160)
                                .blur(radius: 10)
                            
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.6),
                                            Color.white.opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                                .frame(width: 150, height: 150)
                            
                            Image(systemName: "globe.americas.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.white,
                                            Color(hex: "#E3F2FD")
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .rotationEffect(.degrees(globeRotation))
                                .shadow(color: Color.white.opacity(0.5), radius: 20, x: 0, y: 10)
                            
                            Image(systemName: "airplane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(-45))
                                .offset(x: planeOffset1, y: -60)
                                .shadow(color: Color.white.opacity(0.6), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "airplane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white.opacity(0.9))
                                .rotationEffect(.degrees(45))
                                .offset(x: planeOffset2, y: 50)
                                .shadow(color: Color.white.opacity(0.6), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "airplane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 26, height: 26)
                                .foregroundColor(.white.opacity(0.95))
                                .rotationEffect(.degrees(0))
                                .offset(x: planeOffset3, y: 0)
                                .shadow(color: Color.white.opacity(0.6), radius: 8, x: 0, y: 4)
                        }
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        
                        VStack(spacing: 12) {
                            Text("Global Work Visa Jobs")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.white,
                                            Color(hex: "#E3F2FD")
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .multilineTextAlignment(.center)
                                .opacity(titleOpacity)
                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            Text("Your Gateway to International Opportunities")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white.opacity(0.95))
                                .multilineTextAlignment(.center)
                                .opacity(subtitleOpacity)
                                .offset(y: taglineOffset)
                                .padding(.horizontal, 40)
                        }
                    }
                }
                .frame(height: 400)
                
                Spacer()
                    .frame(height: 60)
                
                VStack(spacing: 20) {
                    HStack(spacing: 24) {
                        FeatureIcon(icon: "briefcase.fill", label: "Global Jobs")
                        FeatureIcon(icon: "doc.text.fill", label: "Visa Support")
                        FeatureIcon(icon: "globe", label: "Worldwide")
                    }
                    .opacity(featuresOpacity)
                    
                    VStack(spacing: 16) {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 6)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white,
                                            Color(hex: "#4A90E2")
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: UIScreen.main.bounds.width * 0.7 * progressValue, height: 6)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.7)
                        
                        Text("Loading opportunities...")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .opacity(featuresOpacity)
                }
                .padding(.bottom, 80)
            }
            
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: CGFloat.random(in: 3...6), height: CGFloat.random(in: 3...6))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .opacity(isAnimating ? 1 : 0)
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 1.5...3))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                titleOpacity = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
                subtitleOpacity = 1.0
                taglineOffset = 0
            }
            
            withAnimation(.easeIn(duration: 0.6).delay(0.8)) {
                featuresOpacity = 1.0
            }
            
            withAnimation(
                Animation.linear(duration: 20)
                    .repeatForever(autoreverses: false)
            ) {
                globeRotation = 360
            }
            
            withAnimation(
                Animation.linear(duration: 3)
                    .repeatForever(autoreverses: false)
            ) {
                planeOffset1 = UIScreen.main.bounds.width + 200
            }
            
            withAnimation(
                Animation.linear(duration: 4)
                    .repeatForever(autoreverses: false)
                    .delay(0.5)
            ) {
                planeOffset2 = UIScreen.main.bounds.width + 300
            }
            
            withAnimation(
                Animation.linear(duration: 3.5)
                    .repeatForever(autoreverses: false)
                    .delay(1)
            ) {
                planeOffset3 = UIScreen.main.bounds.width + 250
            }
            
            withAnimation(.linear(duration: 2.5).delay(1.0)) {
                progressValue = 1.0
            }
            
            isAnimating = true
        }
    }
}

struct FeatureIcon: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.25),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.95))
        }
    }
}