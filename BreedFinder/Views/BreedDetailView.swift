import SwiftUI

// MARK: - Breed detail page
struct BreedDetailView: View {
    let breed: DogBreed
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                infoSection
                    .padding(20)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.appBackground)
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
    }

    // ── Hero image + name overlay ─────────────────────────────────────────────
    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            // Photo
            Group {
                if let urlStr = breed.imageUrl, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().aspectRatio(contentMode: .fill)
                        default:
                            heroPicker
                        }
                    }
                } else {
                    heroPicker
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 320)
            .clipped()

            // Scrim gradient
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: Color(hex: "#CC3D1F08"), location: 0.55),
                    .init(color: Color(hex: "#E03D1F08"), location: 1.0),
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Name + group overlay
            VStack(alignment: .leading, spacing: 5) {
                Text("\(breed.emoji)  \(breed.name)")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                HStack(spacing: 6) {
                    Label(breed.group, systemImage: "tag")
                    Text("·")
                    Label(breed.origin, systemImage: "mappin")
                }
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 22)
        }
    }

    private var heroPicker: some View {
        ZStack {
            Color(hex: breed.accentHex).opacity(0.25)
            Text(breed.emoji).font(.system(size: 90))
        }
    }

    // ── Body content ──────────────────────────────────────────────────────────
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 22) {
            // Match score pill
            if breed.matchPercent > 0 {
                HStack {
                    Image(systemName: "pawprint.fill")
                        .foregroundStyle(Color.appPrimary)
                    Text("Match score")
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                    Spacer()
                    Text("\(breed.matchPercent)% match")
                        .font(.headline.bold())
                        .foregroundStyle(Color.appPrimary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.appTagBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            divider

            // About
            VStack(alignment: .leading, spacing: 8) {
                sectionHeader("🐾 About")
                Text(breed.description)
                    .font(.body)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineSpacing(5)
            }

            // Highlights / tags
            if !breed.tags.isEmpty {
                divider
                VStack(alignment: .leading, spacing: 10) {
                    sectionHeader("⭐ Highlights")
                    FlowLayout(spacing: 8) {
                        ForEach(breed.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption.bold())
                                .foregroundStyle(Color.appPrimary)
                                .padding(.horizontal, 11)
                                .padding(.vertical, 5)
                                .background(Color.appTagBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.appBorder, lineWidth: 1)
                                )
                        }
                    }
                }
            }

            divider

            // Trait profile
            VStack(alignment: .leading, spacing: 12) {
                sectionHeader("🏅 Trait Profile")
                VStack(spacing: 10) {
                    TraitBarRow(label: "Size",              value: breed.size)
                    TraitBarRow(label: "Energy Level",      value: breed.energyLevel)
                    TraitBarRow(label: "Shedding",          value: breed.shedding)
                    TraitBarRow(label: "Guardedness",       value: breed.guardedness)
                    TraitBarRow(label: "Aggressiveness",    value: breed.aggressiveness)
                    TraitBarRow(label: "Immunity",          value: breed.immunity)
                    TraitBarRow(label: "Lifespan",          value: breed.lifespan)
                    TraitBarRow(label: "Grooming Needs",    value: breed.groomingNeeds)
                    TraitBarRow(label: "Vet Visits",        value: breed.vetVisitsRequired)
                    TraitBarRow(label: "Loyalty",           value: breed.loyalty)
                    TraitBarRow(label: "Single Owner",      value: breed.singleOwner)
                }
            }
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.appBorder)
            .frame(height: 1)
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.headline.bold())
            .foregroundStyle(Color.appTextPrimary)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        BreedDetailView(breed: BreedDatabase.all[0])
    }
}
