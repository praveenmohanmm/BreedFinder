import SwiftUI

// MARK: - Compact breed card (2-column grid cell)
struct BreedCard: View {
    let breed: DogBreed

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // ── Thumbnail ──────────────────────────────────────────────────────
            ZStack(alignment: .topTrailing) {
                Group {
                    if let urlStr = breed.imageUrl, let url = URL(string: urlStr) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let img):
                                img
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            default:
                                placeholder
                            }
                        }
                    } else {
                        placeholder
                    }
                }
                .frame(height: 128)
                .clipped()

                // Match-score badge
                Text("\(breed.matchPercent)%")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Color(hex: breed.accentHex).opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(7)
            }

            // ── Info strip ─────────────────────────────────────────────────────
            VStack(alignment: .leading, spacing: 3) {
                Text("\(breed.emoji)  \(breed.name)")
                    .font(.caption.bold())
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)

                if !breed.tagsDisplay.isEmpty {
                    Text(breed.tagsDisplay)
                        .font(.system(size: 9))
                        .foregroundStyle(Color.appPrimary)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 7)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.appPrimary.opacity(0.12), radius: 7, x: 0, y: 3)
    }

    // Placeholder shown before the image arrives
    private var placeholder: some View {
        ZStack {
            Color(hex: breed.accentHex).opacity(0.18)
            Text(breed.emoji)
                .font(.system(size: 42))
        }
    }
}
