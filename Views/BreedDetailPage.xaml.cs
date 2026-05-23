using BreedFinder.ViewModels;

namespace BreedFinder.Views;

public partial class BreedDetailPage : ContentPage
{
    public BreedDetailPage(BreedDetailViewModel viewModel)
    {
        InitializeComponent();
        BindingContext = viewModel;
    }
}
