import Foundation

// MARK: - Dog Breed model
/// Value-type model that carries all static breed data plus mutable
/// match-time state (score and fetched image URL).
struct DogBreed: Identifiable, Equatable {

    // ── Identity ──────────────────────────────────────────────────────────────
    let id: UUID

    // ── Static data ───────────────────────────────────────────────────────────
    let name: String
    let description: String
    let origin: String
    let group: String
    let emoji: String
    /// Hex string e.g. "#E8892B" – used as the breed's accent tint
    let accentHex: String
    /// Path component(s) for the Dog CEO API, e.g. "retriever/golden"
    let dogCeoBreedKey: String

    // ── Traits (0–10 scale) ───────────────────────────────────────────────────
    let size: Double
    let energyLevel: Double
    let shedding: Double
    let guardedness: Double
    let aggressiveness: Double
    let immunity: Double
    let lifespan: Double
    let groomingNeeds: Double
    let vetVisitsRequired: Double
    let loyalty: Double
    let singleOwner: Double

    // ── Match-time state (mutated by BreedDatabase.getMatchingBreeds) ─────────
    var matchScore: Double = 0
    var imageUrl: String? = nil

    // ── Computed helpers ──────────────────────────────────────────────────────
    var matchPercent: Int { Int(matchScore * 100) }
    var hasImage: Bool { !(imageUrl?.isEmpty ?? true) }

    /// Tags derived purely from trait values — no mutable state needed.
    var tags: [String] {
        var result: [String] = []
        if aggressiveness <= 3 && energyLevel >= 5 { result.append("Family Friendly") }
        if guardedness >= 7                         { result.append("Guard Dog") }
        if energyLevel >= 8                         { result.append("Very Active") }
        else if energyLevel <= 3                    { result.append("Low Energy") }
        if shedding <= 2                            { result.append("Hypoallergenic") }
        if groomingNeeds <= 2 && vetVisitsRequired <= 3 { result.append("Low Maintenance") }
        if size <= 3                                { result.append("Apartment Friendly") }
        if aggressiveness <= 2 && immunity >= 7     { result.append("Great for Beginners") }
        if loyalty >= 9                             { result.append("Highly Loyal") }
        if singleOwner >= 7                         { result.append("One-Person Dog") }
        if lifespan >= 9                            { result.append("Long Lifespan") }
        return result
    }

    /// First two tags joined by " · " — shown on compact grid cards.
    var tagsDisplay: String {
        Array(tags.prefix(2)).joined(separator: "  ·  ")
    }

    static func == (lhs: DogBreed, rhs: DogBreed) -> Bool { lhs.id == rhs.id }

    // ── Convenience initialiser (auto-generates id) ───────────────────────────
    init(
        name: String, description: String, origin: String, group: String,
        emoji: String, accentHex: String, dogCeoBreedKey: String,
        size: Double, energyLevel: Double, shedding: Double,
        guardedness: Double, aggressiveness: Double, immunity: Double,
        lifespan: Double, groomingNeeds: Double, vetVisitsRequired: Double,
        loyalty: Double, singleOwner: Double
    ) {
        self.id = UUID()
        self.name = name; self.description = description
        self.origin = origin; self.group = group
        self.emoji = emoji; self.accentHex = accentHex
        self.dogCeoBreedKey = dogCeoBreedKey
        self.size = size; self.energyLevel = energyLevel
        self.shedding = shedding; self.guardedness = guardedness
        self.aggressiveness = aggressiveness; self.immunity = immunity
        self.lifespan = lifespan; self.groomingNeeds = groomingNeeds
        self.vetVisitsRequired = vetVisitsRequired
        self.loyalty = loyalty; self.singleOwner = singleOwner
    }
}
