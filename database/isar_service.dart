import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class IsarService {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [ProductSchema],
      directory: dir.path,
    );
  }

  Future<void> addProduct(Product product) async {
    await isar.writeTxn(() async {
      await isar.products.put(product);
    });
  }

  Future<List<Product>> getAllProducts() async {
    return await isar.products.where().findAll();
  }

  Future<void> updateProduct(Product product) async {
    await isar.writeTxn(() async {
      await isar.products.put(product);
    });
  }

  Future<void> deleteProduct(int id) async {
    await isar.writeTxn(() async {
      await isar.products.delete(id);
    });
  }

  Future<int> countProducts() async {
    return await isar.products.count();
  }

  Future<List<Product>> getRecentProducts() async {
    final all = await isar.products.where().findAll();
    final sorted = all.reversed.toList();
    return sorted.take(3).toList();
  }

  Future<void> toggleFavorite(Product product) async {
    product.isFavorite = !product.isFavorite;
    await isar.writeTxn(() async {
      await isar.products.put(product);
    });
  }

  Future<List<Product>> getFavoriteProducts() async {
    return await isar.products.filter().isFavoriteEqualTo(true).findAll();
  }

  Future<void> seedData() async {
    final count = await countProducts();
    if (count > 0) return;

    final produkContoh = [
      Product()
        ..nama = 'Kaos Kampus'
        ..harga = 85000
        ..kategori = 'Pakaian'
        ..deskripsi = 'Kaos cotton combed 30s dengan logo kampus, tersedia berbagai ukuran S-XL. Cocok untuk kegiatan sehari-hari maupun acara organisasi.'
        ..gambarAsset = '',
      Product()
        ..nama = 'Hoodie Kampus'
        ..harga = 180000
        ..kategori = 'Pakaian'
        ..deskripsi = 'Hoodie fleece tebal dengan bordir nama kampus, hangat dan nyaman dipakai saat cuaca dingin atau kegiatan outdoor.'
        ..gambarAsset = '',
      Product()
        ..nama = 'Kemeja PDH'
        ..harga = 120000
        ..kategori = 'Pakaian'
        ..deskripsi = 'Kemeja pakaian dinas harian dengan bahan katun premium, cocok untuk acara formal kampus.'
        ..gambarAsset = '',
      Product()
        ..nama = 'Tote Bag Kanvas'
        ..harga = 50000
        ..kategori = 'Aksesoris'
        ..deskripsi = 'Tas kanvas serbaguna dengan desain minimalis logo kampus, kuat dan ramah lingkungan untuk membawa buku atau laptop.'
        ..gambarAsset = '',
      Product()
        ..nama = 'Gantungan Kunci'
        ..harga = 15000
        ..kategori = 'Aksesoris'
        ..deskripsi = 'Gantungan kunci akrilik dengan logo kampus, cocok sebagai aksesoris atau cinderamata.'
        ..gambarAsset = '',
      Product()
        ..nama = 'Pin Enamel'
        ..harga = 12000
        ..kategori = 'Aksesoris'
        ..deskripsi = 'Pin logam berlapis enamel dengan desain logo kampus, dapat dipasang di tas atau jaket.'
        ..gambarAsset = '',
      Product()
        ..nama = 'Tumbler Stainless'
        ..harga = 75000
        ..kategori = 'Minuman'
        ..deskripsi = 'Tumbler stainless steel 500ml, menjaga minuman tetap dingin atau hangat hingga 6 jam, dengan cetakan logo kampus.'
        ..gambarAsset = '',
      Product()
        ..nama = 'Botol Minum Plastik'
        ..harga = 35000
        ..kategori = 'Minuman'
        ..deskripsi = 'Botol minum plastik BPA-free 600ml dengan desain transparan dan stiker logo kampus.'
        ..gambarAsset = '',
      Product()
        ..nama = 'Stiker Pack'
        ..harga = 10000
        ..kategori = 'Souvenir'
        ..deskripsi = 'Paket stiker vinyl anti air berisi 5 desain logo dan maskot kampus, cocok untuk laptop atau botol minum.'
        ..gambarAsset = '',
      Product()
        ..nama = 'Notebook A5'
        ..harga = 28000
        ..kategori = 'Souvenir'
        ..deskripsi = 'Buku catatan A5 hardcover dengan logo kampus di sampul, isi 100 lembar kertas HVS 70gsm.'
        ..gambarAsset = '',
      Product()
        ..nama = 'Lanyard ID Card'
        ..harga = 15000
        ..kategori = 'Souvenir'
        ..deskripsi = 'Tali lanyard untuk kartu identitas mahasiswa dengan cetakan logo dan nama kampus.'
        ..gambarAsset = '',
    ];

    await isar.writeTxn(() async {
      for (final produk in produkContoh) {
        await isar.products.put(produk);
      }
    });
  }
}