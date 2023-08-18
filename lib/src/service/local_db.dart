import 'package:isar/isar.dart';
import 'package:loacal_notes/src/model/note.dart';
//import 'package:note_bucket/src/model/note.dart';

class LocalDBService {

  late Future<Isar> db;

  LocalDBService(){
    db = openDB();
  }

  Future<Isar> openDB() async {
    if(Isar.instanceNames.isEmpty){
      return await Isar.open([NoteSchema],inspector: true, directory: '',);
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveNote({required Note note}) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.notes.putSync(note));
  }

  Stream<List<Note>> listenAllNotes() async* {
    final isar = await db;
    yield* isar.notes.where().watch(fireImmediately: true);
  }

  void deleteNote({required int id}) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.notes.deleteSync(id));
  }
}