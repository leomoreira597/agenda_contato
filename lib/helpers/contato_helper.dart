import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = 'contactTable';
final String idColumn = 'idColumn';
final String nameColumn = 'nameColumn';
final String emailColumn = 'emailColumn';
final String phoneColumn = 'phoneColumn';
final String imgColumn = 'imgColumn';

class ContactHelper {
  static ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;
  Database? _db;

  ContactHelper.internal();

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'Contacts.db');

    return await openDatabase(path, version: 1, onCreate: (
        Database db,
        int newVersion,
        ) async {
      await db.execute("""
      CREATE TABLE $contactTable(
      $idColumn INTEGER PRIMARY KEY, 
      $nameColumn TEXT,
      $emailColumn TEXT,
      $phoneColumn TEXT, 
      $imgColumn TEXT)
      """);
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    final dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact?> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(contactTable, where: '$idColumn = ?', whereArgs: [id]);
  }
  //Deleta todos os contatos, mas ainda não testei
  Future deleteAllContact() async {
    Database dbContact = await db;
    return await dbContact
        .delete(contactTable);
  }



  Future<int> updateContact(Contact contact) async {
    var dbContact = await db;
    return dbContact.update(contactTable, contact.toMap(),
        where: '$idColumn = ?', whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {
    var dbContact = await db;
    List listMaps = await dbContact.rawQuery('SELECT * FROM $contactTable');
    List<Contact> listContacts = [];
    for (Map map in listMaps) {
      listContacts.add(Contact.fromMap(map));
    }
    return listContacts;
  }

  //Método para obter a quantidade de contatos da tabela
  Future<int?> getNumberContacts() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(
      await dbContact.rawQuery('SELECT COUNT(*) FROM $contactTable'),
    );
  }
  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}

class Contact {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? img;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, phone: $phone, email: $email, img: $img)';
  }
}