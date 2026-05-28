import Foundation

// MARK: - Breed database + matching logic
enum BreedDatabase {

    // MARK: All breeds
    // imageUrl values are stable dog.ceo CDN paths — verified working 2025-05.
    // dogCeoBreedKey is the dog.ceo API path used by DogImageService for refresh.
    static let all: [DogBreed] = [
        DogBreed(
            name: "Labrador Retriever",
            description: "America's most popular dog for decades — friendly, outgoing, and gentle. Labs are athletic, love water, and thrive with active families. They're highly trainable and eager to please.",
            origin: "Canada", group: "Sporting", emoji: "🐕", accentHex: "#F59E0B",
            dogCeoBreedKey: "labrador",
            size: 7, energyLevel: 8, shedding: 7, guardedness: 5, aggressiveness: 2,
            immunity: 8, lifespan: 7, groomingNeeds: 3, vetVisitsRequired: 5, loyalty: 9, singleOwner: 4,
            kidsCompatibility: 10, petCompatibility: 9, aloneTolerance: 6, barkingLevel: 4, trainability: 10,
            imageUrl: "https://images.dog.ceo/breeds/labrador/n02099712_7411.jpg"
        ),
        DogBreed(
            name: "German Shepherd",
            description: "Highly intelligent and versatile working dog. German Shepherds excel in police, military, and service roles. They are deeply loyal to their family and naturally protective.",
            origin: "Germany", group: "Herding", emoji: "🐺", accentHex: "#92400E",
            dogCeoBreedKey: "german/shepherd",
            size: 8, energyLevel: 8, shedding: 9, guardedness: 9, aggressiveness: 5,
            immunity: 7, lifespan: 7, groomingNeeds: 5, vetVisitsRequired: 5, loyalty: 9, singleOwner: 7,
            kidsCompatibility: 7, petCompatibility: 5, aloneTolerance: 5, barkingLevel: 6, trainability: 10,
            imageUrl: "https://images.dog.ceo/breeds/german-shepherd/n02106662_18405.jpg"
        ),
        DogBreed(
            name: "Golden Retriever",
            description: "Consistently one of the most beloved breeds worldwide. Goldens are patient, reliable, and joyful companions — perfect for families, therapy work, and search-and-rescue.",
            origin: "Scotland", group: "Sporting", emoji: "🦮", accentHex: "#D97706",
            dogCeoBreedKey: "retriever/golden",
            size: 7, energyLevel: 7, shedding: 8, guardedness: 4, aggressiveness: 1,
            immunity: 7, lifespan: 7, groomingNeeds: 6, vetVisitsRequired: 5, loyalty: 9, singleOwner: 3,
            kidsCompatibility: 10, petCompatibility: 9, aloneTolerance: 5, barkingLevel: 4, trainability: 10,
            imageUrl: "https://images.dog.ceo/breeds/retriever-golden/n02099601_8429.jpg"
        ),
        DogBreed(
            name: "Poodle (Standard)",
            description: "One of the most intelligent breeds in the world. Poodles are hypoallergenic, highly trainable, and surprisingly athletic despite their elegant appearance.",
            origin: "Germany/France", group: "Non-Sporting", emoji: "🐩", accentHex: "#7C3AED",
            dogCeoBreedKey: "poodle/standard",
            size: 6, energyLevel: 7, shedding: 1, guardedness: 5, aggressiveness: 2,
            immunity: 8, lifespan: 9, groomingNeeds: 9, vetVisitsRequired: 4, loyalty: 8, singleOwner: 5,
            kidsCompatibility: 8, petCompatibility: 8, aloneTolerance: 6, barkingLevel: 5, trainability: 10,
            imageUrl: "https://images.dog.ceo/breeds/poodle-standard/n02113799_6045.jpg"
        ),
        DogBreed(
            name: "Chihuahua",
            description: "The world's smallest breed packs a big personality. Chihuahuas are confident, charming, and fiercely loyal to their person. They can be wary of strangers.",
            origin: "Mexico", group: "Toy", emoji: "🐾", accentHex: "#DC2626",
            dogCeoBreedKey: "chihuahua",
            size: 1, energyLevel: 6, shedding: 3, guardedness: 7, aggressiveness: 7,
            immunity: 6, lifespan: 10, groomingNeeds: 2, vetVisitsRequired: 4, loyalty: 9, singleOwner: 9,
            kidsCompatibility: 3, petCompatibility: 3, aloneTolerance: 5, barkingLevel: 8, trainability: 4,
            imageUrl: "https://images.dog.ceo/breeds/chihuahua/n02085620_2815.jpg"
        ),
        DogBreed(
            name: "French Bulldog",
            description: "Playful, alert, and adaptable — Frenchies are ideal city dogs. They require minimal exercise but love to clown around and be the centre of attention.",
            origin: "France", group: "Non-Sporting", emoji: "🐶", accentHex: "#4B5563",
            dogCeoBreedKey: "bulldog/french",
            size: 3, energyLevel: 4, shedding: 4, guardedness: 4, aggressiveness: 3,
            immunity: 4, lifespan: 6, groomingNeeds: 2, vetVisitsRequired: 8, loyalty: 8, singleOwner: 6,
            kidsCompatibility: 8, petCompatibility: 7, aloneTolerance: 5, barkingLevel: 4, trainability: 6,
            imageUrl: "https://images.dog.ceo/breeds/bulldog-french/n02108915_3880.jpg"
        ),
        DogBreed(
            name: "Bulldog",
            description: "Gentle, dignified, and courageous. Despite their tough looks, Bulldogs are calm and affectionate companions that love lounging and short walks.",
            origin: "England", group: "Non-Sporting", emoji: "🐶", accentHex: "#6B7280",
            dogCeoBreedKey: "bulldog/english",
            size: 5, energyLevel: 2, shedding: 5, guardedness: 5, aggressiveness: 3,
            immunity: 4, lifespan: 5, groomingNeeds: 2, vetVisitsRequired: 7, loyalty: 7, singleOwner: 5,
            kidsCompatibility: 8, petCompatibility: 6, aloneTolerance: 5, barkingLevel: 3, trainability: 5,
            imageUrl: "https://images.dog.ceo/breeds/bulldog-english/jager-2.jpg"
        ),
        DogBreed(
            name: "Beagle",
            description: "Merry, friendly, and curious — Beagles follow their nose everywhere. They are great with children and other dogs, making them wonderful family pets.",
            origin: "England", group: "Hound", emoji: "🐕", accentHex: "#B45309",
            dogCeoBreedKey: "beagle",
            size: 4, energyLevel: 7, shedding: 5, guardedness: 4, aggressiveness: 2,
            immunity: 8, lifespan: 8, groomingNeeds: 2, vetVisitsRequired: 4, loyalty: 7, singleOwner: 3,
            kidsCompatibility: 9, petCompatibility: 8, aloneTolerance: 3, barkingLevel: 9, trainability: 5,
            imageUrl: "https://images.dog.ceo/breeds/beagle/n02088364_11130.jpg"
        ),
        DogBreed(
            name: "Rottweiler",
            description: "Robust, powerful, and loyal — Rottweilers are natural protectors. With proper socialisation they are calm and confident, devoted to their family.",
            origin: "Germany", group: "Working", emoji: "🐕‍🦺", accentHex: "#1F2937",
            dogCeoBreedKey: "rottweiler",
            size: 9, energyLevel: 6, shedding: 5, guardedness: 9, aggressiveness: 6,
            immunity: 7, lifespan: 6, groomingNeeds: 3, vetVisitsRequired: 5, loyalty: 9, singleOwner: 8,
            kidsCompatibility: 7, petCompatibility: 5, aloneTolerance: 5, barkingLevel: 5, trainability: 8,
            imageUrl: "https://images.dog.ceo/breeds/rottweiler/n02106550_4987.jpg"
        ),
        DogBreed(
            name: "Yorkshire Terrier",
            description: "Tiny but tenacious — Yorkies are spunky, affectionate, and surprisingly bold. Their silky hypoallergenic coat is beautiful but needs regular maintenance.",
            origin: "England", group: "Toy", emoji: "🐾", accentHex: "#A78BFA",
            dogCeoBreedKey: "terrier/yorkshire",
            size: 1, energyLevel: 6, shedding: 1, guardedness: 6, aggressiveness: 5,
            immunity: 6, lifespan: 9, groomingNeeds: 9, vetVisitsRequired: 5, loyalty: 8, singleOwner: 7,
            kidsCompatibility: 4, petCompatibility: 4, aloneTolerance: 4, barkingLevel: 8, trainability: 5,
            imageUrl: "https://images.dog.ceo/breeds/terrier-yorkshire/n02094433_3198.jpg"
        ),
        DogBreed(
            name: "Siberian Husky",
            description: "Athletic and outgoing, Huskies are bred for endurance and teamwork. They are friendly, even with strangers, and have a mischievous independent streak.",
            origin: "Russia", group: "Working", emoji: "🐺", accentHex: "#2563EB",
            dogCeoBreedKey: "husky",
            size: 7, energyLevel: 10, shedding: 10, guardedness: 3, aggressiveness: 3,
            immunity: 9, lifespan: 7, groomingNeeds: 5, vetVisitsRequired: 3, loyalty: 7, singleOwner: 4,
            kidsCompatibility: 8, petCompatibility: 7, aloneTolerance: 3, barkingLevel: 7, trainability: 5,
            imageUrl: "https://images.dog.ceo/breeds/husky/n02110185_1532.jpg"
        ),
        DogBreed(
            name: "Pomeranian",
            description: "Lively and bold in a fluffy package. Pomeranians are inquisitive, active, and love being the star. Their fox-like face and thick coat draw constant admiration.",
            origin: "Germany/Poland", group: "Toy", emoji: "🐾", accentHex: "#EA580C",
            dogCeoBreedKey: "pomeranian",
            size: 1, energyLevel: 7, shedding: 6, guardedness: 6, aggressiveness: 4,
            immunity: 7, lifespan: 9, groomingNeeds: 8, vetVisitsRequired: 4, loyalty: 8, singleOwner: 7,
            kidsCompatibility: 5, petCompatibility: 5, aloneTolerance: 4, barkingLevel: 9, trainability: 6,
            imageUrl: "https://images.dog.ceo/breeds/pomeranian/n02112018_4035.jpg"
        ),
        DogBreed(
            name: "Border Collie",
            description: "Widely regarded as the world's most intelligent dog. Border Collies are workaholics that need jobs to do — agility, herding, or advanced obedience.",
            origin: "Scotland/England", group: "Herding", emoji: "🐕", accentHex: "#065F46",
            dogCeoBreedKey: "collie/border",
            size: 5, energyLevel: 10, shedding: 6, guardedness: 5, aggressiveness: 3,
            immunity: 9, lifespan: 8, groomingNeeds: 5, vetVisitsRequired: 3, loyalty: 9, singleOwner: 6,
            kidsCompatibility: 7, petCompatibility: 6, aloneTolerance: 4, barkingLevel: 5, trainability: 10,
            imageUrl: "https://images.dog.ceo/breeds/collie-border/n02106166_1429.jpg"
        ),
        DogBreed(
            name: "Shih Tzu",
            description: "Bred to be a companion, the Shih Tzu is charming, outgoing, and trusting. Their luxurious coat is high-maintenance but they are wonderfully low-energy.",
            origin: "China/Tibet", group: "Toy", emoji: "🐾", accentHex: "#BE185D",
            dogCeoBreedKey: "shihtzu",
            size: 2, energyLevel: 4, shedding: 1, guardedness: 4, aggressiveness: 3,
            immunity: 6, lifespan: 9, groomingNeeds: 10, vetVisitsRequired: 5, loyalty: 8, singleOwner: 6,
            kidsCompatibility: 7, petCompatibility: 7, aloneTolerance: 5, barkingLevel: 6, trainability: 6,
            imageUrl: "https://images.dog.ceo/breeds/shihtzu/n02086240_5546.jpg"
        ),
        DogBreed(
            name: "Great Dane",
            description: "A gentle giant with a majestic presence. Great Danes are friendly, patient, and dependable. They are surprisingly gentle with children despite their enormous size.",
            origin: "Germany", group: "Working", emoji: "🐕", accentHex: "#1D4ED8",
            dogCeoBreedKey: "dane/great",
            size: 10, energyLevel: 5, shedding: 5, guardedness: 7, aggressiveness: 3,
            immunity: 5, lifespan: 4, groomingNeeds: 2, vetVisitsRequired: 6, loyalty: 8, singleOwner: 5,
            kidsCompatibility: 9, petCompatibility: 7, aloneTolerance: 5, barkingLevel: 4, trainability: 7,
            imageUrl: "https://images.dog.ceo/breeds/dane-great/n02109047_34175.jpg"
        ),
        DogBreed(
            name: "Australian Shepherd",
            description: "Brilliant, energetic, and rugged — Aussies are happiest when they have a job. They are intensely loyal and thrive in active households with room to run.",
            origin: "United States", group: "Herding", emoji: "🐕", accentHex: "#7C3AED",
            dogCeoBreedKey: "australian/shepherd",
            size: 6, energyLevel: 10, shedding: 7, guardedness: 6, aggressiveness: 3,
            immunity: 9, lifespan: 8, groomingNeeds: 6, vetVisitsRequired: 3, loyalty: 9, singleOwner: 5,
            kidsCompatibility: 8, petCompatibility: 7, aloneTolerance: 3, barkingLevel: 6, trainability: 10,
            imageUrl: "https://images.dog.ceo/breeds/australian-shepherd/sadie.jpg"
        ),
        DogBreed(
            name: "Maltese",
            description: "Gentle, playful, and fearless — the Maltese is a classic lapdog with a glamorous white coat. They are highly adaptable and respond well to training.",
            origin: "Malta", group: "Toy", emoji: "🐾", accentHex: "#E879F9",
            dogCeoBreedKey: "maltese",
            size: 1, energyLevel: 5, shedding: 1, guardedness: 4, aggressiveness: 3,
            immunity: 6, lifespan: 9, groomingNeeds: 9, vetVisitsRequired: 5, loyalty: 9, singleOwner: 7,
            kidsCompatibility: 6, petCompatibility: 6, aloneTolerance: 4, barkingLevel: 7, trainability: 7,
            imageUrl: "https://images.dog.ceo/breeds/maltese/n02085936_37.jpg"
        ),
        DogBreed(
            name: "Doberman Pinscher",
            description: "Elegant, fearless, and loyal. Dobermans are natural guard dogs with a keen intellect. Properly trained, they are affectionate family members and reliable protectors.",
            origin: "Germany", group: "Working", emoji: "🐺", accentHex: "#111827",
            dogCeoBreedKey: "doberman",
            size: 8, energyLevel: 8, shedding: 3, guardedness: 10, aggressiveness: 5,
            immunity: 7, lifespan: 7, groomingNeeds: 2, vetVisitsRequired: 5, loyalty: 10, singleOwner: 8,
            kidsCompatibility: 7, petCompatibility: 4, aloneTolerance: 4, barkingLevel: 5, trainability: 9,
            imageUrl: "https://images.dog.ceo/breeds/doberman/n02107142_2213.jpg"
        ),
        DogBreed(
            name: "Dachshund",
            description: "Curious, friendly, and spunky. Dachshunds were bred to hunt badgers — their determination and bravery far exceed their small stature.",
            origin: "Germany", group: "Hound", emoji: "🌭", accentHex: "#92400E",
            dogCeoBreedKey: "dachshund",
            size: 2, energyLevel: 5, shedding: 4, guardedness: 6, aggressiveness: 5,
            immunity: 7, lifespan: 8, groomingNeeds: 2, vetVisitsRequired: 5, loyalty: 8, singleOwner: 6,
            kidsCompatibility: 6, petCompatibility: 5, aloneTolerance: 4, barkingLevel: 8, trainability: 5,
            imageUrl: "https://images.dog.ceo/breeds/dachshund/reese.jpg"
        ),
        DogBreed(
            name: "Pug",
            description: "Charming, mischievous, and loving. Pugs live to please and to be adored. Their wrinkled face and expressive eyes make them irresistible companions.",
            origin: "China", group: "Toy", emoji: "🐾", accentHex: "#D97706",
            dogCeoBreedKey: "pug",
            size: 3, energyLevel: 4, shedding: 7, guardedness: 3, aggressiveness: 2,
            immunity: 5, lifespan: 6, groomingNeeds: 2, vetVisitsRequired: 7, loyalty: 8, singleOwner: 6,
            kidsCompatibility: 8, petCompatibility: 7, aloneTolerance: 6, barkingLevel: 4, trainability: 5,
            imageUrl: "https://images.dog.ceo/breeds/pug/n02110958_13995.jpg"
        ),
        DogBreed(
            name: "Boxer",
            description: "Bright, fun-loving, and full of energy. Boxers are patient and protective with children, making them excellent family dogs. They stay playful well into adulthood.",
            origin: "Germany", group: "Working", emoji: "🐕", accentHex: "#B45309",
            dogCeoBreedKey: "boxer",
            size: 7, energyLevel: 8, shedding: 4, guardedness: 7, aggressiveness: 4,
            immunity: 7, lifespan: 6, groomingNeeds: 2, vetVisitsRequired: 5, loyalty: 9, singleOwner: 6,
            kidsCompatibility: 10, petCompatibility: 7, aloneTolerance: 5, barkingLevel: 5, trainability: 7,
            imageUrl: "https://images.dog.ceo/breeds/boxer/n02108089_5977.jpg"
        ),
        DogBreed(
            name: "Saint Bernard",
            description: "Famous Alpine rescue dog. Saints are patient, gentle, and deeply affectionate. Their giant size is matched by a giant heart — wonderful with children.",
            origin: "Switzerland", group: "Working", emoji: "🐕", accentHex: "#991B1B",
            dogCeoBreedKey: "stbernard",
            size: 10, energyLevel: 4, shedding: 8, guardedness: 5, aggressiveness: 2,
            immunity: 7, lifespan: 5, groomingNeeds: 7, vetVisitsRequired: 6, loyalty: 8, singleOwner: 5,
            kidsCompatibility: 10, petCompatibility: 8, aloneTolerance: 5, barkingLevel: 3, trainability: 7,
            imageUrl: "https://images.dog.ceo/breeds/stbernard/n02109525_13420.jpg"
        ),
        DogBreed(
            name: "Jack Russell Terrier",
            description: "Fearless, energetic, and clever. Jack Russells are full of personality and need plenty of stimulation. Best for experienced owners who enjoy an active lifestyle.",
            origin: "England", group: "Terrier", emoji: "🐕", accentHex: "#065F46",
            dogCeoBreedKey: "terrier/russell",
            size: 2, energyLevel: 10, shedding: 4, guardedness: 6, aggressiveness: 6,
            immunity: 9, lifespan: 9, groomingNeeds: 2, vetVisitsRequired: 3, loyalty: 7, singleOwner: 6,
            kidsCompatibility: 5, petCompatibility: 3, aloneTolerance: 4, barkingLevel: 7, trainability: 6,
            imageUrl: "https://images.dog.ceo/breeds/terrier-russell/IMG_7489.jpg"
        ),
        DogBreed(
            name: "Cocker Spaniel",
            description: "Merry and gentle, the Cocker Spaniel is a sweet-natured companion. They are sociable, easy to train, and get along well with everyone in the family.",
            origin: "England", group: "Sporting", emoji: "🐕", accentHex: "#92400E",
            dogCeoBreedKey: "spaniel/cocker",
            size: 4, energyLevel: 6, shedding: 5, guardedness: 4, aggressiveness: 2,
            immunity: 7, lifespan: 8, groomingNeeds: 8, vetVisitsRequired: 6, loyalty: 8, singleOwner: 5,
            kidsCompatibility: 8, petCompatibility: 7, aloneTolerance: 4, barkingLevel: 6, trainability: 8,
            imageUrl: "https://images.dog.ceo/breeds/spaniel-cocker/n02102318_10000.jpg"
        ),
        DogBreed(
            name: "Weimaraner",
            description: "Sleek, athletic, and aristocratic. Weimaraners are intensely loyal to their owners and need lots of exercise. They are happiest as true members of the household.",
            origin: "Germany", group: "Sporting", emoji: "🐕", accentHex: "#6B7280",
            dogCeoBreedKey: "weimaraner",
            size: 8, energyLevel: 9, shedding: 4, guardedness: 7, aggressiveness: 4,
            immunity: 8, lifespan: 7, groomingNeeds: 2, vetVisitsRequired: 4, loyalty: 9, singleOwner: 7,
            kidsCompatibility: 8, petCompatibility: 5, aloneTolerance: 3, barkingLevel: 5, trainability: 8,
            imageUrl: "https://images.dog.ceo/breeds/weimaraner/n02092339_6543.jpg"
        ),
        DogBreed(
            name: "Miniature Schnauzer",
            description: "Friendly, smart, and obedient. Miniature Schnauzers are spirited little dogs that are great with families. Their wiry coat sheds very little.",
            origin: "Germany", group: "Terrier", emoji: "🐾", accentHex: "#374151",
            dogCeoBreedKey: "schnauzer/miniature",
            size: 2, energyLevel: 7, shedding: 1, guardedness: 7, aggressiveness: 4,
            immunity: 8, lifespan: 9, groomingNeeds: 7, vetVisitsRequired: 4, loyalty: 8, singleOwner: 6,
            kidsCompatibility: 8, petCompatibility: 6, aloneTolerance: 5, barkingLevel: 7, trainability: 8,
            imageUrl: "https://images.dog.ceo/breeds/schnauzer-miniature/n02097047_1556.jpg"
        ),
        DogBreed(
            name: "Cavalier King Charles Spaniel",
            description: "Grace, gentleness, and charm define the Cavalier. They are supremely adaptable — equally happy in a flat or a country estate — and love snuggling.",
            origin: "England", group: "Toy", emoji: "🐾", accentHex: "#C2410C",
            dogCeoBreedKey: "spaniel/blenheim",
            size: 3, energyLevel: 5, shedding: 5, guardedness: 3, aggressiveness: 1,
            immunity: 5, lifespan: 7, groomingNeeds: 5, vetVisitsRequired: 7, loyalty: 9, singleOwner: 5,
            kidsCompatibility: 9, petCompatibility: 9, aloneTolerance: 3, barkingLevel: 4, trainability: 8,
            imageUrl: "https://images.dog.ceo/breeds/spaniel-blenheim/n02086646_593.jpg"
        ),
        DogBreed(
            name: "Akita",
            description: "Noble, courageous, and dignified — the Akita is a symbol of good health and loyalty in Japan. They are devoted to family but reserved with strangers.",
            origin: "Japan", group: "Working", emoji: "🐺", accentHex: "#C2410C",
            dogCeoBreedKey: "akita",
            size: 9, energyLevel: 6, shedding: 8, guardedness: 9, aggressiveness: 6,
            immunity: 8, lifespan: 7, groomingNeeds: 6, vetVisitsRequired: 4, loyalty: 10, singleOwner: 9,
            kidsCompatibility: 5, petCompatibility: 3, aloneTolerance: 6, barkingLevel: 4, trainability: 6,
            imageUrl: "https://images.dog.ceo/breeds/akita/Akita_inu_blanc.jpg"
        ),
        DogBreed(
            name: "Shiba Inu",
            description: "Alert, agile, and bold. The Shiba Inu is Japan's most popular companion. Cat-like in independence but devoted to their family, known for the iconic 'Shiba scream'.",
            origin: "Japan", group: "Non-Sporting", emoji: "🦊", accentHex: "#EA580C",
            dogCeoBreedKey: "shiba",
            size: 4, energyLevel: 7, shedding: 7, guardedness: 7, aggressiveness: 5,
            immunity: 9, lifespan: 8, groomingNeeds: 4, vetVisitsRequired: 3, loyalty: 7, singleOwner: 8,
            kidsCompatibility: 4, petCompatibility: 3, aloneTolerance: 7, barkingLevel: 4, trainability: 5,
            imageUrl: "https://images.dog.ceo/breeds/shiba/shiba-12.jpg"
        ),
        DogBreed(
            name: "Irish Setter",
            description: "Outgoing, playful, and exuberant. Irish Setters are sociable with everyone and have an almost puppy-like enthusiasm that lasts their whole life.",
            origin: "Ireland", group: "Sporting", emoji: "🐕", accentHex: "#B91C1C",
            dogCeoBreedKey: "setter/irish",
            size: 8, energyLevel: 9, shedding: 5, guardedness: 3, aggressiveness: 2,
            immunity: 8, lifespan: 8, groomingNeeds: 6, vetVisitsRequired: 4, loyalty: 8, singleOwner: 4,
            kidsCompatibility: 9, petCompatibility: 8, aloneTolerance: 4, barkingLevel: 5, trainability: 7,
            imageUrl: "https://images.dog.ceo/breeds/setter-irish/n02100877_6852.jpg"
        ),
    ]

