import 'package:flutter/material.dart';
import '../main.dart';

class HomeScreen extends StatelessWidget {
  final void Function(Screen) onNavigate;

  const HomeScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Header
              Text(
                'Nusantara Data',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Library data lokasi Indonesia lengkap dari Provinsi hingga Kode Pos',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),

              // Menu Grid (2x2)
              Row(
                children: [
                  Expanded(
                    child: _MenuCard(
                      icon: Icons.location_city,
                      title: 'Location Picker',
                      description: 'Pilih lokasi dengan dropdown bertingkat',
                      onTap: () => onNavigate(Screen.locationPicker),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MenuCard(
                      icon: Icons.search,
                      title: 'Search',
                      description: 'Cari lokasi dengan smart search',
                      onTap: () => onNavigate(Screen.search),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MenuCard(
                      icon: Icons.local_post_office,
                      title: 'Postal Code',
                      description: 'Cari lokasi dari kode pos',
                      onTap: () => onNavigate(Screen.postalCode),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MenuCard(
                      icon: Icons.explore,
                      title: 'Statistics',
                      description: 'Lihat statistik data',
                      onTap: () => onNavigate(Screen.statistics),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Full-width Card
              _MenuCard(
                icon: Icons.widgets,
                title: 'UI Components',
                description: 'Komponen UI bawaan library: dropdown, searchable, dialog picker',
                onTap: () => onNavigate(Screen.uiComponents),
                fullWidth: true,
              ),

              const SizedBox(height: 32),

              // Footer info
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Data lengkap 38 provinsi, 514 kota/kabupaten, 7.265 kecamatan, 83.202 kelurahan/desa, dan 83.762 kode pos.',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool fullWidth;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: fullWidth ? 100 : 140,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
