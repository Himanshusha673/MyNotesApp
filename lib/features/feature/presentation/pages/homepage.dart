import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mynotes/app_constant.dart';
import 'package:mynotes/features/feature/presentation/cubit/auth/auth_cubit.dart';
import 'package:mynotes/features/feature/presentation/cubit/note/note_cubit.dart';
import 'package:mynotes/main.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<Color> notesColor = [
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.yellow.shade100,
    Colors.redAccent.shade100,
    Colors.blueAccent.shade100,
    Colors.pink.shade100,
  ];
  @override
  void initState() {
    BlocProvider.of<NoteCubit>(context).getNotes(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("MyNotes"),
        actions: [
          IconButton(
              onPressed: (() {
                BlocProvider.of<AuthCubit>(context).loggedOut();
              }),
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        splashColor: Colors.red,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, PageConst.addNotePage,
              arguments: widget.uid);
        },
      ),
      body: BlocBuilder<NoteCubit, NoteState>(builder: (context, noteState) {
        if (noteState is NoteLoaded) {
          return _bodyWidget(noteState);
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }

  static Widget _noNotesWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            child: Image.asset('assets/Images/notebook.png'),
          ),
          SizedBox(height: 20),
          Text('No notes here yet')
        ],
      ),
    );
  }

  Widget _bodyWidget(NoteLoaded noteLoadedState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: noteLoadedState.notes.isEmpty
              ? _noNotesWidget()
              : GridView.builder(
                  itemCount: noteLoadedState.notes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (_, index) {
                    int randomColor = Random().nextInt(notesColor.length - 1);
                    return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: notesColor[randomColor],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.2),
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  offset: Offset(0, 0.5)),
                            ]),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(6),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${noteLoadedState.notes[index].note}',
                                  maxLines: 6, overflow: TextOverflow.ellipsis),
                              SizedBox(
                                height: 4,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.black)),
                                child: Text(
                                  "${DateFormat("dd MMM yy HH:mm a").format(
                                    noteLoadedState.notes[index].time!.toDate(),
                                  )}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.deepOrange, fontSize: 13),
                                ),
                              ),
                            ]),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.UpdateNotePage,
                            arguments: noteLoadedState.notes[index]);
                      },
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Are You Sure'),
                                content:
                                    Text('Do you want to delete this note'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      BlocProvider.of<NoteCubit>(context)
                                          .deleteNote(
                                              note:
                                                  noteLoadedState.notes[index]);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No'),
                                  ),
                                ],
                              );
                            });
                      },
                    );
                  }),
        ),
      ],
    );
  }
}
