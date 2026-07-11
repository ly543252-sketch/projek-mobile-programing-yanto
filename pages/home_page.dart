import 'dart:io';
import 'package:flutter/material.dart';
import '../database/isar_service.dart';
import '../models/product.dart';
import 'product_list_page.dart';
import 'add_edit_product_page.dart';
import 'about_page.dart';
import 'favorite_page.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final IsarService _db = IsarService();
  int _totalProduk = 0;
  Map<String, int> _kategoriCount = {};
  List<Product> _semuaProduk = [];

  final List<String> _kategoriList = [
    'Pakaian',
    'Aksesoris',
    'Minuman',
    'Souvenir',
  ];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final all = await _db.getAllProducts();
    final Map<String, int> counts = {};
    for (final kategori in _kategoriList) {
      counts[kategori] = all.where((p) => p.kategori == kategori).length;
    }
    setState(() {
      _totalProduk = all.length;
      _kategoriCount = counts;
      _semuaProduk = all;
    });
  }

  Color _kategoriColor(String kategori) {
    switch (kategori) {
      case 'Pakaian':
        return const Color(0xFF673AB7);
      case 'Aksesoris':
        return const Color(0xFF009688);
      case 'Minuman':
        return const Color(0xFF2196F3);
      case 'Souvenir':
        return const Color(0xFFFF9800);
      default:
        return Colors.grey;
    }
  }

  IconData _kategoriIcon(String kategori) {
    switch (kategori) {
      case 'Pakaian':
        return Icons.checkroom_rounded;
      case 'Aksesoris':
        return Icons.watch_rounded;
      case 'Minuman':
        return Icons.local_drink_rounded;
      case 'Souvenir':
        return Icons.card_giftcard_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  String _formatHarga(int harga) {
    final str = harga.toString();
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) result = '.$result';
      result = str[i] + result;
      count++;
    }
    return 'Rp$result';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, Admin 👋',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Text(
                        'CampusMerch',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF673AB7),
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor:
                        const Color(0xFF673AB7).withValues(alpha: 0.12),
                    radius: 24,
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Color(0xFF673AB7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Kartu statistik total
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF673AB7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2_rounded,
                        color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Produk',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$_totalProduk Produk',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Statistik per kategori
              const Text(
                'Produk per Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: _kategoriList.map((kategori) {
                  final count = _kategoriCount[kategori] ?? 0;
                  final color = _kategoriColor(kategori);
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _kategoriIcon(kategori),
                            color: color,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                kategori,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '$count produk',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // Menu utama
              const Text(
                'Menu Utama',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MenuCard(
                      icon: Icons.grid_view_rounded,
                      label: 'Katalog\nProduk',
                      color: const Color(0xFF009688),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProductListPage()),
                        );
                        _loadStats();
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _MenuCard(
                      icon: Icons.add_box_rounded,
                      label: 'Tambah\nProduk',
                      color: const Color(0xFF673AB7),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddEditProductPage()),
                        );
                        _loadStats();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MenuCard(
                      icon: Icons.manage_search_rounded,
                      label: 'Kelola\nProduk',
                      color: const Color(0xFFFF5252),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProductListPage()),
                        );
                        _loadStats();
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _MenuCard(
                      icon: Icons.favorite_rounded,
                      label: 'Produk\nFavorit',
                      color: const Color(0xFFE91E63),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FavoritePage()),
                        );
                        _loadStats();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Produk Kami — dari database
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Produk Kami',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProductListPage()),
                      );
                      _loadStats();
                    },
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(color: Color(0xFF673AB7)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _semuaProduk.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            'Belum ada produk',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: _semuaProduk.map((product) {
                        final color = _kategoriColor(product.kategori);
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailPage(product: product),
                              ),
                            );
                            _loadStats();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Foto atau placeholder
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: product.gambarAsset.isNotEmpty
                                      ? Image.file(
                                          File(product.gambarAsset),
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              _buildPhotoPlaceholder(color),
                                        )
                                      : _buildPhotoPlaceholder(color),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.nama,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          product.kategori,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  _formatHarga(product.harga),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder(Color color) {
    return Container(
      width: 56,
      height: 56,
      color: color.withValues(alpha: 0.1),
      child: Icon(Icons.inventory_2_rounded, color: color, size: 28),
    );
  }
}

// Widget kartu menu
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}