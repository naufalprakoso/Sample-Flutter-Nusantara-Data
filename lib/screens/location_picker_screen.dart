import 'package:flutter/material.dart';
import 'package:nusantara_data/nusantara_data.dart';

class LocationPickerScreen extends StatefulWidget {
  final VoidCallback onBack;

  const LocationPickerScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  List<ProvinceSummary> _provinces = [];
  List<CitySummary> _cities = [];
  List<DistrictSummary> _districts = [];
  List<VillageSummary> _villages = [];

  ProvinceSummary? _selectedProvince;
  CitySummary? _selectedCity;
  DistrictSummary? _selectedDistrict;
  VillageSummary? _selectedVillage;
  String? _selectedPostalCode;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  void _loadProvinces() {
    setState(() {
      _provinces = NusantaraData.getAllProvinces();
    });
  }

  void _onProvinceSelected(ProvinceSummary? province) {
    setState(() {
      _selectedProvince = province;
      _selectedCity = null;
      _selectedDistrict = null;
      _selectedVillage = null;
      _selectedPostalCode = null;
      _cities = province != null
          ? NusantaraData.getCitiesByProvinceId(province.id)
          : [];
      _districts = [];
      _villages = [];
    });
  }

  void _onCitySelected(CitySummary? city) {
    setState(() {
      _selectedCity = city;
      _selectedDistrict = null;
      _selectedVillage = null;
      _selectedPostalCode = null;
      _districts = city != null
          ? NusantaraData.getDistrictsByCityId(city.id)
          : [];
      _villages = [];
    });
  }

  void _onDistrictSelected(DistrictSummary? district) {
    setState(() {
      _selectedDistrict = district;
      _selectedVillage = null;
      _selectedPostalCode = null;
      _villages = district != null
          ? NusantaraData.getVillagesByDistrictId(district.id)
          : [];
    });
  }

  void _onVillageSelected(VillageSummary? village) {
    setState(() {
      _selectedVillage = village;
      _selectedPostalCode = village?.postalCodes.isNotEmpty == true
          ? village!.postalCodes.first
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Picker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Province Dropdown
            _LocationDropdown<ProvinceSummary>(
              label: 'Provinsi',
              hint: 'Pilih Provinsi',
              value: _selectedProvince,
              items: _provinces,
              getLabel: (p) => p.name,
              onChanged: _onProvinceSelected,
              enabled: true,
            ),
            const SizedBox(height: 16),

            // City Dropdown
            _LocationDropdown<CitySummary>(
              label: 'Kota/Kabupaten',
              hint: 'Pilih Kota/Kabupaten',
              value: _selectedCity,
              items: _cities,
              getLabel: (c) => c.name,
              onChanged: _onCitySelected,
              enabled: _selectedProvince != null,
            ),
            const SizedBox(height: 16),

            // District Dropdown
            _LocationDropdown<DistrictSummary>(
              label: 'Kecamatan',
              hint: 'Pilih Kecamatan',
              value: _selectedDistrict,
              items: _districts,
              getLabel: (d) => d.name,
              onChanged: _onDistrictSelected,
              enabled: _selectedCity != null,
            ),
            const SizedBox(height: 16),

            // Village Dropdown
            _LocationDropdown<VillageSummary>(
              label: 'Kelurahan/Desa',
              hint: 'Pilih Kelurahan/Desa',
              value: _selectedVillage,
              items: _villages,
              getLabel: (v) => v.name,
              onChanged: _onVillageSelected,
              enabled: _selectedDistrict != null,
            ),
            const SizedBox(height: 16),

            // Postal Code Display
            if (_selectedVillage != null &&
                _selectedVillage!.postalCodes.isNotEmpty) ...[
              Text(
                'Kode Pos',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedVillage!.postalCodes.map((code) {
                  final isSelected = code == _selectedPostalCode;
                  return ChoiceChip(
                    label: Text(code),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedPostalCode = selected ? code : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Result Card
            if (_selectedVillage != null) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Alamat Lengkap',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                      const Divider(),
                      _buildAddressRow('Kelurahan/Desa', _selectedVillage!.name),
                      _buildAddressRow('Kecamatan', _selectedDistrict!.name),
                      _buildAddressRow('Kota/Kabupaten', _selectedCity!.name),
                      _buildAddressRow('Provinsi', _selectedProvince!.name),
                      if (_selectedPostalCode != null)
                        _buildAddressRow('Kode Pos', _selectedPostalCode!),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddressRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) getLabel;
  final void Function(T?) onChanged;
  final bool enabled;

  const _LocationDropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.getLabel,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            enabled: enabled,
            filled: true,
            fillColor: enabled
                ? null
                : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(getLabel(item)),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
