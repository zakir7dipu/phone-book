
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_book/database/database_helper.dart';
import 'package:phone_book/model/contact.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(PhoneBookApp());

class PhoneBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phone Book',
      theme: new ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal,
      ),
      home: PhoneBookHome(title:'Phone Book'),
    );
  }
}

class PhoneBookHome extends StatefulWidget {
  final String title;
  PhoneBookHome({Key key, this.title}):super(key: key);
  @override
  _PhoneBookHomeState createState() => _PhoneBookHomeState();
}

class _PhoneBookHomeState extends State<PhoneBookHome> {
  Contact _contact = new Contact();
  DatabaseHelper _databaseHelper;
  List<Contact> _contacts = [];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _usernameEditController = TextEditingController();
  final TextEditingController _phoneNumberEditController = TextEditingController();
  final _insertFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();

  _refreshContactList() async{
    List<Contact> _data = await _databaseHelper.table1ReadAllRow();
    setState(() {
      _contacts = _data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _databaseHelper = DatabaseHelper.instance;
    });
    _refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: new AppBar(
            title: new Center(
              child: new Text(widget.title),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                listView(),
              ],
            ),
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () => _onpenForm(),
            child: new Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
    );
  }

  void _onpenForm(){
    Alert(
        context: context,
        title: "Add Contact",
        content: Form(
          key: _insertFormKey,
          child: Column(
            children: <Widget>[
              new TextFormField(
                controller: _usernameController,
                autocorrect: true,
                validator: (value){
                  if(value.isEmpty){
                    return 'Contact Name Can Not Empty';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  prefixIcon: new Icon(Icons.account_circle)
                ),
              ),
              new TextFormField(
                controller: _phoneNumberController,
                autocorrect: true,
                validator: (value){
                  if(value.isEmpty || value.length < 11){
                    return 'Phone Number Can Not Empty';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: new Icon(Icons.phone)
                ),
              )
            ],
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () => _handelInsertForm(),
            child: Text(
              "Add",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _handelInsertForm() async{
    var form = _insertFormKey.currentState;
    if(form.validate()){
      _contact.name = _usernameController.text;
      _contact.phone = _phoneNumberController.text;
      await _databaseHelper.table1CreateRow(_contact);
      _refreshContactList();
      form.reset();
      Navigator.pop(context);
    }
  }

  listView() => Expanded(
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView.builder(
          padding: EdgeInsets.all(8),
            itemBuilder: (context,index){
            return Column(
              children: [
                ListTile(
                  leading: new Icon(
                    Icons.account_circle,
                    color: Theme.of(context).primaryColor,
                    size: 40.0,
                  ),
                  title: new Text(
                    _contacts[index].name.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  subtitle: new Text(
                    _contacts[index].phone,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  trailing: IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: () async{
                      await _databaseHelper.table1DeleteRow(_contacts[index].id);
                      _refreshContactList();
                    },
                  ),
                  onTap: () => _openPopupAction(_contacts[index].id, _contacts[index].name, _contacts[index].phone),
                ),
                Divider(
                  height: 5.0,
                )
              ],
            );
            },
          itemCount: _contacts.length,
        ),
      )
  );

  _openPopupAction(int id, String name, String phone){
    Alert(
      context: context,
      // type: AlertType.error,
      title: name,
      desc: phone,
      buttons: [
        DialogButton(
          child: Text(
            "Call",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async{
            await launch("tel:$phone");
            Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          child: Text(
            "Edit",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => _openPopupEditForm(id,name,phone),
              // Navigator.pop(context),
          width: 120,
          color: Colors.green,
        ),
      ],
    ).show();
  }

  _openPopupEditForm(int id, String name, String phone){
    Navigator.pop(context);
    _usernameEditController.text = name;
    _phoneNumberEditController.text = phone;
    Alert(
        context: context,
        title: "Edit Contact",
        content: Form(
          key: _updateFormKey,
          child: Column(
            children: <Widget>[
              new TextFormField(
                controller: _usernameEditController,
                autocorrect: true,
                validator: (value){
                  if(value.isEmpty){
                    return 'Contact Name Can Not Empty';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'User Name',
                    prefixIcon: new Icon(Icons.account_circle)
                ),
              ),
              new TextFormField(
                controller: _phoneNumberEditController,
                autocorrect: true,
                validator: (value){
                  if(value.isEmpty || value.length < 11){
                    return 'Phone Number Can Not Empty';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: new Icon(Icons.phone)
                ),
              )
            ],
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () => _handelUpdateForm(id),
            child: Text(
              "Add",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _handelUpdateForm(int id) async{
    var _form = _updateFormKey.currentState;
    if(_form.validate()){
      _contact.id = id;
      _contact.name = _usernameEditController.text;
      _contact.phone = _phoneNumberEditController.text;
      await _databaseHelper.table1UpdateRow(_contact);
      _refreshContactList();
      _form.reset();
      Navigator.pop(context);
    }
  }

}