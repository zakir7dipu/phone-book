import 'package:intl/intl.dart';
class Contact{
  static const tblContact = 'Contacts';
  static const colId = 'id';
  static const colName = 'name';
  static const colPhone = 'phone';
  static const colCreateAt = 'create_at';
  static const colUpdateAt = 'update_at';

  Contact({this.id,this.name,this.phone});

  Contact.fromMap(Map<String,dynamic> map){
    id = map[colId];
    name = map[colName];
    phone = map[colPhone];
  }

  int id;
  String name;
  String phone;

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      colName:name, colPhone:phone, colCreateAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),colUpdateAt:DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
    };

    if(id != null) map[colId] = id;
    /* or
    if(id != null){
    map[colId] = id;
    }
     */
    return map;
  }
}