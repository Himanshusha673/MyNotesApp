import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/features/feature/data/models/note_model.dart';
import 'package:mynotes/features/feature/data/models/user_model.dart';
import 'package:mynotes/features/feature/domain/entities/user_entity.dart';

import 'package:mynotes/features/feature/domain/entities/note_entity.dart';

import 'firebase_remote_data_source.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseRemoteDataSourceImpl({required this.auth, required this.firestore});

  @override
  Future<void> addNewNote(NoteEntity noteEntity) async {
    final noteCollectionref =
        firestore.collection("users").doc(noteEntity.uid).collection("notes");
    final noteId = noteCollectionref.doc().id;
    noteCollectionref.doc(noteId).get().then((note) {
      final newNote = NoteModel(
              note: noteEntity.note,
              noteId: noteId,
              uid: noteEntity.uid,
              time: noteEntity.time)
          .todocument();

      if (!note.exists) {
        noteCollectionref.doc(noteId).set(newNote);
      }
      return;
    });
  }

  @override
  Future<void> deleteNote(NoteEntity noteEntity) async {
    final noteCollectionref =
        firestore.collection("users").doc(noteEntity.uid).collection("notes");
    noteCollectionref.doc(noteEntity.noteId).get().then((note) {
      if (note.exists) {
        noteCollectionref.doc(noteEntity.noteId).delete();
      }
      return;
    });
  }

  @override
  //when we signup
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollectioneRef = firestore.collection("users");
    final uid = await getCurrentUid();
    userCollectioneRef.doc(user.uid).get().then((value) {
      final newUser = UserModel(
        uid: uid,
        status: user.status,
        email: user.email,
        name: user.name,
      ).todocument();
      if (!value.exists) {
        userCollectioneRef.doc(uid).set(newUser);
      }
      return;
    });
  }

  @override
  Future<String> getCurrentUid() async => auth.currentUser!.uid;

  @override
  Stream<List<NoteEntity>> getNotes(String uid) {
    final noteColectionRef =
        firestore.collection("users").doc(uid).collection("notes");
    return noteColectionRef.snapshots().map((querySnap) {
      return querySnap.docs
          .map((docSnap) => NoteModel.fromSnapshot(docSnap))
          .toList();
    });
  }

  @override
  Future<bool> isSignIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> signIn(UserEntity user) async => auth.signInWithEmailAndPassword(
      email: user.email!, password: user.password!);

  @override
  Future<void> signOut() async => auth.signOut();

  @override
  Future<void> signUp(UserEntity user) async =>
      auth.createUserWithEmailAndPassword(
          email: user.email!, password: user.password!);

  @override
  Future<void> updateNote(NoteEntity noteEntity) async {
    Map<String, dynamic> noteMap = Map();
    final noteColectionRef =
        firestore.collection("users").doc(noteEntity.uid).collection("notes");
    if (noteEntity.note != null) noteMap['note'] = noteEntity.note;
    if (noteEntity.time != null) noteMap['time'] = noteEntity.time;
    noteColectionRef.doc(noteEntity.noteId).update(noteMap);
  }
}
