import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes/Note_model.dart';

class Controller extends GetxController {
  var notes = <Note>[];
  final notesBox = Hive.box('notesBox');

  @override
  void onInit() {
    super.onInit();
    notes = notesBox.keys.map((key) => notesBox.get(key) as Note).toList();
    update();
  }

  void addNote(String text) {
    final newNote = Note(
      text: text,
      isFavorite: false,
    );
    notesBox.put(newNote.text, newNote);
    notes.add(newNote);
    update();
  }

  deleteNoteAt(int index) {
    notes.removeAt(index);
    notesBox.deleteAt(index);
    update();
  }

  void editNoteAt(int index, String newNote) {
    final note = notes[index];
    note.text = newNote;
    notesBox.put(note.text, newNote);
    update();
  }

  void togglefavourite(int index) {
    final note = notes[index];
    note.isFavorite = !note.isFavorite;
    notesBox.put(note.text, note);
    update();
  }
  bool isfavourite(int index) {
    final note = notes[index];
    return note.isFavorite;
  }
}