    // MARK: Matching
    /// Returns a copy of all breeds ranked by Manhattan-distance match score.
    /// 16 traits × max 10 pts each = 160 max distance → normalized to 0–1.
    static func getMatchingBreeds(
        size: Double, energy: Double, shedding: Double,
        guardedness: Double, aggressiveness: Double, immunity: Double,
        lifespan: Double, grooming: Double, vetVisits: Double,
        loyalty: Double, singleOwner: Double,
        kidsCompat: Double, petCompat: Double, aloneToler: Double,
        barking: Double, trainability: Double
    ) -> [DogBreed] {
        var ranked: [DogBreed] = all.map { breed -> DogBreed in
            var b = breed
            // Explicit Double annotation avoids WMO type-checker timeout on the
            // long + chain (Swift SR-11524 / "unable to type-check in reasonable time").
            let d0: Double  = abs(breed.size              - size)
            let d1: Double  = abs(breed.energyLevel       - energy)
            let d2: Double  = abs(breed.shedding          - shedding)
            let d3: Double  = abs(breed.guardedness       - guardedness)
            let d4: Double  = abs(breed.aggressiveness    - aggressiveness)
            let d5: Double  = abs(breed.immunity          - immunity)
            let d6: Double  = abs(breed.lifespan          - lifespan)
            let d7: Double  = abs(breed.groomingNeeds     - grooming)
            let d8: Double  = abs(breed.vetVisitsRequired - vetVisits)
            let d9: Double  = abs(breed.loyalty           - loyalty)
            let d10: Double = abs(breed.singleOwner       - singleOwner)
            let d11: Double = abs(breed.kidsCompatibility - kidsCompat)
            let d12: Double = abs(breed.petCompatibility  - petCompat)
            let d13: Double = abs(breed.aloneTolerance    - aloneToler)
            let d14: Double = abs(breed.barkingLevel      - barking)
            let d15: Double = abs(breed.trainability      - trainability)
            let distance: Double = d0+d1+d2+d3+d4+d5+d6+d7+d8+d9+d10+d11+d12+d13+d14+d15
            b.matchScore = max(0.0, min(1.0, 1.0 - distance / 160.0))
            return b
        }
        ranked.sort { $0.matchScore > $1.matchScore }
        return ranked
    }
}
