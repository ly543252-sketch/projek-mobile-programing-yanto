import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        title: const Text(
          'Tentang Aplikasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF673AB7),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF673AB7).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 46,
                color: Color(0xFF673AB7),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'CampusMerch',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF673AB7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            _InfoSection(
              title: 'Tentang Aplikasi',
              child: Text(
                'CampusMerch adalah aplikasi katalog merchandise kampus digital '
                'yang membantu mahasiswa dan organisasi dalam mengelola, '
                'menampilkan, dan mempromosikan produk merchandise seperti '
                'kaos, hoodie, tote bag, tumbler, dan souvenir lainnya.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _InfoSection(
              title: 'Dibuat Oleh',
              child: Column(
                children: const [
                  _InfoRow(label: 'Nama', value: 'Yandi'),
                  Divider(),
                  _InfoRow(label: 'NIM', value: 'BD2303005'),
                  Divider(),
                  _InfoRow(label: 'Program Studi', value: 'D4 Bisnis Digital'),
                  Divider(),
                  _InfoRow(label: 'Mata Kuliah', value: 'Mobile Programming'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoSection(
              title: 'Teknologi',
              child: Column(
                children: const [
                  _InfoRow(label: 'Framework', value: 'Flutter'),
                  Divider(),
                  _InfoRow(label: 'Database', value: 'Isar'),
                  Divider(),
                  _InfoRow(label: 'Bahasa', value: 'Dart'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '© 2026 CampusMerch. All rights reserved.',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF673AB7),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}