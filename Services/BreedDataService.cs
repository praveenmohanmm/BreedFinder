using BreedFinder.Models;

namespace BreedFinder.Services;

public interface IBreedDataService
{
    IReadOnlyList<DogBreed> GetAllBreeds();
    List<DogBreed> GetMatchingBreeds(double size, double energy, double shedding,
        double guardedness, double aggressiveness, double immunity, double lifespan,
        double grooming, double vetVisits, double loyalty, double singleOwner);
}

public class BreedDataService : IBreedDataService
{
    private readonly List<DogBreed> _breeds;

    public BreedDataService()
    {
        _breeds = BuildBreedDatabase();
        foreach (var b in _breeds) b.ComputeTags();
    }

    public IReadOnlyList<DogBreed> GetAllBreeds() => _breeds.AsReadOnly();

    public List<DogBreed> GetMatchingBreeds(double size, double energy, double shedding,
        double guardedness, double aggressiveness, double immunity, double lifespan,
        double grooming, double vetVisits, double loyalty, double singleOwner)
    {
        foreach (var breed in _breeds)
        {
            double score = 1.0 - (
                Math.Abs(breed.Size - size) +
                Math.Abs(breed.EnergyLevel - energy) +
                Math.Abs(breed.Shedding - shedding) +
                Math.Abs(breed.Guardedness - guardedness) +
                Math.Abs(breed.Aggressiveness - aggressiveness) +
                Math.Abs(breed.Immunity - immunity) +
                Math.Abs(breed.Lifespan - lifespan) +
                Math.Abs(breed.GroomingNeeds - grooming) +
                Math.Abs(breed.VetVisitsRequired - vetVisits) +
                Math.Abs(breed.Loyalty - loyalty) +
                Math.Abs(breed.SingleOwner - singleOwner)
            ) / (11 * 10.0);

            breed.MatchScore = Math.Max(0, Math.Min(1, score));
            breed.ImageUrl = string.Empty; // reset so placeholder shows while new image loads
        }

        return [.. _breeds.OrderByDescending(b => b.MatchScore)];
    }

