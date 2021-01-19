import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:phone_book/model/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static final _bdName = 'phoneBook.db';
  static final _dbVersion = 1;
  // static final _table1 = Contact.tblContact;
  //
  // static final table1ColumnId = Contact.colId;
  // static final table1ColumnName = Contact.colName;
  // static final table1ColumnPhoneNumber = Contact.colPhone;
  // static final table1ColumnCreateAt = Contact.colCreateAt;
  // static final table1ColumnUpdateAt = Contact.colUpdateAt;


  //making it a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future <Database> get database async{
    if(_database != null){
      return _database;
    }else{
      _database = await _initiateDatabase();
      return _database;
    }
  }

  _initiateDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,_bdName);
    return await openDatabase(path,version: _dbVersion, onCreate: _onCreate);
  }

  // creating Table
  Future _onCreate(Database db, int version){
    db.execute(
        '''
        CREATE TABLE ${Contact.tblContact}(
          ${Contact.colId} INTEGER PRIMARY KEY,
          ${Contact.colName} TEXT NOT NULL,
          ${Contact.colPhone} TEXT NOT NULL,
          ${Contact.colCreateAt} TIMESTAMP NULL,
          ${Contact.colUpdateAt} TIMESTAMP NULL
        )
        '''
    );
  }


  // creating insert into table
  Future<int> table1CreateRow(Contact contact) async{
    Database db = await instance.database;
    return await db.insert(Contact.tblContact, contact.toMap());
  }

  // creating read from table
  Future<List<Contact>> table1ReadAllRow() async{
    Database db = await instance.database;
    List<Map> contacts = await db.query(Contact.tblContact);
    return contacts.length == 0?
    []:contacts.map((e) => Contact.fromMap(e)).toList();
  }

  // creating update from table
  Future<int> table1UpdateRow(Contact contact) async{
    Database db = await instance.database;
    int id = contact.id;
    return await db.update(Contact.tblContact, contact.toMap(),where:'${Contact.colId} = ?',whereArgs: [id]);
  }

  // creating delete from table
  Future<int> table1DeleteRow(int id) async{
    Database db = await instance.database;
    return await db.delete(Contact.tblContact,where: '${Contact.colId} = ?',whereArgs: [id]);
  }
}
