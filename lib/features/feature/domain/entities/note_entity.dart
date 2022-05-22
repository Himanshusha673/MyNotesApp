import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  // we extand equatable clss because we can eqaute the parameters to each one of them
  final String? noteId;
  final String? note;
  final Timestamp? time;
  final String? uid;

  NoteEntity({this.note, this.noteId, this.time, this.uid});

  @override
  // TODO: implement props
  List<Object?> get props => [note, noteId, time, uid];
}
