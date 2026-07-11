import 'package:flutter/material.dart';
import '../database/isar_service.dart';
import '../models/product.dart';
import 'product_detail_page.dart';
import 'add_edit_product_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final IsarService _db = IsarService();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  String _selectedKategori = 'Semua';
  String _sortBy = 'Terbaru';

  final List<String> _kategoriList = [
    'Semua',
    'Pakaian',
    'Aksesoris',
    'Minuman',
    'Souvenir',
  ];

  final List<String> _sortOptions = [
    'Terbaru',
    'Harga Terendah',
    'Harga Tertinggi',
    'Nama A-Z',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final data = await _db.getAllProducts();
    setState(() {
      _allProducts = data;
      _isLoading = false;
    });
    _applyFilter();
  }

  void _applyFilter() {
    final keyword = _searchController.text.toLowerCase();
    List<Product> result = _allProducts.where((p) {
      final matchNama = p.nama.toLowerCase().contains(keyword);
      final matchKategori =
          _selectedKategori == 'Semua' || p.kategori == _selectedKategori;
      return matchNama && matchKategori;
    }).toList();

    switch (_sortBy) {
      case 'Harga Terendah':
        result.sort((a, b) => a.harga.compareTo(b.harga));
        break;
      case 'Harga Tertinggi':
        result.sort((a, b) => b.harga.compareTo(a.harga));
        break;
      case 'Nama A-Z':
        result.sort(
            (a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
        break;
      case 'Terbaru':
        result = result.reversed.toList();
        break;
    }

    setState(() {
      _filteredProducts = result;
    });
  }

  Future<void> _deleteProduct(int id) async {
    await _db.deleteProduct(id);
    _loadProducts();
  }

  Future<void> _toggleFavorite(Product product) async {
    await _db.toggleFavorite(product);
    _loadProducts();
  }

  void _confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Yakin ingin menghapus "${product.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(product.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        title: const Text(
          'Katalog Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF673AB7),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditProductPage()),
          );
          _loadProducts();
        },
        backgroundColor: const Color(0xFF673AB7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Search + Filter area
          Container(
            color: const Color(0xFF673AB7),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    hintStyle:
                        TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, color: Colors.white70),
                            onPressed: () {
                              _searchController.clear();
                              _applyFilter();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),

                // Filter chip kategori
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _kategoriList.length,
                    itemBuilder: (context, index) {
                      final kategori = _kategoriList[index];
                      final isSelected = _selectedKategori == kategori;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedKategori = kategori);
                          _applyFilter();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            kategori,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF673AB7)
                                  : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Jumlah hasil + Sort
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredProducts.length} produk ditemukan',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                PopupMenuButton<String>(
                  initialValue: _sortBy,
                  onSelected: (value) {
                    setState(() => _sortBy = value);
                    _applyFilter();
                  },
                  itemBuilder: (context) => _sortOptions
                      .map((opt) =>
                          PopupMenuItem(value: opt, child: Text(opt)))
                      .toList(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sort_rounded,
                          size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        _sortBy,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List produk
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? 'Produk tidak ditemukan'
                                  : 'Belum ada produk',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? 'Coba kata kunci lain'
                                  : 'Tekan tombol + untuk menambah produk',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          final color = _kategoriColor(product.kategori);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: color.withValues(alpha: 0.12),
                                child: Text(
                                  product.nama.isNotEmpty
                                      ? product.nama[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                product.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatHarga(product.harga),
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      product.kategori,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      product.isFavorite
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () =>
                                        _toggleFavorite(product),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded,
                                        color: Color(0xFF009688)),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddEditProductPage(
                                              product: product),
                                        ),
                                      );
                                      _loadProducts();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_rounded,
                                        color: Colors.redAccent),
                                    onPressed: () =>
                                        _confirmDelete(context, product),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailPage(product: product),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}