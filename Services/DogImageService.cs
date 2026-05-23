using System.Collections.Concurrent;
using System.Net.Http.Json;
using System.Text.Json.Serialization;

namespace BreedFinder.Services;

public interface IDogImageService
{
    Task<string> GetImageUrlAsync(string breedKey, CancellationToken ct = default);
    void PrewarmAsync(IEnumerable<string> breedKeys);
}

public class DogImageService : IDogImageService
{
    private readonly HttpClient _http;
    private readonly ConcurrentDictionary<string, string> _cache = new();

    public DogImageService(HttpClient http) => _http = http;

    public async Task<string> GetImageUrlAsync(string breedKey, CancellationToken ct = default)
    {
        if (string.IsNullOrEmpty(breedKey)) return string.Empty;
        if (_cache.TryGetValue(breedKey, out var cached)) return cached;

        try
        {
            var resp = await _http.GetFromJsonAsync<DogApiResponse>(
                $"https://dog.ceo/api/breed/{breedKey}/images/random", ct);

            var url = resp?.Message ?? string.Empty;
            if (!string.IsNullOrEmpty(url))
                _cache.TryAdd(breedKey, url);
            return url;
        }
        catch
        {
            return string.Empty;
        }
    }

    // Fire-and-forget pre-warm: fetch images for a list of keys in the background
    public void PrewarmAsync(IEnumerable<string> breedKeys)
    {
        _ = Task.Run(async () =>
        {
            using var semaphore = new SemaphoreSlim(4);
            var tasks = breedKeys.Select(async key =>
            {
                await semaphore.WaitAsync();
                try { await GetImageUrlAsync(key); }
                finally { semaphore.Release(); }
            });
            await Task.WhenAll(tasks);
        });
    }

    private sealed class DogApiResponse
    {
        [JsonPropertyName("message")] public string Message { get; set; } = string.Empty;
    }
}
