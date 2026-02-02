import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nusantara_data/nusantara_data.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onBack;

  const SearchScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  String _selectedFilter = 'all';
  List<_SearchResultItem> _searchResults = [];
  bool _isLoading = false;
  String _query = '';

  final List<Map<String, dynamic>> _filters = [
    {'key': 'all', 'label': 'Semua', 'icon': Icons.search},
    {'key': 'province', 'label': 'Provinsi', 'icon': Icons.location_city},
    {'key': 'city', 'label': 'Kota/Kab', 'icon': Icons.apartment},
    {'key': 'district', 'label': 'Kecamatan', 'icon': Icons.domain},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(value);
    });
  }

  void _performSearch(String query) {
    setState(() {
      _query = query;
      _isLoading = true;
    });

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    List<_SearchResultItem> results = [];

    switch (_selectedFilter) {
      case 'province':
        final provinces = NusantaraData.searchProvinces(query);
        results = provinces
            .map((p) => _SearchResultItem(
                  id: p.id,
                  name: p.name,
                  type: 'province',
                  fullPath: p.name,
                ))
            .toList();
        break;
      case 'city':
        final cities = NusantaraData.searchCities(query);
        results = cities.map((c) {
          final province = NusantaraData.getProvinceById(c.provinceId);
          return _SearchResultItem(
            id: c.id,
            name: c.name,
            type: 'city',
            fullPath: '${c.name}, ${province?.name ?? 'Unknown'}',
          );
        }).toList();
        break;
      case 'district':
        final districts = NusantaraData.searchDistricts(query);
        results = districts.map((d) {
          final city = NusantaraData.getCityById(d.cityId);
          return _SearchResultItem(
            id: d.id,
            name: d.name,
            type: 'district',
            fullPath: '${d.name}, ${city?.name ?? 'Unknown'}',
          );
        }).toList();
        break;
      default:
        // Search all types
        final provinces = NusantaraData.searchProvinces(query);
        final cities = NusantaraData.searchCities(query);
        final districts = NusantaraData.searchDistricts(query);

        results = [
          ...provinces.map((p) => _SearchResultItem(
                id: p.id,
                name: p.name,
                type: 'province',
                fullPath: p.name,
              )),
          ...cities.map((c) {
            final province = NusantaraData.getProvinceById(c.provinceId);
            return _SearchResultItem(
              id: c.id,
              name: c.name,
              type: 'city',
              fullPath: '${c.name}, ${province?.name ?? 'Unknown'}',
            );
          }),
          ...districts.map((d) {
            final city = NusantaraData.getCityById(d.cityId);
            return _SearchResultItem(
              id: d.id,
              name: d.name,
              type: 'district',
              fullPath: '${d.name}, ${city?.name ?? 'Unknown'}',
            );
          }),
        ];
    }

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    if (_query.isNotEmpty) {
      _performSearch(_query);
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'province':
        return Icons.location_city;
      case 'city':
        return Icons.apartment;
      case 'district':
        return Icons.domain;
      case 'village':
        return Icons.house;
      default:
        return Icons.place;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'province':
        return 'Provinsi';
      case 'city':
        return 'Kota/Kabupaten';
      case 'district':
        return 'Kecamatan';
      case 'village':
        return 'Kelurahan/Desa';
      default:
        return type;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'province':
        return Colors.blue;
      case 'city':
        return Colors.green;
      case 'district':
        return Colors.orange;
      case 'village':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari lokasi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter['key'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          filter['icon'] as IconData,
                          size: 16,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(filter['label'] as String),
                      ],
                    ),
                    onSelected: (_) => _onFilterSelected(filter['key'] as String),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Results
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Ketik untuk mencari',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cari provinsi, kota, atau kecamatan',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ditemukan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba kata kunci lain atau ubah filter',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${_searchResults.length} hasil ditemukan',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final result = _searchResults[index];
              return _buildResultCard(result);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(_SearchResultItem result) {
    final typeColor = _getTypeColor(result.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTypeIcon(result.type),
            color: typeColor,
          ),
        ),
        title: Text(
          result.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.fullPath),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getTypeLabel(result.type),
                style: TextStyle(
                  fontSize: 10,
                  color: typeColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showDetailDialog(result),
      ),
    );
  }

  void _showDetailDialog(_SearchResultItem result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(result.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Tipe', _getTypeLabel(result.type)),
            _buildDetailRow('ID', result.id),
            _buildDetailRow('Lokasi', result.fullPath),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal search result item for unified display
class _SearchResultItem {
  final String id;
  final String name;
  final String type;
  final String fullPath;

  _SearchResultItem({
    required this.id,
    required this.name,
    required this.type,
    required this.fullPath,
  });
}
