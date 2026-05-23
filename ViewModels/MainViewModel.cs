using System.Collections.ObjectModel;
using BreedFinder.Models;
using BreedFinder.Services;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;

namespace BreedFinder.ViewModels;

public partial class MainViewModel : ObservableObject
{
    private readonly IBreedDataService _breedDataService;
    private readonly IDogImageService _imageService;

    // ── Slider fields (0–10) ──────────────────────────────────────────────────

    [ObservableProperty] private double sizeValue = 5;
    [ObservableProperty] private double energyLevelValue = 5;
    [ObservableProperty] private double sheddingValue = 5;
    [ObservableProperty] private double guardednessValue = 5;
    [ObservableProperty] private double aggressivenessValue = 5;
    [ObservableProperty] private double immunityValue = 5;
    [ObservableProperty] private double lifespanValue = 5;
    [ObservableProperty] private double groomingNeedsValue = 5;
    [ObservableProperty] private double vetVisitsValue = 5;
    [ObservableProperty] private double loyaltyValue = 5;
    [ObservableProperty] private double singleOwnerValue = 5;

    // ── Slider labels ─────────────────────────────────────────────────────────

    public string SizeLabel => GetSizeLabel(SizeValue);
    public string EnergyLevelLabel => GetEnergyLabel(EnergyLevelValue);
    public string SheddingLabel => GetSheddingLabel(SheddingValue);
    public string GuardednessLabel => GetGuardednessLabel(GuardednessValue);
    public string AggressivenessLabel => GetAggressivenessLabel(AggressivenessValue);
    public string ImmunityLabel => GetImmunityLabel(ImmunityValue);
    public string LifespanLabel => GetLifespanLabel(LifespanValue);
    public string GroomingNeedsLabel => GetGroomingLabel(GroomingNeedsValue);
    public string VetVisitsLabel => GetVetVisitsLabel(VetVisitsValue);
    public string LoyaltyLabel => GetLoyaltyLabel(LoyaltyValue);
    public string SingleOwnerLabel => GetSingleOwnerLabel(SingleOwnerValue);

    partial void OnSizeValueChanged(double value) => OnPropertyChanged(nameof(SizeLabel));
    partial void OnEnergyLevelValueChanged(double value) => OnPropertyChanged(nameof(EnergyLevelLabel));
    partial void OnSheddingValueChanged(double value) => OnPropertyChanged(nameof(SheddingLabel));
    partial void OnGuardednessValueChanged(double value) => OnPropertyChanged(nameof(GuardednessLabel));
    partial void OnAggressivenessValueChanged(double value) => OnPropertyChanged(nameof(AggressivenessLabel));
    partial void OnImmunityValueChanged(double value) => OnPropertyChanged(nameof(ImmunityLabel));
    partial void OnLifespanValueChanged(double value) => OnPropertyChanged(nameof(LifespanLabel));
    partial void OnGroomingNeedsValueChanged(double value) => OnPropertyChanged(nameof(GroomingNeedsLabel));
    partial void OnVetVisitsValueChanged(double value) => OnPropertyChanged(nameof(VetVisitsLabel));
    partial void OnLoyaltyValueChanged(double value) => OnPropertyChanged(nameof(LoyaltyLabel));
    partial void OnSingleOwnerValueChanged(double value) => OnPropertyChanged(nameof(SingleOwnerLabel));

    // ── Results state ─────────────────────────────────────────────────────────

    [ObservableProperty] private ObservableCollection<DogBreed> matchingBreeds = [];
    [ObservableProperty] private bool filtersExpanded = true;
    [ObservableProperty] private bool isResultsVisible;
    [ObservableProperty] private bool isLoading;
    [ObservableProperty] private string resultsHeader = string.Empty;
    [ObservableProperty] private DogBreed? selectedBreed;

    public bool IsNotLoading => !IsLoading;
    partial void OnIsLoadingChanged(bool value) => OnPropertyChanged(nameof(IsNotLoading));

    public MainViewModel(IBreedDataService breedDataService, IDogImageService imageService)
    {
        _breedDataService = breedDataService;
        _imageService = imageService;

        // Pre-warm the image cache in the background on app start
        _imageService.PrewarmAsync(_breedDataService.GetAllBreeds()
            .Select(b => b.DogCeoBreedKey)
            .Where(k => !string.IsNullOrEmpty(k)));
    }

    // ── Navigation ────────────────────────────────────────────────────────────

    partial void OnSelectedBreedChanged(DogBreed? value)
    {
        if (value is null) return;
        Shell.Current.GoToAsync("BreedDetailPage",
            new Dictionary<string, object> { ["Breed"] = value });
        SelectedBreed = null;
    }

    // ── Commands ──────────────────────────────────────────────────────────────

