import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes/Controller.dart';

void main() async {
  await Hive.initFlutter();
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Controller controller = Get.put(Controller());
    final TextEditingController controller2 = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller2,
              decoration: const InputDecoration(
                labelText: 'Enter your note',
                border: OutlineInputBorder(),
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
            child: GetBuilder<Controller>(
              builder: (_) => ListView.builder(
                itemCount: controller.notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shadowColor: Colors.black,
                    child: ListTile(
                      title: Text(controller.notes[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => controller.deleteNoteAt(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () {
                              // Optional: Handle favorite action
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Color.fromARGB(255, 7, 7, 7)),
                            onPressed: () {
                              TextEditingController editController = TextEditingController(text: controller.notes[index]);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Edit Note"),
                                    content: TextField(
                                      controller: editController,
                                      decoration: const InputDecoration(hintText: "Enter new note"),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();  // Close the dialog
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Save"),
                                        onPressed: () {
                                          if (editController.text.isNotEmpty) {
                                            controller.editNoteAt(index, editController.text);
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

  hi() {
    print("sss");
  }
}
