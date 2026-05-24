import SwiftUI

// MARK: - Labelled trait slider row
struct TraitSliderRow: View {
    let traitName: String
    @Binding var value: Double
    let valueLabel: String

    var body: some View {
        VStack(spacing: 3) {
            HStack {
                Text(traitName)
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
                Spacer()
                Text(valueLabel)
                    .font(.caption.bold())
                    .foregroundStyle(Color.appPrimary)
                    .frame(minWidth: 90, alignment: .trailing)
                    .lineLimit(1)
            }
            Slider(value: $value, in: 0 ... 10)
                .tint(Color.appPrimary)
        }
        .padding(.bottom, 6)
    }
}
