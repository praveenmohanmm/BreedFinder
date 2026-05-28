import SwiftUI

// MARK: - Main screen
struct MainView: View {
    @State private var vm = MainViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        @Bindable var vm = vm     // enables $vm.searchText binding

        NavigationStack {
            ZStack(alignment: .top) {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        appHeader

                        // ── Always-visible search bar ──────────────────────
                        BreedSearchBar(text: $vm.searchText)
                            .padding(.horizontal, 18)
                            .padding(.bottom, 6)

                        // ── Search mode vs. filter mode ───────────────────
                        if vm.isSearching {
                            searchResultsSection
                        } else {
                            filterToggleBar
                            if vm.filtersExpanded {
                                filterPanel
                                    .padding(.horizontal, 14)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                            findBreedButton
                                .padding(.horizontal, 14)
                                .padding(.top, 12)
                                .padding(.bottom, 10)

                            if vm.isLoading { loadingIndicator }
                            if vm.isResultsVisible { resultsSection }
                        }

                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
            .animation(.easeInOut(duration: 0.25), value: vm.filtersExpanded)
            .animation(.easeInOut(duration: 0.2),  value: vm.isResultsVisible)
            .animation(.easeInOut(duration: 0.18), value: vm.isSearching)
        }
    }

    // ── App header ────────────────────────────────────────────────────────────
    private var appHeader: some View {
        HStack(spacing: 10) {
            Text("🐾")
                .font(.system(size: 28))
            VStack(alignment: .leading, spacing: 1) {
                Text("Breed Finder")
                    .font(.title2.bold())
                    .foregroundStyle(Color.appTextPrimary)
                Text("Find your perfect match")
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // ── Filter toggle bar ─────────────────────────────────────────────────────
    private var filterToggleBar: some View {
        HStack {
            Text("🎛  Tweak Your Preferences")
                .font(.subheadline.bold())
                .foregroundStyle(Color.appTextPrimary)
            Spacer()
            Button {
                withAnimation {
                    vm.filtersExpanded.toggle()
                }
            } label: {
                Label(
                    vm.filtersExpanded ? "Hide" : "Show",
                    systemImage: vm.filtersExpanded
                        ? "chevron.up.circle.fill"
                        : "chevron.down.circle.fill"
                )
                .font(.subheadline.bold())
                .foregroundStyle(Color.appPrimary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(
            Color.white.opacity(0.6)
                .shadow(.drop(color: Color.appPrimary.opacity(0.06), radius: 4, y: 2))
        )
    }

    // ── Filter panel ──────────────────────────────────────────────────────────
    @ViewBuilder
    private var filterPanel: some View {
        @Bindable var vm = vm

        VStack(spacing: 10) {
            FilterSection(icon: "🐾", title: "Size & Build") {
                TraitSliderRow(traitName: "Size", value: $vm.sizeValue,
                               valueLabel: vm.sizeLabel)
            }
            FilterSection(icon: "🔥", title: "Temperament") {
                VStack(spacing: 0) {
                    TraitSliderRow(traitName: "Energy Level",   value: $vm.energyLevelValue,    valueLabel: vm.energyLevelLabel)
                    TraitSliderRow(traitName: "Guardedness",    value: $vm.guardednessValue,     valueLabel: vm.guardednessLabel)
                    TraitSliderRow(traitName: "Aggressiveness", value: $vm.aggressivenessValue,  valueLabel: vm.aggressivenessLabel)
                    TraitSliderRow(traitName: "Loyalty",        value: $vm.loyaltyValue,         valueLabel: vm.loyaltyLabel)
                    TraitSliderRow(traitName: "Single Owner",   value: $vm.singleOwnerValue,     valueLabel: vm.singleOwnerLabel)
                }
            }
            FilterSection(icon: "✂️", title: "Care & Grooming") {
                VStack(spacing: 0) {
                    TraitSliderRow(traitName: "Shedding",       value: $vm.sheddingValue,       valueLabel: vm.sheddingLabel)
                    TraitSliderRow(traitName: "Grooming Needs", value: $vm.groomingNeedsValue,  valueLabel: vm.groomingNeedsLabel)
                }
            }
            FilterSection(icon: "🏥", title: "Health & Vitality") {
                VStack(spacing: 0) {
                    TraitSliderRow(traitName: "Immunity",   value: $vm.immunityValue,   valueLabel: vm.immunityLabel)
                    TraitSliderRow(traitName: "Lifespan",   value: $vm.lifespanValue,   valueLabel: vm.lifespanLabel)
                    TraitSliderRow(traitName: "Vet Visits", value: $vm.vetVisitsValue,  valueLabel: vm.vetVisitsLabel)
                }
            }
            Button {
                withAnimation { vm.resetFilters() }
            } label: {
                Label("Reset to Defaults", systemImage: "arrow.counterclockwise")
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.appPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.appTagBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .padding(.top, 2)
        }
    }

    // ── CTA button ────────────────────────────────────────────────────────────
    private var findBreedButton: some View {
        Button {
            Task { await vm.findBreeds() }
        } label: {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "#5B9AFF"), Color(hex: "#1D6EF5"), Color(hex: "#1249B8")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                if vm.isLoading {
                    HStack(spacing: 12) {
                        ProgressView().progressViewStyle(.circular).tint(.white).scaleEffect(0.85)
                        Text("Sniffing out your perfect breed…")
                            .font(.subheadline.bold()).foregroundStyle(.white)
                    }
                } else {
                    Text("🔍  Find My Breed  🐾")
                        .font(.headline.bold()).foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color(hex: "#1D6EF5").opacity(0.35), radius: 14, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .disabled(vm.isLoading)
    }

    // ── Loading indicator ─────────────────────────────────────────────────────
    private var loadingIndicator: some View {
        VStack(spacing: 14) {
            ProgressView().progressViewStyle(.circular).tint(Color.appPrimary).scaleEffect(1.3)
            Text("Finding your perfect match…")
                .font(.subheadline).foregroundStyle(Color.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
    }

    // ── Filter results grid ───────────────────────────────────────────────────
    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(vm.resultsHeader)
                    .font(.caption.bold()).foregroundStyle(Color.appTextSecondary)
                Spacer()
                Button {
                    withAnimation { vm.filtersExpanded = true }
                } label: {
                    Label("Edit", systemImage: "slider.horizontal.3")
                        .font(.caption.bold()).foregroundStyle(Color.appPrimary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.top, 8)

            breedGrid(vm.matchingBreeds)
        }
    }

    // ── Search results ────────────────────────────────────────────────────────
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(vm.searchHeader)
                .font(.caption.bold())
                .foregroundStyle(Color.appTextSecondary)
                .padding(.horizontal, 14)
                .padding(.top, 8)

            if vm.searchResults.isEmpty {
                VStack(spacing: 14) {
                    Text("🔍").font(.system(size: 52))
                    Text("No breeds found")
                        .font(.headline.bold())
                        .foregroundStyle(Color.appTextPrimary)
                    Text("Try a different name")
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else {
                breedGrid(vm.searchResults)
            }
        }
    }

    // ── Shared 2-column grid ──────────────────────────────────────────────────
    private func breedGrid(_ breeds: [DogBreed]) -> some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(breeds) { breed in
                NavigationLink(destination: BreedDetailView(breed: breed)) {
                    BreedCard(breed: breed)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
    }
}

// MARK: - Search bar component
private struct BreedSearchBar: View {
    @Binding var text: String
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 9) {
            Image(systemName: "magnifyingglass")
                .font(.subheadline)
                .foregroundStyle(focused || !text.isEmpty
                                 ? Color.appPrimary
                                 : Color.appTextSecondary)

            TextField("Search breeds…", text: $text)
                .font(.subheadline)
                .foregroundStyle(Color.appTextPrimary)
                .autocorrectionDisabled()
                .focused($focused)

            if !text.isEmpty {
                Button {
                    withAnimation(.easeOut(duration: 0.15)) {
                        text = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            focused || !text.isEmpty
                                ? Color.appPrimary.opacity(0.5)
                                : Color.appBorder,
                            lineWidth: 1
                        )
                )
        )
        .animation(.easeInOut(duration: 0.15), value: focused)
        .animation(.easeInOut(duration: 0.15), value: text.isEmpty)
    }
}

// MARK: - Preview
#Preview {
    MainView()
}
