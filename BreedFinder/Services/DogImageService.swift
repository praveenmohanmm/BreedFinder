import Foundation

// MARK: - Dog CEO image service
/// Actor that fetches random breed images from the Dog CEO API.
/// Caches results and deduplicates in-flight requests for the same key.
actor DogImageService {

    // ── State ─────────────────────────────────────────────────────────────────
    private var cache: [String: String] = [:]
    private var inFlight: [String: Task<String?, Never>] = [:]

    // ── Public API ────────────────────────────────────────────────────────────

    /// Returns a cached or freshly-fetched image URL for the given breed key.
    /// Returns `nil` if the key is empty or the request fails.
    func getImageUrl(for key: String) async -> String? {
        guard !key.isEmpty else { return nil }

        // Return from cache immediately
        if let cached = cache[key] { return cached }

        // Join an in-flight request for the same key
        if let task = inFlight[key] { return await task.value }

        // Start a new fetch
        let task = Task<String?, Never> {
            guard let url = URL(string: "https://dog.ceo/api/breed/\(key)/images/random") else {
                return nil
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response  = try JSONDecoder().decode(DogCeoResponse.self, from: data)
                return response.status == "success" ? response.message : nil
            } catch {
                return nil
            }
        }

        inFlight[key] = task
        let result = await task.value
        inFlight.removeValue(forKey: key)
        if let result { cache[key] = result }
        return result
    }

    /// Fire-and-forget pre-warm: kicks off fetches for all given keys so the
    /// cache is warm by the time the user taps "Find My Breed".
    func prewarm(keys: [String]) {
        for key in keys where !key.isEmpty && cache[key] == nil {
            Task { _ = await getImageUrl(for: key) }
        }
    }

    // ── Private ───────────────────────────────────────────────────────────────
    private struct DogCeoResponse: Decodable {
        let message: String
        let status: String
    }
}
