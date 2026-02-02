import 'package:flutter/material.dart';
import 'package:nusantara_data/nusantara_data.dart';

class StatisticsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const StatisticsScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DataStatistics? _statistics;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  void _loadStatistics() {
    setState(() {
      _statistics = NusantaraData.getStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: _statistics == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.analytics,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nusantara Data',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Versi ${NusantaraData.getVersion()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer
                                            .withValues(alpha: 0.8),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Statistics Title
                  Text(
                    'Data Wilayah Indonesia',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Data lengkap wilayah administrasi Indonesia',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Statistics Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      _buildStatCard(
                        icon: Icons.location_city,
                        label: 'Provinsi',
                        count: _statistics!.provinceCount,
                        color: Colors.blue,
                      ),
                      _buildStatCard(
                        icon: Icons.apartment,
                        label: 'Kota/Kabupaten',
                        count: _statistics!.cityCount,
                        color: Colors.green,
                      ),
                      _buildStatCard(
                        icon: Icons.domain,
                        label: 'Kecamatan',
                        count: _statistics!.districtCount,
                        color: Colors.orange,
                      ),
                      _buildStatCard(
                        icon: Icons.house,
                        label: 'Kelurahan/Desa',
                        count: _statistics!.villageCount,
                        color: Colors.purple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Postal Code Card (Full Width)
                  _buildWideStatCard(
                    icon: Icons.local_post_office,
                    label: 'Kode Pos',
                    count: _statistics!.postalCodeCount,
                    color: Colors.red,
                  ),

                  const SizedBox(height: 32),

                  // Data Sources Section
                  Text(
                    'Sumber Data',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),

                  _buildSourceCard(
                    title: 'Kepmendagri 2025',
                    subtitle:
                        'Keputusan Menteri Dalam Negeri No 300.2.2-2138 Tahun 2025',
                    icon: Icons.article,
                  ),
                  _buildSourceCard(
                    title: 'Badan Pusat Statistik',
                    subtitle:
                        'Kode wilayah resmi dari BPS (Badan Pusat Statistik)',
                    icon: Icons.account_balance,
                  ),
                  _buildSourceCard(
                    title: 'GitHub cahyadsn/wilayah',
                    subtitle: 'Repository data wilayah Indonesia',
                    icon: Icons.code,
                  ),

                  const SizedBox(height: 32),

                  // BPS ID Format Section
                  Text(
                    'Format Kode BPS',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildIdFormatRow(
                            'Provinsi',
                            '2 digit',
                            'Contoh: 31 (DKI Jakarta)',
                            Colors.blue,
                          ),
                          const Divider(),
                          _buildIdFormatRow(
                            'Kota/Kabupaten',
                            '4 digit',
                            'Contoh: 3171 (Jakarta Pusat)',
                            Colors.green,
                          ),
                          const Divider(),
                          _buildIdFormatRow(
                            'Kecamatan',
                            '6 digit',
                            'Contoh: 317101 (Gambir)',
                            Colors.orange,
                          ),
                          const Divider(),
                          _buildIdFormatRow(
                            'Kelurahan/Desa',
                            '10 digit',
                            'Contoh: 3171012001',
                            Colors.purple,
                          ),
                          const Divider(),
                          _buildIdFormatRow(
                            'Kode Pos',
                            '5 digit',
                            'Contoh: 10110',
                            Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              _formatNumber(count),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideStatCard({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  Text(
                    _formatNumber(count),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
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

  Widget _buildSourceCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildIdFormatRow(
    String type,
    String format,
    String example,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      type,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        format,
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  example,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
