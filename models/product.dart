import 'package:isar/isar.dart';

part 'product.g.dart';

@collection
class Product {
  Id id = Isar.autoIncrement;

  late String nama;
  late int harga;
  late String kategori;
  late String deskripsi;
  String gambarAsset = '';
  bool isFavorite = false;
}
