import SwiftUI

// MARK: - Trait segmented-level row (5 steps: 1 → 3 → 5 → 7 → 9)
/// Drop-in replacement for the old slider. Same external API (traitName / value / valueLabel)
/// so MainView.swift needs zero changes.
struct TraitSliderRow: View {
    let traitName:  String
    @Binding var value: Double   // 0–10, snaps to 1 / 3 / 5 / 7 / 9
    let valueLabel: String       // semantic label for the current selection

    // Snap-point values for the five segments
    private static let snaps: [Double] = [1, 3, 5, 7, 9]

    /// Segment index for the current value (0–4)
    private var segIndex: Int {
        let idx = Int(round((max(0, min(10, value)) - 1.0) / 2.0))
        return max(0, min(4, idx))
    }

    var body: some View {
        VStack(spacing: 5) {
            // ── Label row ────────────────────────────────────────────────
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

            // ── 5-segment control ────────────────────────────────────────
            HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { idx in
                    let selected = idx == segIndex
                    Button {
                        withAnimation(.easeInOut(duration: 0.14)) {
                            value = TraitSliderRow.snaps[idx]
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selected
                                      ? Color.appPrimary
                                      : Color.appTagBackground)

                            Text("\(idx + 1)")
                                .font(.caption.bold())
                                .foregroundStyle(selected
                                                 ? Color.white
                                                 : Color.appPrimary.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity, minHeight: 36)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.bottom, 6)
    }
}
