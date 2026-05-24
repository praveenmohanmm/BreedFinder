import SwiftUI

// MARK: - Horizontal trait bar (used on the detail page)
struct TraitBarRow: View {
    let label: String
    let value: Double   // 0–10

    var body: some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.appTextSecondary)
                .frame(width: 110, alignment: .leading)
                .lineLimit(1)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.appBorder)
                        .frame(height: 7)
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.appSecondary, Color.appPrimary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * (value / 10.0), height: 7)
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .frame(height: 7)

            Text(String(format: "%.0f", value))
                .font(.caption.bold())
                .foregroundStyle(Color.appPrimary)
                .frame(width: 22, alignment: .trailing)
        }
    }
}
