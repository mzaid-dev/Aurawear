# 🎨 Aurawear Theme Guide

This guide explains how to use the "Dusty Rose" design system in your Flutter code.

## 📁 Files
- `lib/core/theme/app_colors.dart`: All color constants.
- `lib/core/theme/text_styles.dart`: Typography configurations.
- `lib/core/theme/app_theme.dart`: Main `ThemeData` configuration.

---

## 🌈 AppColors (Dusty Rose Palette)

Use `AppColors.[colorName]` to keep the UI consistent.

| Color | Hex | Usage |
| :--- | :--- | :--- |
| `primaryRose` | `#E8B4B8` | Primary brand color, headers, primary buttons. |
| `background` | `#FAF1EF` | Main scaffold background (Soft Nude). |
| `accentDark` | `#1A1A1A` | Dark contrast buttons, heavy text. |
| `cardBackground`| `#F6E6E4` | Product cards, search bars. |
| `surface` | `#FFFFFF` | White surfaces. |
| `textPrimary` | `#2D2D2D` | Main body and headline text. |

### 📝 Example Usage:
```dart
Container(
  color: AppColors.primaryRose,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)
```

---

## 🖋️ AppTextStyles (Poppins)

All styles use the **Poppins** font. Use `AppTextStyles.[styleName]` or `Theme.of(context).textTheme.[styleName]`.

| Style | Size | Weight | Usage |
| :--- | :--- | :--- | :--- |
| `displayLarge` | 40 | Bold | Hero sections (e.g., "With new sounds"). |
| `displayMedium`| 32 | Bold | Large page headers. |
| `headlineLarge`| 24 | Bold | Section titles (e.g., "New arrivals"). |
| `headlineMedium`| 20 | Semi-Bold| Product names, AppBar titles. |
| `bodyLarge` | 16 | Normal | Main descriptions. |
| `bodyMedium` | 14 | Normal | Secondary text, captions. |
| `labelLarge` | 14 | Semi-Bold| Buttons, Chips. |

### 📝 Example Usage:
```dart
Text(
  'Featured Product',
  style: AppTextStyles.headlineLarge,
)

// To override color
Text(
  'Custom Gray Label',
  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
)
```

---

## 🚀 Pro Tips

1. **Buttons**: Use `ElevatedButton`. The theme already applies the `accentDark` color and rounded corners.
2. **Cards**: Use `Card()`. The theme automatically sets the color to `cardBackground` and rounds the corners by 20px.
3. **AppBar**: The `AppTheme` handles the transparent background and dark icons by default.

---

**Follow this guide to keep the "Aurawear" look premium and professional! 💎**
