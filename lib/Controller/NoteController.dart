import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/Model/NoteModel.dart';

class NoteController extends GetxController {
  final db = FirebaseFirestore.instance;
  RxList<NoteModel> notes = <NoteModel>[].obs;

  void onInit() {
    getNotes();
    super.onInit();
  }

  Future<void> addNote(NoteModel note) async {
    try {
      notes.clear();
      await db.collection("notes").doc(note.id).set(
            note.toJson(),
          );
      getNotes();
      Get.back();
      Get.snackbar(
        'Note Added',
        'Note Added',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (ex) {
      print(ex);
    }
  }

  Stream<List<NoteModel>> getNote() {
    return db.collection("notes").snapshots().map((snapshot) => snapshot.docs
        .map(
          (doc) => NoteModel.fromJson(
            doc.data(),
          ),
        )
        .toList());
  }

  Future<void> getNotes() async {
    await db.collection("notes").get().then(
          (value) => {
            notes.value =
                value.docs.map((e) => NoteModel.fromJson(e.data())).toList()
          },
        );
  }

  Future<void> deleteNote(String id) async {
    await db.collection("notes").doc(id).delete();
    getNotes();
    Get.back();
    Get.snackbar(
      'Note Deleted',
      'Note Deleted',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
