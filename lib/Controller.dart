import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes/Note_model.dart';

class Controller extends GetxController {
  var notes = <Note>[];
  final notesBox = Hive.box('notesBox');
  var filteredNotes = <Note>[];
  String query2 = '';
  String query3 = 'All';

  @override
  void onInit() {
    super.onInit();
    notes = notesBox.keys.map((key) => notesBox.get(key) as Note).toList();
    updateFilteredNotes();
    update();
  }

  void addNote(String text, String selectedValue) {
    final newNote = Note(
      text: text,
      isFavorite: false,
      category: selectedValue,
    );
    notesBox.put(newNote.text, newNote);
    notes.add(newNote);
    updateFilteredNotes();
    update();
  }

  void updateFilteredNotes() {
    if (query2.isNotEmpty) {
      filteredNotes = notes.where((note) => note.text.contains(query2)).toList();
    } else if (query3 != 'All') {
      filteredNotes = notes.where((note) => note.category.toLowerCase().contains(query3.toLowerCase())).toList();
    } else {
      filteredNotes = List.from(notes);
    }
    update();
  }

  void deleteNoteAt(String text, int index) {
    notesBox.delete(text);
    notes.removeAt(index);
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
      updateFilteredNotes();
    } else {
      filteredNotes = notes.where((note) {
        return note.text.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update();
  }

  void filterCategories(String query) {
    query3 = query;
    if (query == 'All') {
      filteredNotes = List.from(notes);
    } else if (query.isEmpty) {
      filteredNotes = List.from(notes);
    } else {
      filteredNotes = notes.where((note) {
        return note.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    update();
  }
}
