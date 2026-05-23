using BreedFinder.Views;

namespace BreedFinder;

public partial class AppShell : Shell
{
    public AppShell()
    {
        InitializeComponent();
        Routing.RegisterRoute(nameof(BreedDetailPage), typeof(BreedDetailPage));
    }
}
