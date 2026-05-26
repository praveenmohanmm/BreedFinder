import SwiftUI

// MARK: - Main screen
struct MainView: View {
    @State private var vm = MainViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        appHeader
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

                        if vm.isLoading {
                            loadingIndicator
                        }

                        if vm.isResultsVisible {
                            resultsSection
                        }

                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
            .animation(.easeInOut(duration: 0.25), value: vm.filtersExpanded)
            .animation(.easeInOut(duration: 0.2), value: vm.isResultsVisible)
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
        .padding(.bottom, 10)
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
                    systemImage: vm.filtersExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill"
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
        @Bindable var vm = vm    // enables $vm.xxx bindings for @Observable

        VStack(spacing: 10) {
            // ── 1. Size & Build ────────────────────────────────────────────────
            FilterSection(icon: "🐾", title: "Size & Build") {
                TraitSliderRow(
                    traitName: "Size",
                    value: $vm.sizeValue,
                    valueLabel: vm.sizeLabel
                )
            }

            // ── 2. Temperament ─────────────────────────────────────────────────
            FilterSection(icon: "🔥", title: "Temperament") {
                VStack(spacing: 0) {
                    TraitSliderRow(traitName: "Energy Level",  value: $vm.energyLevelValue,    valueLabel: vm.energyLevelLabel)
                    TraitSliderRow(traitName: "Guardedness",   value: $vm.guardednessValue,     valueLabel: vm.guardednessLabel)
                    TraitSliderRow(traitName: "Aggressiveness",value: $vm.aggressivenessValue,  valueLabel: vm.aggressivenessLabel)
                    TraitSliderRow(traitName: "Loyalty",       value: $vm.loyaltyValue,         valueLabel: vm.loyaltyLabel)
                    TraitSliderRow(traitName: "Single Owner",  value: $vm.singleOwnerValue,     valueLabel: vm.singleOwnerLabel)
                }
            }

            // ── 3. Care & Grooming ─────────────────────────────────────────────
            FilterSection(icon: "✂️", title: "Care & Grooming") {
                VStack(spacing: 0) {
                    TraitSliderRow(traitName: "Shedding",      value: $vm.sheddingValue,        valueLabel: vm.sheddingLabel)
                    TraitSliderRow(traitName: "Grooming Needs",value: $vm.groomingNeedsValue,   valueLabel: vm.groomingNeedsLabel)
                }
            }

            // ── 4. Health & Vitality ───────────────────────────────────────────
            FilterSection(icon: "🏥", title: "Health & Vitality") {
                VStack(spacing: 0) {
                    TraitSliderRow(traitName: "Immunity",   value: $vm.immunityValue,   valueLabel: vm.immunityLabel)
                    TraitSliderRow(traitName: "Lifespan",   value: $vm.lifespanValue,   valueLabel: vm.lifespanLabel)
                    TraitSliderRow(traitName: "Vet Visits", value: $vm.vetVisitsValue,  valueLabel: vm.vetVisitsLabel)
                }
            }

            // Reset button
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.appBorder, lineWidth: 1)
                    )
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
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                            .scaleEffect(0.85)
                        Text("Sniffing out your perfect breed…")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                    }
                } else {
                    Text("🔍  Find My Breed  🐾")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
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
            ProgressView()
                .progressViewStyle(.circular)
                .tint(Color.appPrimary)
                .scaleEffect(1.3)
            Text("Finding your perfect match…")
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
    }

    // ── Results ───────────────────────────────────────────────────────────────
    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Results header
            HStack {
                Text(vm.resultsHeader)
                    .font(.caption.bold())
                    .foregroundStyle(Color.appTextSecondary)
                Spacer()
                Button {
                    withAnimation { vm.filtersExpanded = true }
                } label: {
                    Label("Edit", systemImage: "slider.horizontal.3")
                        .font(.caption.bold())
                        .foregroundStyle(Color.appPrimary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.top, 8)

            // 2-column breed grid
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(vm.matchingBreeds) { breed in
                    NavigationLink(destination: BreedDetailView(breed: breed)) {
                        BreedCard(breed: breed)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
        }
    }
}

// MARK: - Preview
#Preview {
    MainView()
}
