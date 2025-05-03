import 'package:moneymate/data/app_db.dart';



class TransactionDb {
  final AppDatabase db;
  
  TransactionDb(this.db);

  Future<void> addProduct(TransactionTableCompanion  data) async {
    await db.into(db.transactionTable).insert(data);
  }

  Future<List<TransactionTableData>> getAllProducts() async {
    return await db.select(db.transactionTable).get();
  }
  Future<List<TransactionTableData>> getProductById(int id) async {
    return await (db.select(db.transactionTable)..where((tbl) => tbl.id.equals(id))).get();
  }
  Future<void> updateProduct(TransactionTableCompanion  data) async {
    await db.update(db.transactionTable).replace(data);
  }
  Future<void> deleteProduct(int id) async {
    await (db.delete(db.transactionTable)..where((tbl) => tbl.id.equals(id))).go();
  }
  Future<void> deleteAllProducts() async {
    await db.delete(db.transactionTable).go();
  }

}


