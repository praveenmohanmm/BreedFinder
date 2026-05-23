using System.Globalization;

namespace BreedFinder.Converters;

public class MatchColorConverter : IValueConverter
{
    public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        if (value is double score)
        {
            if (score >= 0.75) return Color.FromArgb("#10B981");
            if (score >= 0.50) return Color.FromArgb("#F59E0B");
            return Color.FromArgb("#EF4444");
        }
        return Color.FromArgb("#6366F1");
    }
    public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        => throw new NotImplementedException();
}

public class TraitProgressConverter : IValueConverter
{
    public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
        => value is double d ? d / 10.0 : 0.0;
    public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        => throw new NotImplementedException();
}

public class MatchLabelConverter : IValueConverter
{
    public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
    {
        if (value is double score)
        {
            if (score >= 0.85) return "Excellent";
            if (score >= 0.70) return "Great";
            if (score >= 0.55) return "Good";
            if (score >= 0.40) return "Fair";
            return "Low";
        }
        return string.Empty;
    }
    public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        => throw new NotImplementedException();
}

public class InvertBoolConverter : IValueConverter
{
    public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
        => value is bool b && !b;
    public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        => value is bool b && !b;
}
