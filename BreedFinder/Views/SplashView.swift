import SwiftUI

// MARK: - Animated splash / launch screen
struct SplashView: View {
    @State private var scale:     CGFloat = 0.55
    @State private var opacity:   Double  = 0
    @State private var pawBounce: CGFloat = 0

    var body: some View {
        ZStack {
            // Full-bleed blue gradient
            LinearGradient(
                colors: [
                    Color(hex: "#1249B8"),
                    Color(hex: "#1D6EF5"),
                    Color(hex: "#5B9AFF"),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Paw print with entrance + bounce animation
                Text("🐾")
                    .font(.system(size: 96))
                    .scaleEffect(scale)
                    .offset(y: pawBounce)
                    .shadow(color: .white.opacity(0.25), radius: 24, x: 0, y: 8)

                VStack(spacing: 8) {
                    Text("Breed Finder")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    Text("Find your perfect match")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.80))
                }
                .opacity(opacity)
            }
        }
        .onAppear {
            // Scale-up spring entrance
            withAnimation(.spring(response: 0.52, dampingFraction: 0.58)) {
                scale = 1.0
            }
            // Fade-in text
            withAnimation(.easeIn(duration: 0.38).delay(0.22)) {
                opacity = 1
            }
            // Small bounce after landing
            withAnimation(.easeInOut(duration: 0.22).delay(0.56)) {
                pawBounce = -14
            }
            withAnimation(.easeInOut(duration: 0.22).delay(0.78)) {
                pawBounce = 0
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SplashView()
}
