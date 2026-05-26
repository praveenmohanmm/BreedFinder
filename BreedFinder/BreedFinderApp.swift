import SwiftUI

@main
struct BreedFinderApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainView()
                    .opacity(showSplash ? 0 : 1)

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.45), value: showSplash)
            .task {
                try? await Task.sleep(for: .seconds(1.8))
                showSplash = false
            }
        }
    }
}
