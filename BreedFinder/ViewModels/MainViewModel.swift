import Foundation
import Observation

// MARK: - Main view-model
@Observable
@MainActor
final class MainViewModel {

    // ── Sliders (0–10) — Living Situation ─────────────────────────────────────
    var sizeValue:           Double = 5
    var energyLevelValue:    Double = 5
    var aloneValue:          Double = 5   // alone tolerance

    // ── Sliders — Family & Social ─────────────────────────────────────────────
    var kidsValue:           Double = 5   // kids compatibility
    var petsValue:           Double = 5   // pet compatibility
    var singleOwnerValue:    Double = 5

    // ── Sliders — Personality ─────────────────────────────────────────────────
    var trainabilityValue:   Double = 5
    var barkingValue:        Double = 5   // barking level
    var guardednessValue:    Double = 5
    var aggressivenessValue: Double = 5
    var loyaltyValue:        Double = 5

    // ── Sliders — Care & Grooming ─────────────────────────────────────────────
    var sheddingValue:       Double = 5
    var groomingNeedsValue:  Double = 5

    // ── Sliders — Health & Lifespan ───────────────────────────────────────────
    var immunityValue:       Double = 5
    var lifespanValue:       Double = 5
    var vetVisitsValue:      Double = 5

    // ── Computed slider labels ────────────────────────────────────────────────
    var sizeLabel:           String { sizeText(sizeValue) }
    var energyLevelLabel:    String { energyText(energyLevelValue) }
    var aloneLabel:          String { aloneText(aloneValue) }
    var kidsLabel:           String { kidsText(kidsValue) }
    var petsLabel:           String { petsText(petsValue) }
    var singleOwnerLabel:    String { singleOwnerText(singleOwnerValue) }
    var trainabilityLabel:   String { trainabilityText(trainabilityValue) }
    var barkingLabel:        String { barkingText(barkingValue) }
    var guardednessLabel:    String { guardednessText(guardednessValue) }
    var aggressivenessLabel: String { aggressivenessText(aggressivenessValue) }
    var loyaltyLabel:        String { loyaltyText(loyaltyValue) }
    var sheddingLabel:       String { sheddingText(sheddingValue) }
    var groomingNeedsLabel:  String { groomingText(groomingNeedsValue) }
    var immunityLabel:       String { immunityText(immunityValue) }
    var lifespanLabel:       String { lifespanText(lifespanValue) }
    var vetVisitsLabel:      String { vetVisitsText(vetVisitsValue) }

    // ── Search ────────────────────────────────────────────────────────────────
    var searchText: String = ""

    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var searchResults: [DogBreed] {
        guard isSearching else { return [] }
        let q = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        return BreedDatabase.all
            .filter { $0.name.lowercased().contains(q) }
            .sorted {
                // Exact prefix matches float to the top
                let aP = $0.name.lowercased().hasPrefix(q)
                let bP = $1.name.lowercased().hasPrefix(q)
                if aP != bP { return aP }
                return $0.name < $1.name
            }
    }

    var searchHeader: String {
        let q  = searchText.trimmingCharacters(in: .whitespaces)
        let n  = searchResults.count
        guard n > 0 else { return "No breeds match \u{201C}\(q)\u{201D}" }
        return "\(n) breed\(n == 1 ? "" : "s") matching \u{201C}\(q)\u{201D}"
    }

    // ── Results state ─────────────────────────────────────────────────────────
    var matchingBreeds:   [DogBreed] = []
    var filtersExpanded:  Bool = true
    var isResultsVisible: Bool = false
    var isLoading:        Bool = false
    var resultsHeader:    String = ""

    // ── Private ───────────────────────────────────────────────────────────────
    private let imageService = DogImageService()

    // ── Init ──────────────────────────────────────────────────────────────────
    init() {
        // Pre-warm the image cache for all breeds in the background
        let keys = BreedDatabase.all.map(\.dogCeoBreedKey)
        let svc  = imageService
        Task.detached(priority: .background) {
            await svc.prewarm(keys: keys)
        }
    }

    // ── Commands ──────────────────────────────────────────────────────────────

    func findBreeds() async {
        isLoading        = true
        isResultsVisible = false
        filtersExpanded  = false

        // Capture slider values before hopping off the main actor
        let (s, e, sh, g, ag, im, li, gr, v, lo, si) = (
            sizeValue, energyLevelValue, sheddingValue,
            guardednessValue, aggressivenessValue, immunityValue,
            lifespanValue, groomingNeedsValue, vetVisitsValue,
            loyaltyValue, singleOwnerValue
        )
        let (ki, pe, al, ba, tr) = (
            kidsValue, petsValue, aloneValue, barkingValue, trainabilityValue
        )

        // Run CPU-bound matching off the main thread
        let results = await Task.detached(priority: .userInitiated) {
            BreedDatabase.getMatchingBreeds(
                size: s, energy: e, shedding: sh,
                guardedness: g, aggressiveness: ag, immunity: im,
                lifespan: li, grooming: gr, vetVisits: v,
                loyalty: lo, singleOwner: si,
                kidsCompat: ki, petCompat: pe, aloneToler: al,
                barking: ba, trainability: tr
            )
        }.value

        matchingBreeds   = results
        resultsHeader    = "\(results.count) breeds found — sorted by best match"
        isLoading        = false
        isResultsVisible = true

        // Fetch images in the background; cards update as URLs arrive
        fetchImages(for: results)
    }

