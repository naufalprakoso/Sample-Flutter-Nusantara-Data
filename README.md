# Sample Flutter Nusantara Data

Sample Flutter app demonstrating the usage of [Nusantara Data](https://pub.dev/packages/nusantara_data) library - a Flutter/Dart library for Indonesia location data.

## Features

- **Location Picker** - Cascading dropdown untuk memilih Provinsi → Kota → Kecamatan → Kelurahan → Kode Pos
- **Smart Search** - Cari lokasi dengan typo-tolerant search (contoh: "Jakrta" → "Jakarta")
- **Postal Code Lookup** - Reverse lookup alamat lengkap dari kode pos
- **Statistics** - Lihat statistik data lokasi Indonesia
- **UI Components** - Contoh penggunaan UI components (Simple Dropdown, Searchable Dropdown, Dialog Picker)

## Screenshots

| Home | Location Picker | Search |
|------|-----------------|--------|
| ![Home](screenshots/home.png) | ![Picker](screenshots/picker.png) | ![Search](screenshots/search.png) |

| Postal Code | Statistics |
|-------------|------------|
| ![Postal](screenshots/postal.png) | ![Stats](screenshots/stats.png) |

## Requirements

- Flutter 3.10.0 or later
- Dart 3.0.0 or later
- Android SDK 21+ (Android 5.0 Lollipop) / iOS 12.0+

## Setup

1. Clone repository
```bash
git clone https://github.com/naufalprakoso/Sample-Flutter-Nusantara-Data.git
```

2. Install dependencies
```bash
cd Sample-Flutter-Nusantara-Data
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Dependencies

```yaml
# pubspec.yaml
dependencies:
  nusantara_data: ^1.0.0
```

## Project Structure

```
lib/
├── main.dart                      # Main entry point (initialize library)
├── screens/
│   ├── home_screen.dart           # Home menu
│   ├── location_picker_screen.dart # Cascading location picker
│   ├── search_screen.dart         # Smart search
│   ├── postal_code_screen.dart    # Postal code lookup
│   ├── statistics_screen.dart     # Data statistics
│   └── ui_components_screen.dart  # UI components showcase
└── theme/
    ├── colors.dart                # Merah Putih color scheme
    └── theme.dart                 # Light & Dark theme
```

## Usage Example

### Initialize Library

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize NusantaraData library
  await NusantaraData.initialize();

  runApp(const MyApp());
}
```

### Get All Provinces

```dart
final provinces = NusantaraData.getAllProvinces();
```

### Cascading Location Selection

```dart
// 1. Get provinces
final provinces = NusantaraData.getAllProvinces();

// 2. Get cities by province
final cities = NusantaraData.getCitiesByProvinceId(selectedProvince.id);

// 3. Get districts by city
final districts = NusantaraData.getDistrictsByCityId(selectedCity.id);

// 4. Get villages by district
final villages = NusantaraData.getVillagesByDistrictId(selectedDistrict.id);
```

### Smart Search

```dart
// Typo-tolerant search
final results = NusantaraData.searchCities('Jakrta'); // Returns "Jakarta"
```

### Postal Code Lookup

```dart
final locations = NusantaraData.getLocationByPostalCode('10110');
// Returns full address: Gambir, Gambir, Kota Jakarta Pusat, DKI Jakarta

for (final location in locations) {
  print(location.getFullAddress());
}
```

### UI Components

#### Simple Dropdown
```dart
DropdownButtonFormField<ProvinceSummary>(
  value: _selectedProvince,
  hint: const Text('Pilih Provinsi'),
  items: _provinces.map((province) {
    return DropdownMenuItem(
      value: province,
      child: Text(province.name),
    );
  }).toList(),
  onChanged: (province) {
    setState(() {
      _selectedProvince = province;
      _cities = province != null
          ? NusantaraData.getCitiesByProvinceId(province.id)
          : [];
    });
  },
)
```

#### Searchable Dropdown
```dart
TextField(
  controller: _searchController,
  decoration: const InputDecoration(
    hintText: 'Cari Provinsi...',
    prefixIcon: Icon(Icons.search),
  ),
  onChanged: (query) {
    setState(() {
      _filteredProvinces = _allProvinces
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  },
)
```

#### Dialog Picker
```dart
void _showProvinceDialog() {
  final provinces = NusantaraData.getAllProvinces();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Pilih Provinsi'),
      content: ListView.builder(
        shrinkWrap: true,
        itemCount: provinces.length,
        itemBuilder: (context, index) {
          final province = provinces[index];
          return ListTile(
            title: Text(province.name),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedProvince = province);
            },
          );
        },
      ),
    ),
  );
}
```

## Data Statistics

| Type | Count |
|------|-------|
| Provinces | 38 |
| Cities/Regencies | 514 |
| Districts (Kecamatan) | 7,265 |
| Villages (Kelurahan/Desa) | 83,202 |
| Postal Codes | 83,762 |

## BPS Code Format

| Level | Digits | Example |
|-------|--------|---------|
| Province | 2 | 31 (DKI Jakarta) |
| City/Regency | 4 | 3171 (Jakarta Pusat) |
| District | 6 | 317101 (Gambir) |
| Village | 10 | 3171012001 |
| Postal Code | 5 | 10110 |

## License

```
Copyright 2026 Naufal Prakoso

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
```

## Related

- [Nusantara Data Flutter Library](https://pub.dev/packages/nusantara_data) - Main library on pub.dev
- [Nusantara Data Kotlin Library](https://github.com/naufalprakoso/nusantara-data-kotlin) - Kotlin Multiplatform version
- [Sample Android App](https://github.com/naufalprakoso/Sample-Android-Nusantara-Data) - Android sample app
