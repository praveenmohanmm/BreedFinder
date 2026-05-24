import Foundation
import Observation

// MARK: - Main view-model
@Observable
@MainActor
final class MainViewModel {

    // ── Sliders (0–10) ────────────────────────────────────────────────────────
    var sizeValue:           Double = 5
    var energyLevelValue:    Double = 5
    var sheddingValue:       Double = 5
    var guardednessValue:    Double = 5
    var aggressivenessValue: Double = 5
    var immunityValue:       Double = 5
    var lifespanValue:       Double = 5
    var groomingNeedsValue:  Double = 5
    var vetVisitsValue:      Double = 5
    var loyaltyValue:        Double = 5
    var singleOwnerValue:    Double = 5

    // ── Computed slider labels ────────────────────────────────────────────────
    var sizeLabel:            String { sizeText(sizeValue) }
    var energyLevelLabel:     String { energyText(energyLevelValue) }
    var sheddingLabel:        String { sheddingText(sheddingValue) }
    var guardednessLabel:     String { guardednessText(guardednessValue) }
    var aggressivenessLabel:  String { aggressivenessText(aggressivenessValue) }
    var immunityLabel:        String { immunityText(immunityValue) }
    var lifespanLabel:        String { lifespanText(lifespanValue) }
    var groomingNeedsLabel:   String { groomingText(groomingNeedsValue) }
    var vetVisitsLabel:       String { vetVisitsText(vetVisitsValue) }
    var loyaltyLabel:         String { loyaltyText(loyaltyValue) }
    var singleOwnerLabel:     String { singleOwnerText(singleOwnerValue) }

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

        // Run CPU-bound matching off the main thread
        let results = await Task.detached(priority: .userInitiated) {
            BreedDatabase.getMatchingBreeds(
                size: s, energy: e, shedding: sh,
                guardedness: g, aggressiveness: ag, immunity: im,
                lifespan: li, grooming: gr, vetVisits: v,
                loyalty: lo, singleOwner: si
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
        sizeValue = 5; energyLevelValue = 5; sheddingValue = 5
        guardednessValue = 5; aggressivenessValue = 5; immunityValue = 5
        lifespanValue = 5; groomingNeedsValue = 5; vetVisitsValue = 5
        loyaltyValue = 5; singleOwnerValue = 5
    }

    // ── Background image fetching ─────────────────────────────────────────────

    private func fetchImages(for breeds: [DogBreed]) {
        let svc = imageService   // capture actor reference (sendable)
        Task.detached(priority: .utility) { [weak self] in
            // Process in batches of 4 (mirrors the SemaphoreSlim(4,4) in MAUI)
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
    private func singleOwnerText(_ v: Double) -> String {
        switch v {
        case ..<2:  return "Great with Everyone"
        case ..<4:  return "Family Dog"
        case ..<6:  return "Adapts to Family"
        case ..<8:  return "Prefers One Person"
        default:    return "One-Person Dog"
        }
    }
}
