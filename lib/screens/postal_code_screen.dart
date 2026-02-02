import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nusantara_data/nusantara_data.dart';

class PostalCodeScreen extends StatefulWidget {
  final VoidCallback onBack;

  const PostalCodeScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<PostalCodeScreen> createState() => _PostalCodeScreenState();
}

class _PostalCodeScreenState extends State<PostalCodeScreen> {
  final TextEditingController _postalCodeController = TextEditingController();
  List<PostalCodeDetail> _results = [];
  bool _isSearched = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _postalCodeController.dispose();
    super.dispose();
  }

  void _searchPostalCode() {
    final code = _postalCodeController.text.trim();

    if (code.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode pos harus 5 digit'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final results = NusantaraData.getLocationByPostalCode(code);

    setState(() {
      _results = results;
      _isSearched = true;
      _isLoading = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _postalCodeController.clear();
      _results = [];
      _isSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Kode Pos'),
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
            // Input Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.local_post_office,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Masukkan Kode Pos',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _postalCodeController,
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Contoh: 10110',
                              counterText: '',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.pin),
                            ),
                            onSubmitted: (_) => _searchPostalCode(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: _searchPostalCode,
                          icon: const Icon(Icons.search),
                          label: const Text('Cari'),
                        ),
                      ],
                    ),
                    if (_postalCodeController.text.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _clearSearch,
                        icon: const Icon(Icons.clear, size: 18),
                        label: const Text('Hapus'),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Results Section
            if (_isLoading) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
            ] else if (_isSearched) ...[
              if (_results.isEmpty) ...[
                _buildEmptyResult(),
              ] else ...[
                Text(
                  'Ditemukan ${_results.length} lokasi',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                ..._results.map((result) => _buildResultCard(result)),
              ],
            ] else ...[
              _buildInitialState(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.local_post_office_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Cari Lokasi dari Kode Pos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Masukkan 5 digit kode pos untuk mengetahui lokasi lengkapnya',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyResult() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Kode Pos Tidak Ditemukan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pastikan kode pos yang dimasukkan benar',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(PostalCodeDetail result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    result.villageName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                        ),
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildResultRow(
              'Kode Pos',
              result.postalCode,
              Icons.pin,
            ),
            _buildResultRow(
              'Kelurahan/Desa',
              result.villageName,
              Icons.house,
            ),
            _buildResultRow(
              'Kecamatan',
              result.districtName,
              Icons.domain,
            ),
            _buildResultRow(
              'Kota/Kabupaten',
              result.cityName,
              Icons.apartment,
            ),
            _buildResultRow(
              'Provinsi',
              result.provinceName,
              Icons.location_city,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.map,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      result.getFullAddress(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
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
