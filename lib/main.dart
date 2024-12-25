import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes/Controller.dart';
import 'package:notes/Note_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox('notesBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Notes App'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    Controller controller = Get.put(Controller());
    final TextEditingController controller2 = TextEditingController();
    final TextEditingController controller3 = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller2,
                    decoration: const InputDecoration(
                      labelText: 'Enter your note',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller2.text.isNotEmpty) {
                    controller.addNote(controller2.text);
                    controller2.clear();
                  }
                },
                child: const Text('Add Note'),
              ),
              Expanded(
                child: TextField(
                  controller: controller3,
                  decoration: const InputDecoration(
                    labelText: 'Search notes',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (query) {
                    controller.filterNotes(controller3.text); 
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: GetBuilder<Controller>(
              builder: (_) => ListView.builder(
                itemCount: controller.filteredNotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shadowColor: Colors.black,
                    child: ListTile(
                      title: Text(controller.filteredNotes[index].text),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => controller.deleteNoteAt(controller.filteredNotes[index].text,index),
                          ),
                          IconButton(
                            icon: Icon(Icons.favorite,
                                color: controller.isfavourite(index)
                                    ? Colors.red
                                    : Colors.black),
                            onPressed: () {
                              controller.togglefavourite(index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color.fromARGB(255, 7, 7, 7)),
                            onPressed: () {
                              TextEditingController editController =
                                  TextEditingController(
                                      text: controller.filteredNotes[index].text);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Edit Note"),
                                    content: TextField(
                                      controller: editController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter new note"),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Save"),
                                        onPressed: () {
                                          if (editController.text.isNotEmpty) {
                                            controller.editNoteAt(
                                                index, editController.text);
                                          }
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
