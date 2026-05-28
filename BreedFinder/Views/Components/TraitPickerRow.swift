import SwiftUI

// MARK: - Pill-style option picker  (matches reference filter UI)
/// Shows a trait label and a horizontal row of 5 tappable capsule pills.
/// The selected pill gets a brand-colour border + subtle tint;
/// unselected pills use a neutral light-gray fill.
struct TraitPickerRow: View {
    let traitName:  String
    @Binding var value: Double   // 0–10, snaps to 1 / 3 / 5 / 7 / 9
    let options:    [String]     // exactly 5 short labels

    private static let snaps: [Double] = [1, 3, 5, 7, 9]

    private var segIndex: Int {
        let idx = Int(round((max(0, min(10, value)) - 1.0) / 2.0))
        return max(0, min(4, idx))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(traitName)
                .font(.subheadline.bold())
                .foregroundStyle(Color.appTextPrimary)

            // Scrollable pill row — long labels overflow gracefully
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(0..<min(5, options.count), id: \.self) { idx in
                        pillButton(index: idx)
                    }
                }
                .padding(.vertical, 2)   // breathing room so border/shadow isn't clipped
                .padding(.horizontal, 1)
            }
        }
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private func pillButton(index idx: Int) -> some View {
        let selected = idx == segIndex
        Button {
            withAnimation(.spring(response: 0.22, dampingFraction: 0.72)) {
                value = Self.snaps[idx]
            }
        } label: {
            Text(options[idx])
                .font(.subheadline)
                .fontWeight(selected ? .semibold : .regular)
                .foregroundStyle(selected ? Color.appPrimary : Color.appTextSecondary)
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                .background(
                    Capsule()
                        .fill(selected
                              ? Color.appPrimary.opacity(0.08)
                              : Color(hex: "#F1F2F4"))
                )
                .overlay(
                    Capsule()
                        .stroke(selected ? Color.appPrimary : Color.clear, lineWidth: 1.5)
                )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.22, dampingFraction: 0.72), value: selected)
    }
}
