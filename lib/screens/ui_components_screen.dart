import 'package:flutter/material.dart';
import 'package:nusantara_data/nusantara_data.dart';

class UIComponentsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const UIComponentsScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<UIComponentsScreen> createState() => _UIComponentsScreenState();
}

class _UIComponentsScreenState extends State<UIComponentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Components'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Simple'),
            Tab(text: 'Searchable'),
            Tab(text: 'Dialog'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _SimpleDropdownTab(),
          _SearchableDropdownTab(),
          _DialogPickerTab(),
        ],
      ),
    );
  }
}

// Tab 1: Simple Dropdown
class _SimpleDropdownTab extends StatefulWidget {
  const _SimpleDropdownTab();

  @override
  State<_SimpleDropdownTab> createState() => _SimpleDropdownTabState();
}

class _SimpleDropdownTabState extends State<_SimpleDropdownTab> {
  List<ProvinceSummary> _provinces = [];
  List<CitySummary> _cities = [];

  ProvinceSummary? _selectedProvince;
  CitySummary? _selectedCity;

  @override
  void initState() {
    super.initState();
    _provinces = NusantaraData.getAllProvinces();
  }

  void _onProvinceSelected(ProvinceSummary? province) {
    setState(() {
      _selectedProvince = province;
      _selectedCity = null;
      _cities = province != null
          ? NusantaraData.getCitiesByProvinceId(province.id)
          : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description Card
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Dropdown sederhana dengan DropdownButtonFormField standar Flutter',
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Province Dropdown
          Text(
            'Provinsi',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<ProvinceSummary>(
            value: _selectedProvince,
            hint: const Text('Pilih Provinsi'),
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_city),
            ),
            items: _provinces.map((province) {
              return DropdownMenuItem<ProvinceSummary>(
                value: province,
                child: Text(province.name),
              );
            }).toList(),
            onChanged: _onProvinceSelected,
          ),

          const SizedBox(height: 16),

          // City Dropdown
          Text(
            'Kota/Kabupaten',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<CitySummary>(
            value: _selectedCity,
            hint: const Text('Pilih Kota/Kabupaten'),
            isExpanded: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.apartment),
              enabled: _selectedProvince != null,
              filled: _selectedProvince == null,
              fillColor: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.5),
            ),
            items: _cities.map((city) {
              return DropdownMenuItem<CitySummary>(
                value: city,
                child: Text(city.name),
              );
            }).toList(),
            onChanged: _selectedProvince != null
                ? (city) {
                    setState(() {
                      _selectedCity = city;
                    });
                  }
                : null,
          ),

          const SizedBox(height: 24),

