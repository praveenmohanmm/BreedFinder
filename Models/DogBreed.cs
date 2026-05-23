using CommunityToolkit.Mvvm.ComponentModel;

namespace BreedFinder.Models;

public partial class DogBreed : ObservableObject
{
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Origin { get; set; } = string.Empty;
    public string Group { get; set; } = string.Empty;
    public string Emoji { get; set; } = "🐕";
    public string AccentColor { get; set; } = "#6366F1";
    public string DogCeoBreedKey { get; set; } = string.Empty;

    // Traits (0–10 scale)
    public double Size { get; set; }
    public double EnergyLevel { get; set; }
    public double Shedding { get; set; }
    public double Guardedness { get; set; }
    public double Aggressiveness { get; set; }
    public double Immunity { get; set; }
    public double Lifespan { get; set; }
    public double GroomingNeeds { get; set; }
    public double VetVisitsRequired { get; set; }
    public double Loyalty { get; set; }
    public double SingleOwner { get; set; }

    // Computed at match time
    public double MatchScore { get; set; }
    public string MatchPercentText => $"{(int)(MatchScore * 100)}%";

    // Image — observable so the card updates when the URL arrives from the API
    [ObservableProperty]
    [NotifyPropertyChangedFor(nameof(HasImage))]
    private string imageUrl = string.Empty;

    public bool HasImage => !string.IsNullOrEmpty(ImageUrl);

    public List<string> Tags { get; set; } = [];

    // Shows up to 2 tags as inline text on the compact grid card
    public string TagsDisplay => Tags.Count > 0
        ? string.Join("  ·  ", Tags.Take(2))
        : string.Empty;

    public void ComputeTags()
    {
        Tags.Clear();
        if (Aggressiveness <= 3 && EnergyLevel >= 5) Tags.Add("Family Friendly");
        if (Guardedness >= 7) Tags.Add("Guard Dog");
        if (EnergyLevel >= 8) Tags.Add("Very Active");
        else if (EnergyLevel <= 3) Tags.Add("Low Energy");
        if (Shedding <= 2) Tags.Add("Hypoallergenic");
        if (GroomingNeeds <= 2 && VetVisitsRequired <= 3) Tags.Add("Low Maintenance");
        if (Size <= 3) Tags.Add("Apartment Friendly");
        if (Aggressiveness <= 2 && Immunity >= 7) Tags.Add("Great for Beginners");
        if (Loyalty >= 9) Tags.Add("Highly Loyal");
        if (SingleOwner >= 7) Tags.Add("One-Person Dog");
        if (Lifespan >= 9) Tags.Add("Long Lifespan");
    }
}
