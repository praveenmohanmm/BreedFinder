using BreedFinder.Models;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;

namespace BreedFinder.ViewModels;

[QueryProperty(nameof(Breed), "Breed")]
public partial class BreedDetailViewModel : ObservableObject
{
    [ObservableProperty]
    private DogBreed? breed;

    [RelayCommand]
    private async Task GoBack() => await Shell.Current.GoToAsync("..");
}