          // Result Card
          if (_selectedCity != null) ...[
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
                          'Pilihan Anda',
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
                    _buildResultRow('Provinsi', _selectedProvince!.name),
                    _buildResultRow('Kota/Kabupaten', _selectedCity!.name),
                    _buildResultRow(
                        'Tipe', _selectedCity!.type.name.toUpperCase()),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
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
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withValues(alpha: 0.7),
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

// Tab 2: Searchable Dropdown
class _SearchableDropdownTab extends StatefulWidget {
  const _SearchableDropdownTab();

  @override
  State<_SearchableDropdownTab> createState() => _SearchableDropdownTabState();
}

class _SearchableDropdownTabState extends State<_SearchableDropdownTab> {
  final TextEditingController _searchController = TextEditingController();
  List<ProvinceSummary> _allProvinces = [];
  List<ProvinceSummary> _filteredProvinces = [];
  ProvinceSummary? _selectedProvince;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _allProvinces = NusantaraData.getAllProvinces();
    _filteredProvinces = _allProvinces;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProvinces(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProvinces = _allProvinces;
      } else {
        _filteredProvinces = _allProvinces
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectProvince(ProvinceSummary province) {
    setState(() {
      _selectedProvince = province;
      _searchController.text = province.name;
      _isDropdownOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description Card
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Dropdown dengan fitur pencarian untuk memfilter pilihan',
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Searchable Dropdown
          Text(
            'Cari Provinsi',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Ketik nama provinsi...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _selectedProvince = null;
                          _filteredProvinces = _allProvinces;
                        });
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              _filterProvinces(value);
              setState(() {
                _isDropdownOpen = true;
              });
            },
            onTap: () {
              setState(() {
                _isDropdownOpen = true;
              });
            },
          ),

          // Dropdown List
          if (_isDropdownOpen) ...[
            const SizedBox(height: 8),
            Card(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredProvinces.length,
                  itemBuilder: (context, index) {
                    final province = _filteredProvinces[index];
                    final isSelected = _selectedProvince?.id == province.id;
                    return ListTile(
                      leading: Icon(
                        Icons.location_city,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      title: Text(
                        province.name,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                      onTap: () => _selectProvince(province),
                    );
                  },
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Result Card
          if (_selectedProvince != null && !_isDropdownOpen) ...[
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
                          'Provinsi Terpilih',
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
                    _buildResultRow('Nama', _selectedProvince!.name),
                    _buildResultRow('ID BPS', _selectedProvince!.id),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withValues(alpha: 0.7),
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

// Tab 3: Dialog Picker
class _DialogPickerTab extends StatefulWidget {
  const _DialogPickerTab();

  @override
  State<_DialogPickerTab> createState() => _DialogPickerTabState();
}

class _DialogPickerTabState extends State<_DialogPickerTab> {
  ProvinceSummary? _selectedProvince;
  CitySummary? _selectedCity;
  DistrictSummary? _selectedDistrict;

  void _showProvinceDialog() {
    final provinces = NusantaraData.getAllProvinces();
    _showSelectionDialog<ProvinceSummary>(
      title: 'Pilih Provinsi',
      items: provinces,
      getLabel: (p) => p.name,
      selected: _selectedProvince,
      onSelected: (province) {
        setState(() {
          _selectedProvince = province;
          _selectedCity = null;
          _selectedDistrict = null;
        });
      },
    );
  }

  void _showCityDialog() {
    if (_selectedProvince == null) return;
    final cities = NusantaraData.getCitiesByProvinceId(_selectedProvince!.id);
    _showSelectionDialog<CitySummary>(
      title: 'Pilih Kota/Kabupaten',
      items: cities,
      getLabel: (c) => c.name,
      selected: _selectedCity,
      onSelected: (city) {
        setState(() {
          _selectedCity = city;
          _selectedDistrict = null;
        });
      },
    );
  }

  void _showDistrictDialog() {
    if (_selectedCity == null) return;
    final districts = NusantaraData.getDistrictsByCityId(_selectedCity!.id);
    _showSelectionDialog<DistrictSummary>(
      title: 'Pilih Kecamatan',
      items: districts,
      getLabel: (d) => d.name,
      selected: _selectedDistrict,
      onSelected: (district) {
        setState(() {
          _selectedDistrict = district;
        });
      },
    );
  }

  void _showSelectionDialog<T>({
    required String title,
    required List<T> items,
    required String Function(T) getLabel,
    required T? selected,
    required Function(T) onSelected,
  }) {
    final TextEditingController searchController = TextEditingController();
    List<T> filteredItems = items;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Cari...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (query) {
                        setDialogState(() {
                          if (query.isEmpty) {
                            filteredItems = items;
                          } else {
                            filteredItems = items
                                .where((item) => getLabel(item)
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                                .toList();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          final isSelected = selected != null &&
                              getLabel(selected) == getLabel(item);
                          return ListTile(
                            title: Text(
                              getLabel(item),
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : null,
                            onTap: () {
                              Navigator.pop(context);
                              onSelected(item);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description Card
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Dialog picker dengan fitur pencarian, ideal untuk data yang banyak',
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Province Picker
          _buildPickerButton(
            label: 'Provinsi',
            value: _selectedProvince?.name,
            hint: 'Pilih Provinsi',
            icon: Icons.location_city,
            enabled: true,
            onTap: _showProvinceDialog,
          ),

          const SizedBox(height: 12),

          // City Picker
          _buildPickerButton(
            label: 'Kota/Kabupaten',
            value: _selectedCity?.name,
            hint: 'Pilih Kota/Kabupaten',
            icon: Icons.apartment,
            enabled: _selectedProvince != null,
            onTap: _showCityDialog,
          ),

          const SizedBox(height: 12),

          // District Picker
          _buildPickerButton(
            label: 'Kecamatan',
            value: _selectedDistrict?.name,
            hint: 'Pilih Kecamatan',
            icon: Icons.domain,
            enabled: _selectedCity != null,
            onTap: _showDistrictDialog,
          ),

          const SizedBox(height: 24),

          // Result Card
          if (_selectedDistrict != null) ...[
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
                          'Lokasi Terpilih',
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
                    _buildResultRow('Provinsi', _selectedProvince!.name),
                    _buildResultRow('Kota/Kab', _selectedCity!.name),
                    _buildResultRow('Kecamatan', _selectedDistrict!.name),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPickerButton({
    required String label,
    required String? value,
    required String hint,
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
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
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: enabled
                    ? Theme.of(context).colorScheme.outline
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(12),
              color: enabled
                  ? null
                  : Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.5),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: enabled
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.5),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: TextStyle(
                      color: value != null
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: enabled ? 1.0 : 0.5),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: enabled
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withValues(alpha: 0.7),
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
