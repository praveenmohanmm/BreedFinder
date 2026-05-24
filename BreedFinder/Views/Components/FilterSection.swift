import SwiftUI

// MARK: - Collapsible filter section card
struct FilterSection<Content: View>: View {
    let icon: String
    let title: String
    @State private var expanded: Bool = true
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            // Header row — tap to expand / collapse
            Button {
                withAnimation(.easeInOut(duration: 0.22)) {
                    expanded.toggle()
                }
            } label: {
                HStack(spacing: 8) {
                    Text(icon)
                        .font(.body)
                    Text(title)
                        .font(.subheadline.bold())
                        .foregroundStyle(Color.appTextPrimary)
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.caption.bold())
                        .foregroundStyle(Color.appPrimary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if expanded {
                Divider()
                    .background(Color.appBorder)

                content()
                    .padding(.horizontal, 14)
                    .padding(.top, 10)
                    .padding(.bottom, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.75))
                .shadow(color: Color.appPrimary.opacity(0.07), radius: 6, x: 0, y: 2)
        )
    }
}
