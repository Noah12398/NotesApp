import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes/Note_model.dart';

class Controller extends GetxController {
  var notes = <Note>[];
  final notesBox = Hive.box('notesBox');
  var filteredNotes = <Note>[];
  String query2 = '';
  @override
  void onInit() {
    super.onInit();
    notes = notesBox.keys.map((key) => notesBox.get(key) as Note).toList();
    updateFilteredNotes();
    update();
  }

  void addNote(String text) {
    final newNote = Note(
      text: text,
      isFavorite: false,
    );
    notesBox.put(newNote.text, newNote);
    notes.add(newNote);
    updateFilteredNotes();
    update();
  }

  void updateFilteredNotes() {
    filteredNotes = query2.isEmpty
        ? notes.toList()
        : notes.where((note) => note.text.contains(query2)).toList();
  }

  deleteNoteAt(String text, int index) {
    notesBox.delete(text);
    notes = notesBox.values.toList().cast<Note>();
    updateFilteredNotes();
    update();
  }

  void editNoteAt(int index, String newNote) {
    final note = filteredNotes[index];
    String oldKey = note.text;
    note.text = newNote;
    notesBox.delete(oldKey);
    notesBox.put(newNote, note);
    int mainListIndex = notes.indexWhere((n) => n.text == oldKey);
    if (mainListIndex != -1) {
      notes[mainListIndex] = note;
    }
    updateFilteredNotes();
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

  void filterNotes(String query) {
    query2 = query;
    if (query.isEmpty) {
      filteredNotes = List.from(notes);
    } else {
      // Filter notes that contain the query (case-insensitive)
      filteredNotes = notes.where((note) {
        return note.text.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update(); // Notify listeners to update the UI
  }
}
