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
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 158, 213, 48)),
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
    List<String> dropdownItems = ['All', 'Work', 'Personal', 'Ideas'];
    String? selectedValue = dropdownItems.first;
    String? selectedValue2 = dropdownItems.first;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: controller3,
                decoration: const InputDecoration(
                  labelText: 'Search notes',
                  border: OutlineInputBorder(),
                ),
                onChanged: (query) {
                  controller.filterNotes(query);
                },
              ),
            ),
          ),
          SizedBox(
            width: 250,
            child: Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedValue2,
                  onChanged: (newValue) {
                    controller.filterCategories(newValue!);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Options',
                    border: OutlineInputBorder(),
                  ),
                  items: dropdownItems
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
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
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedValue,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        selectedValue = newValue;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Options',
                      border: OutlineInputBorder(),
                    ),
                    items: dropdownItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (controller2.text.isNotEmpty) {
                      controller.addNote(controller2.text, selectedValue!);
                      controller2.clear();
                    }
                  },
                  child: const Text('Add Note'),
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
                          Chip(
                            label: Text(
                              controller.notes[index].category, // Display the category
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor:
                                Colors.deepPurple, // Customizable color
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => controller.deleteNoteAt(
                                controller.filteredNotes[index].text, index),
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
                                      text:
                                          controller.filteredNotes[index].text);
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
