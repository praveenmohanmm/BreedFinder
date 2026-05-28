import SwiftUI

// MARK: - Trait EQ-bar picker (5 steps: 1 → 3 → 5 → 7 → 9)
/// Drop-in replacement for the old slider/segment control.
/// Renders as 5 progressively-taller vertical bars (EQ-style).
/// The selected bar glows with a gradient; bar height encodes scale visually.
struct TraitSliderRow: View {
    let traitName:  String
    @Binding var value: Double   // 0–10, snaps to 1 / 3 / 5 / 7 / 9
    let valueLabel: String

    private static let snaps:      [Double]  = [1, 3, 5, 7, 9]
    private static let barHeights: [CGFloat] = [10, 18, 27, 36, 46]

    private var segIndex: Int {
        let idx = Int(round((max(0, min(10, value)) - 1.0) / 2.0))
        return max(0, min(4, idx))
    }

    var body: some View {
        VStack(spacing: 7) {
            // ── Trait name + current value label ─────────────────────────
            HStack {
                Text(traitName)
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
                Spacer()
                Text(valueLabel)
                    .font(.caption.bold())
                    .foregroundStyle(Color.appPrimary)
                    .lineLimit(1)
                    .animation(.none, value: valueLabel)
            }

            // ── EQ bars ───────────────────────────────────────────────────
            HStack(alignment: .bottom, spacing: 5) {
                ForEach(0..<5, id: \.self) { idx in
                    let selected = idx == segIndex
                    let barH     = Self.barHeights[idx]

                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.58)) {
                            value = Self.snaps[idx]
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 5)
                            // Base fill (always present)
                            .fill(Color.appTagBackground)
                            // Gradient overlay on selected bar
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.appSecondary, Color.appPrimary],
                                            startPoint: .bottom,
                                            endPoint: .top
                                        )
                                    )
                                    .opacity(selected ? 1 : 0)
                            )
                            // Border on unselected bars
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.appBorder, lineWidth: 1)
                                    .opacity(selected ? 0 : 1)
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: barH)
                            // Glow behind selected bar
                            .shadow(
                                color: selected ? Color.appPrimary.opacity(0.45) : .clear,
                                radius: 6, x: 0, y: 3
                            )
                            // Subtle scale-up on selection
                            .scaleEffect(x: 1, y: selected ? 1.06 : 1, anchor: .bottom)
                    }
                    .buttonStyle(.plain)
                }
            }
            // Fixed container height; bars grow upward from the baseline
            .frame(height: 50, alignment: .bottom)
        }
        .padding(.bottom, 8)
    }
}
