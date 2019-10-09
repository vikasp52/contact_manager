import 'dart:async';
import 'dart:io';

import 'package:contact_manager/model/contect_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static final DataBaseHelper _instance = DataBaseHelper.internal();

  factory DataBaseHelper() => _instance;

  //Contact Table variable
  final String tableContactManager = "ContectManagerTable";
  final String contactIdCol = "contactId";
  final String nameCol = "name";
  final String dobCol = "dob";
  final String mobNoCol = "mobileNo";
  final String profilePicUrlCol = "profilePhotoUrl";
  final String favouriteCol = "favourite";

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDb();
    }
    return _db;
  }

  DataBaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "ContectManager1.db");
    var ourDb = await openDatabase(path, version: 2, onCreate: _onConfigure);
    return ourDb;
  }

  void _onConfigure(Database db, int version) async {
    //Contact Table
    await db.execute("""
    CREATE TABLE $tableContactManager(
    $contactIdCol INTEGER PRIMARY KEY AUTOINCREMENT,
    $nameCol TEXT,
    $dobCol TEXT,
    $mobNoCol TEXT,
    $profilePicUrlCol TEXT,
    $favouriteCol TEXT)
    """);
  }

  // Insertion into Contact
  Future<int> saveContactData(ContactModel item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableContactManager", item.toMap());
    return res;
  }

  //Get Contact data
  Future<List> getContactList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableContactManager");
    print("DataBase Table \n $result");
    return result.toList();
  }

  Future<int> updateContact(ContactModel item) async {
    var dbClient = await db;
    return await dbClient.update("$tableContactManager", item.toMap(),
        where: "$contactIdCol = ?", whereArgs: [item.contactId]);
  }

  Future<List> getFavouriteContacts(String status) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableContactManager WHERE $favouriteCol = ?", [status]);
    print("Favourite DataBase Table \n $result");
    return result.toList();
  }

  Future<int> updateFavouriteContact({int contactId, String favourite}) async {
    var dbClient = await db;

    return await dbClient.rawUpdate(
        'UPDATE $tableContactManager SET $favouriteCol = ? WHERE $contactIdCol = ?',
        [favourite, contactId]);

  }

  //Call this method if Item is deleted from Contact
  Future<int> deleteContactItems(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableContactManager, where: "$contactIdCol = ?", whereArgs: [id]);
  }
}
