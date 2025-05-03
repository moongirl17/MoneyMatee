import 'package:drift/drift.dart';

class TransactionTable extends Table {

  @override
  String get tableName => 'transaction'; // Nama tabel
  
  IntColumn get id => integer().autoIncrement()(); // Primary key
  TextColumn get category => text().withLength(min: 1, max: 50)();// Foreign key dari tabel kategori
  DateTimeColumn get date => dateTime()(); // Tanggal transaksi
  TextColumn get type => text().withLength(min: 1, max: 10)(); // Jenis transaksi (debit/kredit)
  IntColumn get amount => integer()(); // Jumlah transaksi
  DateTimeColumn get createdAt => dateTime()(); // Tanggal dibuat
  DateTimeColumn get updatedAt => dateTime()(); // Tanggal diperbarui
  DateTimeColumn get deletedAt => dateTime().nullable()(); // Tanggal dihapus (jika ada)

}