    [RelayCommand]
    private async Task FindBreedsAsync()
    {
        IsLoading = true;
        IsResultsVisible = false;
        FiltersExpanded = false;

        // Matching is CPU-bound; run off the UI thread
        var results = await Task.Run(() => _breedDataService.GetMatchingBreeds(
            SizeValue, EnergyLevelValue, SheddingValue,
            GuardednessValue, AggressivenessValue, ImmunityValue,
            LifespanValue, GroomingNeedsValue, VetVisitsValue,
            LoyaltyValue, SingleOwnerValue));

        MatchingBreeds.Clear();
        foreach (var b in results) MatchingBreeds.Add(b);

        ResultsHeader = $"{results.Count} breeds found — sorted by best match";
        IsLoading = false;
        IsResultsVisible = true;

        // Fetch images in the background; each breed's ImageUrl property fires
        // PropertyChanged so individual cards update as images arrive
        _ = FetchImagesAsync(results);
    }

    [RelayCommand]
    private void ResetFilters()
    {
        SizeValue = 5; EnergyLevelValue = 5; SheddingValue = 5;
        GuardednessValue = 5; AggressivenessValue = 5; ImmunityValue = 5;
        LifespanValue = 5; GroomingNeedsValue = 5; VetVisitsValue = 5;
        LoyaltyValue = 5; SingleOwnerValue = 5;
    }

    [RelayCommand]
    private void ToggleFilters() => FiltersExpanded = !FiltersExpanded;

    // ── Background image fetching ─────────────────────────────────────────────

    private async Task FetchImagesAsync(IReadOnlyList<DogBreed> breeds)
    {
        using var semaphore = new SemaphoreSlim(4, 4);
        var tasks = breeds.Select(async breed =>
        {
            await semaphore.WaitAsync();
            try
            {
                var url = await _imageService.GetImageUrlAsync(breed.DogCeoBreedKey);
                if (!string.IsNullOrEmpty(url))
                    breed.ImageUrl = url;
            }
            finally { semaphore.Release(); }
        });
        await Task.WhenAll(tasks);
    }

    // ── Label helpers ─────────────────────────────────────────────────────────

    private static string GetSizeLabel(double v) => v switch
    {
        <= 2 => "Tiny", <= 4 => "Small", <= 6 => "Medium", <= 8 => "Large", _ => "Giant"
    };
    private static string GetEnergyLabel(double v) => v switch
    {
        <= 2 => "Couch Potato", <= 4 => "Low Energy", <= 6 => "Moderate",
        <= 8 => "High Energy", _ => "Hyperactive"
    };
    private static string GetSheddingLabel(double v) => v switch
    {
        <= 2 => "None / Minimal", <= 4 => "Low", <= 6 => "Moderate", <= 8 => "High", _ => "Heavy"
    };
    private static string GetGuardednessLabel(double v) => v switch
    {
        <= 2 => "Welcoming", <= 4 => "Friendly", <= 6 => "Watchful",
        <= 8 => "Protective", _ => "Very Guarded"
    };
    private static string GetAggressivenessLabel(double v) => v switch
    {
        <= 2 => "Very Gentle", <= 4 => "Calm", <= 6 => "Assertive",
        <= 8 => "Bold", _ => "Very Dominant"
    };
    private static string GetImmunityLabel(double v) => v switch
    {
        <= 2 => "Fragile", <= 4 => "Below Average", <= 6 => "Average",
        <= 8 => "Robust", _ => "Exceptional"
    };
    private static string GetLifespanLabel(double v) => v switch
    {
        <= 2 => "Short (< 7 yrs)", <= 4 => "Below Average", <= 6 => "Average (10–12 yrs)",
        <= 8 => "Long (13–15 yrs)", _ => "Very Long (16+ yrs)"
    };
    private static string GetGroomingLabel(double v) => v switch
    {
        <= 2 => "Minimal", <= 4 => "Occasional", <= 6 => "Regular",
        <= 8 => "Frequent", _ => "Salon-Level"
    };
    private static string GetVetVisitsLabel(double v) => v switch
    {
        <= 2 => "Rarely", <= 4 => "Occasional", <= 6 => "Routine",
        <= 8 => "Frequent", _ => "Very Frequent"
    };
    private static string GetLoyaltyLabel(double v) => v switch
    {
        <= 2 => "Independent", <= 4 => "Somewhat Independent", <= 6 => "Balanced",
        <= 8 => "Very Loyal", _ => "Devotedly Loyal"
    };
    private static string GetSingleOwnerLabel(double v) => v switch
    {
        <= 2 => "Great with Everyone", <= 4 => "Family Dog", <= 6 => "Adapts to Family",
        <= 8 => "Prefers One Person", _ => "One-Person Dog"
    };
}
