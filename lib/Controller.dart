import 'package:get/get.dart';
import 'package:hive/hive.dart';

class Controller extends GetxController {
  var notes = <String>[];
  final notesBox = Hive.box('notesBox');

  @override
  void onInit() {
    super.onInit();
    notes = notesBox.keys.map((key) => notesBox.get(key) as String).toList();
    update();
  }

  void addNote(String note) {
    Note newNote = Note(text: noteText, isFavorite: isFavorite);
    notes.add(newNote);
    notesBox.put(note, note);
    update();
  }

  deleteNoteAt(int index) {
    notes.removeAt(index);
    notesBox.deleteAt(index);
    update();
  }

  void editNoteAt(int index, String newNote) {
    notes[index] = newNote;
    notesBox.put(notes[index], newNote);
    update();
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hive_flutter/adapters.dart';

// // Controller to manage state with GetX
// class Controller extends GetxController {
//   var notes = <String>[]; // Regular list for notes
//   final notesBox = Hive.box('notesBox');

//   // Initialize notes from Hive
//   @override
//   void onInit() {
//     super.onInit();
//     notes = notesBox.keys.map((key) => notesBox.get(key)).toList();
//     update(); // Notify listeners of state change
//   }

//   // Add a new note
//   void addNote(String note) {
//     notes.add(note);
//     notesBox.put(note, note);
//     update(); // Notify listeners
//   }

//   // Delete a note
//   void deleteNoteAt(int index) {
//     String note = notes[index];
//     notes.removeAt(index);
//     notesBox.delete(note);
//     update(); // Notify listeners
//   }
// }

// void main() async {
//   await Hive.initFlutter();
//   await Hive.openBox('notesBox');
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Notes App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Notes App'),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     // Access the controller
//     final Controller controller = Get.put(Controller());

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(title),
//       ),
//       body: GetBuilder<Controller>(
//         builder: (_) => ListView.builder(
//           itemCount: controller.notes.length,
//           itemBuilder: (context, index) {
//             return Card(
//               elevation: 3,
//               shadowColor: Colors.black,
//               child: ListTile(
//                 title: Text(controller.notes[index]),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () => controller.deleteNoteAt(index),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.favorite, color: Colors.red),
//                       onPressed: () {
//                         // Optional: Handle favorite action
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Add a sample note
//           Get.defaultDialog(
//             title: "Add Note",
//             content: TextField(
//               onSubmitted: (value) {
//                 if (value.isNotEmpty) {
//                   controller.addNote(value);
//                   Get.back();
//                 }
//               },
//               decoration: const InputDecoration(hintText: "Enter your note"),
//             ),
//           );
//         },
//         tooltip: 'Add Note',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