    func resetFilters() {
        sizeValue = 5; energyLevelValue = 5; aloneValue = 5
        kidsValue = 5; petsValue = 5; singleOwnerValue = 5
        trainabilityValue = 5; barkingValue = 5
        guardednessValue = 5; aggressivenessValue = 5; loyaltyValue = 5
        sheddingValue = 5; groomingNeedsValue = 5
        immunityValue = 5; lifespanValue = 5; vetVisitsValue = 5
    }

    // ── Background image fetching ─────────────────────────────────────────────

    private func fetchImages(for breeds: [DogBreed]) {
        let svc = imageService   // capture actor reference (sendable)
        Task.detached(priority: .utility) { [weak self] in
            // Process in batches of 4
            let chunks = stride(from: 0, to: breeds.count, by: 4).map {
                Array(breeds[$0..<min($0 + 4, breeds.count)])
            }
            for chunk in chunks {
                await withTaskGroup(of: (UUID, String?).self) { group in
                    for breed in chunk {
                        group.addTask {
                            let url = await svc.getImageUrl(for: breed.dogCeoBreedKey)
                            return (breed.id, url)
                        }
                    }
                    for await (breedId, url) in group {
                        guard let url else { continue }
                        await self?.applyImageUrl(breedId: breedId, url: url)
                    }
                }
            }
        }
    }

    // Called from the detached task; hops to main actor automatically
    // because MainViewModel is @MainActor.
    private func applyImageUrl(breedId: UUID, url: String) {
        if let idx = matchingBreeds.firstIndex(where: { $0.id == breedId }) {
            matchingBreeds[idx].imageUrl = url
        }
    }

    // ── Label helpers ─────────────────────────────────────────────────────────

    private func sizeText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Tiny"
        case ..<4:  return "Small"
        case ..<6:  return "Medium"
        case ..<8:  return "Large"
        default:    return "Giant"
        }
    }
    private func energyText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Couch Potato"
        case ..<4:  return "Low Energy"
        case ..<6:  return "Moderate"
        case ..<8:  return "High Energy"
        default:    return "Hyperactive"
        }
    }
    private func aloneText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Never Alone"
        case ..<4:  return "Needs Company"
        case ..<6:  return "Short Periods"
        case ..<8:  return "Independent"
        default:    return "Very Independent"
        }
    }
    private func kidsText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Not for Kids"
        case ..<4:  return "Adults Only"
        case ..<6:  return "Older Kids OK"
        case ..<8:  return "Good with Kids"
        default:    return "Great with Kids"
        }
    }
    private func petsText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Needs Solo Home"
        case ..<4:  return "Selective"
        case ..<6:  return "Can Adapt"
        case ..<8:  return "Friendly"
        default:    return "Loves All Pets"
        }
    }
    private func singleOwnerText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Great with Everyone"
        case ..<4:  return "Family Dog"
        case ..<6:  return "Adapts to Family"
        case ..<8:  return "Prefers One Person"
        default:    return "One-Person Dog"
        }
    }
    private func trainabilityText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Very Stubborn"
        case ..<4:  return "Challenging"
        case ..<6:  return "Average"
        case ..<8:  return "Quick Learner"
        default:    return "Exceptionally Easy"
        }
    }
    private func barkingText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Nearly Silent"
        case ..<4:  return "Quiet"
        case ..<6:  return "Moderate"
        case ..<8:  return "Vocal"
        default:    return "Very Vocal"
        }
    }
    private func sheddingText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "None / Minimal"
        case ..<4:  return "Low"
        case ..<6:  return "Moderate"
        case ..<8:  return "High"
        default:    return "Heavy"
        }
    }
    private func guardednessText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Welcoming"
        case ..<4:  return "Friendly"
        case ..<6:  return "Watchful"
        case ..<8:  return "Protective"
        default:    return "Very Guarded"
        }
    }
    private func aggressivenessText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Very Gentle"
        case ..<4:  return "Calm"
        case ..<6:  return "Assertive"
        case ..<8:  return "Bold"
        default:    return "Very Dominant"
        }
    }
    private func immunityText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Fragile"
        case ..<4:  return "Below Average"
        case ..<6:  return "Average"
        case ..<8:  return "Robust"
        default:    return "Exceptional"
        }
    }
    private func lifespanText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Short (< 7 yrs)"
        case ..<4:  return "Below Average"
        case ..<6:  return "Average (10–12 yrs)"
        case ..<8:  return "Long (13–15 yrs)"
        default:    return "Very Long (16+ yrs)"
        }
    }
    private func groomingText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Minimal"
        case ..<4:  return "Occasional"
        case ..<6:  return "Regular"
        case ..<8:  return "Frequent"
        default:    return "Salon-Level"
        }
    }
    private func vetVisitsText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Rarely"
        case ..<4:  return "Occasional"
        case ..<6:  return "Routine"
        case ..<8:  return "Frequent"
        default:    return "Very Frequent"
        }
    }
    private func loyaltyText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Independent"
        case ..<4:  return "Somewhat Independent"
        case ..<6:  return "Balanced"
        case ..<8:  return "Very Loyal"
        default:    return "Devotedly Loyal"
        }
    }
}
