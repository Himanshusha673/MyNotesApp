import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mynotes/features/feature/domain/entities/note_entity.dart';
import 'package:mynotes/features/feature/presentation/cubit/note/note_cubit.dart';

class UpdateNotePage extends StatefulWidget {
  final NoteEntity noteEntity;

  const UpdateNotePage({Key? key, required this.noteEntity}) : super(key: key);

  @override
  State<UpdateNotePage> createState() => _UpdateNotePageState();
}

class _UpdateNotePageState extends State<UpdateNotePage> {
  TextEditingController? _noteTextController;
  @override
  void initState() {
    _noteTextController = TextEditingController(text: widget.noteEntity.note);
    _noteTextController!.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Your Notes Here"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Text(
                "${DateFormat("dd MMM hh:mm a").format(DateTime.now())} | ${_noteTextController!.text.length} Characters",
                style: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(.5))),
            Expanded(
                child: Scrollbar(
                    child: TextFormField(
              controller: _noteTextController,
              maxLines: null,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Start Typing"),
            ))),
            InkWell(
              onTap: _submitUpdateNote,
              child: Container(
                height: 45,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitUpdateNote() {
    BlocProvider.of<NoteCubit>(context).updateNote(
        note: NoteEntity(
      note: _noteTextController!.text,
      noteId: widget.noteEntity.noteId,
      time: Timestamp.now(),
      uid: widget.noteEntity.uid,
    ));
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}
