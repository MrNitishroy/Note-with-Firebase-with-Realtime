import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:notes/Config.dart';
import 'package:notes/Controller/NoteController.dart';

import '../Model/NoteModel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    NoteController notesController = Get.put(NoteController());
    TextEditingController title = TextEditingController();
    TextEditingController des = TextEditingController();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'NOTE WITH FIREBASE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Get.bottomSheet(
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                children: [
                  const Text(
                    'Add Note',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: title,
                    decoration: const InputDecoration(
                      fillColor: containerColor,
                      filled: true,
                      hintText: 'Note title',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: des,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      fillColor: containerColor,
                      filled: true,
                      hintText: 'Description',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      String id =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      if (title.text.isNotEmpty && des.text.isNotEmpty) {
                        NoteModel note = NoteModel(
                          id: id,
                          title: title.text,
                          description: des.text,
                          timeStamp: id,
                        );
                        await notesController.addNote(note);
                        title.clear();
                        des.clear();
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please fill all the fields',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    icon: Icon(Icons.save),
                    label: Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder(
            stream: notesController.getNote(),
            builder: ((context, snapshot) {
              List<NoteModel> notes = snapshot.data!;
              return GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: notes
                    .map(
                      (e) => Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: containerColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    e.title ?? "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          color: Colors.white,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.edit),
                                                title: Text('Edit'),
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  notesController
                                                      .deleteNote(e.id!);
                                                },
                                                leading: Icon(Icons.delete),
                                                title: Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    Icons.more_vert,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    e.description ?? "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              );
            }),
          )),
    );
  }
}