    private static List<DogBreed> BuildBreedDatabase() =>
    [
        new()
        {
            Name = "Labrador Retriever", DogCeoBreedKey = "labrador",
            Description = "America's most popular dog for decades — friendly, outgoing, and gentle. Labs are athletic, love water, and thrive with active families. They're highly trainable and eager to please.",
            Origin = "Canada", Group = "Sporting", Emoji = "🐕", AccentColor = "#F59E0B",
            Size = 7, EnergyLevel = 8, Shedding = 7, Guardedness = 5, Aggressiveness = 2,
            Immunity = 8, Lifespan = 7, GroomingNeeds = 3, VetVisitsRequired = 5, Loyalty = 9, SingleOwner = 4
        },
        new()
        {
            Name = "German Shepherd", DogCeoBreedKey = "germanshepherd",
            Description = "Highly intelligent and versatile working dog. German Shepherds excel in police, military, and service roles. They are deeply loyal to their family and naturally protective.",
            Origin = "Germany", Group = "Herding", Emoji = "🐺", AccentColor = "#92400E",
            Size = 8, EnergyLevel = 8, Shedding = 9, Guardedness = 9, Aggressiveness = 5,
            Immunity = 7, Lifespan = 7, GroomingNeeds = 5, VetVisitsRequired = 5, Loyalty = 9, SingleOwner = 7
        },
        new()
        {
            Name = "Golden Retriever", DogCeoBreedKey = "retriever/golden",
            Description = "Consistently one of the most beloved breeds worldwide. Goldens are patient, reliable, and joyful companions — perfect for families, therapy work, and search-and-rescue.",
            Origin = "Scotland", Group = "Sporting", Emoji = "🦮", AccentColor = "#D97706",
            Size = 7, EnergyLevel = 7, Shedding = 8, Guardedness = 4, Aggressiveness = 1,
            Immunity = 7, Lifespan = 7, GroomingNeeds = 6, VetVisitsRequired = 5, Loyalty = 9, SingleOwner = 3
        },
        new()
        {
            Name = "Poodle (Standard)", DogCeoBreedKey = "poodle/standard",
            Description = "One of the most intelligent breeds in the world. Poodles are hypoallergenic, highly trainable, and surprisingly athletic despite their elegant appearance.",
            Origin = "Germany/France", Group = "Non-Sporting", Emoji = "🐩", AccentColor = "#7C3AED",
            Size = 6, EnergyLevel = 7, Shedding = 1, Guardedness = 5, Aggressiveness = 2,
            Immunity = 8, Lifespan = 9, GroomingNeeds = 9, VetVisitsRequired = 4, Loyalty = 8, SingleOwner = 5
        },
        new()
        {
            Name = "Chihuahua", DogCeoBreedKey = "chihuahua",
            Description = "The world's smallest breed packs a big personality. Chihuahuas are confident, charming, and fiercely loyal to their person. They can be wary of strangers.",
            Origin = "Mexico", Group = "Toy", Emoji = "🐾", AccentColor = "#DC2626",
            Size = 1, EnergyLevel = 6, Shedding = 3, Guardedness = 7, Aggressiveness = 7,
            Immunity = 6, Lifespan = 10, GroomingNeeds = 2, VetVisitsRequired = 4, Loyalty = 9, SingleOwner = 9
        },
        new()
        {
            Name = "French Bulldog", DogCeoBreedKey = "bulldog/french",
            Description = "Playful, alert, and adaptable — Frenchies are ideal city dogs. They require minimal exercise but love to clown around and be the centre of attention.",
            Origin = "France", Group = "Non-Sporting", Emoji = "🐶", AccentColor = "#4B5563",
            Size = 3, EnergyLevel = 4, Shedding = 4, Guardedness = 4, Aggressiveness = 3,
            Immunity = 4, Lifespan = 6, GroomingNeeds = 2, VetVisitsRequired = 8, Loyalty = 8, SingleOwner = 6
        },
        new()
        {
            Name = "Bulldog", DogCeoBreedKey = "bulldog/english",
            Description = "Gentle, dignified, and courageous. Despite their tough looks, Bulldogs are calm and affectionate companions that love lounging and short walks.",
            Origin = "England", Group = "Non-Sporting", Emoji = "🐶", AccentColor = "#6B7280",
            Size = 5, EnergyLevel = 2, Shedding = 5, Guardedness = 5, Aggressiveness = 3,
            Immunity = 4, Lifespan = 5, GroomingNeeds = 2, VetVisitsRequired = 7, Loyalty = 7, SingleOwner = 5
        },
        new()
        {
            Name = "Beagle", DogCeoBreedKey = "beagle",
            Description = "Merry, friendly, and curious — Beagles follow their nose everywhere. They are great with children and other dogs, making them wonderful family pets.",
            Origin = "England", Group = "Hound", Emoji = "🐕", AccentColor = "#B45309",
            Size = 4, EnergyLevel = 7, Shedding = 5, Guardedness = 4, Aggressiveness = 2,
            Immunity = 8, Lifespan = 8, GroomingNeeds = 2, VetVisitsRequired = 4, Loyalty = 7, SingleOwner = 3
        },
        new()
        {
            Name = "Rottweiler", DogCeoBreedKey = "rottweiler",
            Description = "Robust, powerful, and loyal — Rottweilers are natural protectors. With proper socialisation they are calm and confident, devoted to their family.",
            Origin = "Germany", Group = "Working", Emoji = "🐕‍🦺", AccentColor = "#1F2937",
            Size = 9, EnergyLevel = 6, Shedding = 5, Guardedness = 9, Aggressiveness = 6,
            Immunity = 7, Lifespan = 6, GroomingNeeds = 3, VetVisitsRequired = 5, Loyalty = 9, SingleOwner = 8
        },
        new()
        {
            Name = "Yorkshire Terrier", DogCeoBreedKey = "yorkshire",
            Description = "Tiny but tenacious — Yorkies are spunky, affectionate, and surprisingly bold. Their silky hypoallergenic coat is beautiful but needs regular maintenance.",
            Origin = "England", Group = "Toy", Emoji = "🐾", AccentColor = "#A78BFA",
            Size = 1, EnergyLevel = 6, Shedding = 1, Guardedness = 6, Aggressiveness = 5,
            Immunity = 6, Lifespan = 9, GroomingNeeds = 9, VetVisitsRequired = 5, Loyalty = 8, SingleOwner = 7
        },
        new()
        {
            Name = "Siberian Husky", DogCeoBreedKey = "husky",
            Description = "Athletic and outgoing, Huskies are bred for endurance and teamwork. They are friendly, even with strangers, and have a mischievous independent streak.",
            Origin = "Russia", Group = "Working", Emoji = "🐺", AccentColor = "#2563EB",
            Size = 7, EnergyLevel = 10, Shedding = 10, Guardedness = 3, Aggressiveness = 3,
            Immunity = 9, Lifespan = 7, GroomingNeeds = 5, VetVisitsRequired = 3, Loyalty = 7, SingleOwner = 4
        },
        new()
        {
            Name = "Pomeranian", DogCeoBreedKey = "pomeranian",
            Description = "Lively and bold in a fluffy package. Pomeranians are inquisitive, active, and love being the star. Their fox-like face and thick coat draw constant admiration.",
            Origin = "Germany/Poland", Group = "Toy", Emoji = "🐾", AccentColor = "#EA580C",
            Size = 1, EnergyLevel = 7, Shedding = 6, Guardedness = 6, Aggressiveness = 4,
            Immunity = 7, Lifespan = 9, GroomingNeeds = 8, VetVisitsRequired = 4, Loyalty = 8, SingleOwner = 7
        },
        new()
        {
            Name = "Border Collie", DogCeoBreedKey = "collie/border",
            Description = "Widely regarded as the world's most intelligent dog. Border Collies are workaholics that need jobs to do — agility, herding, or advanced obedience.",
            Origin = "Scotland/England", Group = "Herding", Emoji = "🐕", AccentColor = "#065F46",
            Size = 5, EnergyLevel = 10, Shedding = 6, Guardedness = 5, Aggressiveness = 3,
            Immunity = 9, Lifespan = 8, GroomingNeeds = 5, VetVisitsRequired = 3, Loyalty = 9, SingleOwner = 6
        },
        new()
        {
            Name = "Shih Tzu", DogCeoBreedKey = "shihtzu",
            Description = "Bred to be a companion, the Shih Tzu is charming, outgoing, and trusting. Their luxurious coat is high-maintenance but they are wonderfully low-energy.",
            Origin = "China/Tibet", Group = "Toy", Emoji = "🐾", AccentColor = "#BE185D",
            Size = 2, EnergyLevel = 4, Shedding = 1, Guardedness = 4, Aggressiveness = 3,
            Immunity = 6, Lifespan = 9, GroomingNeeds = 10, VetVisitsRequired = 5, Loyalty = 8, SingleOwner = 6
        },
        new()
        {
            Name = "Great Dane", DogCeoBreedKey = "dane/great",
            Description = "A gentle giant with a majestic presence. Great Danes are friendly, patient, and dependable. They are surprisingly gentle with children despite their enormous size.",
            Origin = "Germany", Group = "Working", Emoji = "🐕", AccentColor = "#1D4ED8",
            Size = 10, EnergyLevel = 5, Shedding = 5, Guardedness = 7, Aggressiveness = 3,
            Immunity = 5, Lifespan = 4, GroomingNeeds = 2, VetVisitsRequired = 6, Loyalty = 8, SingleOwner = 5
        },
        new()
        {
            Name = "Australian Shepherd", DogCeoBreedKey = "australian/shepherd",
            Description = "Brilliant, energetic, and rugged — Aussies are happiest when they have a job. They are intensely loyal and thrive in active households with room to run.",
            Origin = "United States", Group = "Herding", Emoji = "🐕", AccentColor = "#7C3AED",
            Size = 6, EnergyLevel = 10, Shedding = 7, Guardedness = 6, Aggressiveness = 3,
            Immunity = 9, Lifespan = 8, GroomingNeeds = 6, VetVisitsRequired = 3, Loyalty = 9, SingleOwner = 5
        },
        new()
        {
            Name = "Maltese", DogCeoBreedKey = "maltese",
            Description = "Gentle, playful, and fearless — the Maltese is a classic lapdog with a glamorous white coat. They are highly adaptable and respond well to training.",
            Origin = "Malta", Group = "Toy", Emoji = "🐾", AccentColor = "#E879F9",
            Size = 1, EnergyLevel = 5, Shedding = 1, Guardedness = 4, Aggressiveness = 3,
            Immunity = 6, Lifespan = 9, GroomingNeeds = 9, VetVisitsRequired = 5, Loyalty = 9, SingleOwner = 7
        },
        new()
        {
            Name = "Doberman Pinscher", DogCeoBreedKey = "doberman",
            Description = "Elegant, fearless, and loyal. Dobermans are natural guard dogs with a keen intellect. Properly trained, they are affectionate family members and reliable protectors.",
            Origin = "Germany", Group = "Working", Emoji = "🐺", AccentColor = "#111827",
            Size = 8, EnergyLevel = 8, Shedding = 3, Guardedness = 10, Aggressiveness = 5,
            Immunity = 7, Lifespan = 7, GroomingNeeds = 2, VetVisitsRequired = 5, Loyalty = 10, SingleOwner = 8
        },
        new()
        {
            Name = "Dachshund", DogCeoBreedKey = "dachshund",
            Description = "Curious, friendly, and spunky. Dachshunds were bred to hunt badgers — their determination and bravery far exceed their small stature.",
            Origin = "Germany", Group = "Hound", Emoji = "🌭", AccentColor = "#92400E",
            Size = 2, EnergyLevel = 5, Shedding = 4, Guardedness = 6, Aggressiveness = 5,
            Immunity = 7, Lifespan = 8, GroomingNeeds = 2, VetVisitsRequired = 5, Loyalty = 8, SingleOwner = 6
        },
        new()
        {
            Name = "Pug", DogCeoBreedKey = "pug",
            Description = "Charming, mischievous, and loving. Pugs live to please and to be adored. Their wrinkled face and expressive eyes make them irresistible companions.",
            Origin = "China", Group = "Toy", Emoji = "🐾", AccentColor = "#D97706",
            Size = 3, EnergyLevel = 4, Shedding = 7, Guardedness = 3, Aggressiveness = 2,
            Immunity = 5, Lifespan = 6, GroomingNeeds = 2, VetVisitsRequired = 7, Loyalty = 8, SingleOwner = 6
        },
        new()
        {
            Name = "Boxer", DogCeoBreedKey = "boxer",
            Description = "Bright, fun-loving, and full of energy. Boxers are patient and protective with children, making them excellent family dogs. They stay playful well into adulthood.",
            Origin = "Germany", Group = "Working", Emoji = "🐕", AccentColor = "#B45309",
            Size = 7, EnergyLevel = 8, Shedding = 4, Guardedness = 7, Aggressiveness = 4,
            Immunity = 7, Lifespan = 6, GroomingNeeds = 2, VetVisitsRequired = 5, Loyalty = 9, SingleOwner = 6
        },
        new()
        {
            Name = "Saint Bernard", DogCeoBreedKey = "stbernard",
            Description = "Famous Alpine rescue dog. Saints are patient, gentle, and deeply affectionate. Their giant size is matched by a giant heart — wonderful with children.",
            Origin = "Switzerland", Group = "Working", Emoji = "🐕", AccentColor = "#991B1B",
            Size = 10, EnergyLevel = 4, Shedding = 8, Guardedness = 5, Aggressiveness = 2,
            Immunity = 7, Lifespan = 5, GroomingNeeds = 7, VetVisitsRequired = 6, Loyalty = 8, SingleOwner = 5
        },
        new()
        {
            Name = "Jack Russell Terrier", DogCeoBreedKey = "terrier/jack",
            Description = "Fearless, energetic, and clever. Jack Russells are full of personality and need plenty of stimulation. Best for experienced owners who enjoy an active lifestyle.",
            Origin = "England", Group = "Terrier", Emoji = "🐕", AccentColor = "#065F46",
            Size = 2, EnergyLevel = 10, Shedding = 4, Guardedness = 6, Aggressiveness = 6,
            Immunity = 9, Lifespan = 9, GroomingNeeds = 2, VetVisitsRequired = 3, Loyalty = 7, SingleOwner = 6
        },
        new()
        {
            Name = "Cocker Spaniel", DogCeoBreedKey = "spaniel/cocker",
            Description = "Merry and gentle, the Cocker Spaniel is a sweet-natured companion. They are sociable, easy to train, and get along well with everyone in the family.",
            Origin = "England", Group = "Sporting", Emoji = "🐕", AccentColor = "#92400E",
            Size = 4, EnergyLevel = 6, Shedding = 5, Guardedness = 4, Aggressiveness = 2,
            Immunity = 7, Lifespan = 8, GroomingNeeds = 8, VetVisitsRequired = 6, Loyalty = 8, SingleOwner = 5
        },
        new()
        {
            Name = "Weimaraner", DogCeoBreedKey = "weimaraner",
            Description = "Sleek, athletic, and aristocratic. Weimaraners are intensely loyal to their owners and need lots of exercise. They are happiest as true members of the household.",
            Origin = "Germany", Group = "Sporting", Emoji = "🐕", AccentColor = "#6B7280",
            Size = 8, EnergyLevel = 9, Shedding = 4, Guardedness = 7, Aggressiveness = 4,
            Immunity = 8, Lifespan = 7, GroomingNeeds = 2, VetVisitsRequired = 4, Loyalty = 9, SingleOwner = 7
        },
        new()
        {
            Name = "Miniature Schnauzer", DogCeoBreedKey = "schnauzer/miniature",
            Description = "Friendly, smart, and obedient. Miniature Schnauzers are spirited little dogs that are great with families. Their wiry coat sheds very little.",
            Origin = "Germany", Group = "Terrier", Emoji = "🐾", AccentColor = "#374151",
            Size = 2, EnergyLevel = 7, Shedding = 1, Guardedness = 7, Aggressiveness = 4,
            Immunity = 8, Lifespan = 9, GroomingNeeds = 7, VetVisitsRequired = 4, Loyalty = 8, SingleOwner = 6
        },
        new()
        {
            Name = "Cavalier King Charles Spaniel", DogCeoBreedKey = "spaniel/cavalier",
            Description = "Grace, gentleness, and charm define the Cavalier. They are supremely adaptable — equally happy in a flat or a country estate — and love snuggling.",
            Origin = "England", Group = "Toy", Emoji = "🐾", AccentColor = "#C2410C",
            Size = 3, EnergyLevel = 5, Shedding = 5, Guardedness = 3, Aggressiveness = 1,
            Immunity = 5, Lifespan = 7, GroomingNeeds = 5, VetVisitsRequired = 7, Loyalty = 9, SingleOwner = 5
        },
        new()
        {
            Name = "Akita", DogCeoBreedKey = "akita",
            Description = "Noble, courageous, and dignified — the Akita is a symbol of good health and loyalty in Japan. They are devoted to family but reserved with strangers.",
            Origin = "Japan", Group = "Working", Emoji = "🐺", AccentColor = "#C2410C",
            Size = 9, EnergyLevel = 6, Shedding = 8, Guardedness = 9, Aggressiveness = 6,
            Immunity = 8, Lifespan = 7, GroomingNeeds = 6, VetVisitsRequired = 4, Loyalty = 10, SingleOwner = 9
        },
        new()
        {
            Name = "Shiba Inu", DogCeoBreedKey = "shiba",
            Description = "Alert, agile, and bold. The Shiba Inu is Japan's most popular companion. Cat-like in independence but devoted to their family, known for the iconic 'Shiba scream'.",
            Origin = "Japan", Group = "Non-Sporting", Emoji = "🦊", AccentColor = "#EA580C",
            Size = 4, EnergyLevel = 7, Shedding = 7, Guardedness = 7, Aggressiveness = 5,
            Immunity = 9, Lifespan = 8, GroomingNeeds = 4, VetVisitsRequired = 3, Loyalty = 7, SingleOwner = 8
        },
        new()
        {
            Name = "Irish Setter", DogCeoBreedKey = "setter/irish",
            Description = "Outgoing, playful, and exuberant. Irish Setters are sociable with everyone and have an almost puppy-like enthusiasm that lasts their whole life.",
            Origin = "Ireland", Group = "Sporting", Emoji = "🐕", AccentColor = "#B91C1C",
            Size = 8, EnergyLevel = 9, Shedding = 5, Guardedness = 3, Aggressiveness = 2,
            Immunity = 8, Lifespan = 8, GroomingNeeds = 6, VetVisitsRequired = 4, Loyalty = 8, SingleOwner = 4
        },
    ];
}
