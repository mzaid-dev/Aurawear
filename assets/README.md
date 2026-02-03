# 🎨 Aurawear Assets

This folder contains all assets for the Aurawear application.

## 📁 Folder Structure

```
assets/
├── images/
│   ├── products/       # Product images (headphones, airpods, speakers, etc.)
│   └── hero/           # Hero/banner images for home screen
├── icons/              # Custom app icons
└── fonts/
    └── Poppins/        # Poppins font family (Regular, Medium, SemiBold, Bold)
```

## 🎨 Fonts

### Poppins
- **Regular** (400) - Body text
- **Medium** (500) - Labels, emphasized text  
- **SemiBold** (600) - Headings, buttons
- **Bold** (700) - Display text, hero sections

The Poppins font is used throughout the app for consistency with the modern, clean design aesthetic.

## 🖼️ Images

### Product Images
Add product images to `images/products/` with descriptive names:
- `airpods_pro.png`
- `headphones_rose.png`
- `speakers_premium.png`
- etc.

**Recommended specs:**
- Format: PNG with transparency
- Size: 800x800px (square)
- Background: Transparent or matching app theme

### Hero Images
Add hero/banner images to `images/hero/`:
- Large promotional images
- Background images for splash/home
- Featured product showcases

**Recommended specs:**
- Format: PNG or WebP
- Aspect ratio: 16:9 or according to design
- Optimized for mobile (< 500KB)

## 🎯 Icons

Custom icons for categories, actions, and UI elements:
- Use SVG or PNG format
- Consistent style (outline or filled)
- Size: 24x24dp or 48x48dp
- Color: Single color (can be tinted in code)

## 📝 Usage in Code

### Images
\`\`\`dart
Image.asset('assets/images/products/airpods_pro.png')
\`\`\`

### Fonts
Poppins is set as the default font family in the theme. No need to specify it explicitly unless overriding.

\`\`\`dart
// Automatic (uses Poppins)
Text('Hello', style: AppTextStyles.headlineLarge)

// Manual override
Text('Hello', style: TextStyle(fontFamily: 'Poppins'))
\`\`\`

## 🔄 Adding New Assets

1. Add files to appropriate folder
2. They're auto-loaded (folders are configured in `pubspec.yaml`)
3. Reference them using `assets/path/to/file`

**Note**: After adding new fonts, run `flutter pub get` and restart the app.
