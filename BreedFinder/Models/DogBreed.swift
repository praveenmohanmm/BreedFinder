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

    // ── Core traits (0–10 scale) ──────────────────────────────────────────────
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

    // ── Human-centric traits (0–10 scale) ────────────────────────────────────
    /// How good with children (10 = perfect family dog)
    let kidsCompatibility: Double
    /// How well it gets along with other pets (10 = loves all animals)
    let petCompatibility: Double
    /// How well it handles being home alone (10 = very independent)
    let aloneTolerance: Double
    /// How much it barks (10 = very vocal)
    let barkingLevel: Double
    /// Ease of training (10 = learns in a heartbeat)
    let trainability: Double

    // ── Match-time state (mutated by BreedDatabase.getMatchingBreeds) ─────────
    var matchScore: Double = 0
    var imageUrl: String? = nil

    // ── Computed helpers ──────────────────────────────────────────────────────
    var matchPercent: Int { Int(matchScore * 100) }
    var hasImage: Bool { !(imageUrl?.isEmpty ?? true) }

    /// Tags derived purely from trait values — no mutable state needed.
    var tags: [String] {
        var result: [String] = []
        if kidsCompatibility >= 9                           { result.append("Great with Kids") }
        if petCompatibility >= 8                            { result.append("Good with Pets") }
        if trainability >= 9                                { result.append("Easy to Train") }
        if barkingLevel <= 3                                { result.append("Quiet Dog") }
        if aloneTolerance >= 7                              { result.append("Can Be Left Alone") }
        if guardedness >= 7                                 { result.append("Guard Dog") }
        if energyLevel >= 8                                 { result.append("Very Active") }
        else if energyLevel <= 3                            { result.append("Low Energy") }
        if shedding <= 2                                    { result.append("Hypoallergenic") }
        if groomingNeeds <= 2 && vetVisitsRequired <= 3    { result.append("Low Maintenance") }
        if size <= 3                                        { result.append("Apartment Friendly") }
        if loyalty >= 9                                     { result.append("Highly Loyal") }
        if lifespan >= 9                                    { result.append("Long Lifespan") }
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
        loyalty: Double, singleOwner: Double,
        kidsCompatibility: Double, petCompatibility: Double,
        aloneTolerance: Double, barkingLevel: Double, trainability: Double,
        imageUrl: String? = nil
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
        self.kidsCompatibility = kidsCompatibility
        self.petCompatibility = petCompatibility
        self.aloneTolerance = aloneTolerance
        self.barkingLevel = barkingLevel
        self.trainability = trainability
        self.imageUrl = imageUrl
    }
}
