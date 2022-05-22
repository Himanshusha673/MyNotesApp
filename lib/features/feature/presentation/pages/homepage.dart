import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mynotes/app_constant.dart';
import 'package:mynotes/features/feature/presentation/cubit/auth/auth_cubit.dart';
import 'package:mynotes/features/feature/presentation/cubit/note/note_cubit.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<NoteCubit>(context).getNotes(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyNotes"),
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
        return Center(child: CircularProgressIndicator());
        if (noteState is NoteLoaded) {
          return _bodyWidget(noteState);
        }
      }),
    );
  }

  Widget noNotesWidget() {
    return Center(
      child: Column(
        children: [
          Container(
            height: 80,
            child: Image.asset('assets/Images/NoteBook.png'),
          ),
          SizedBox(height: 20),
          Text('No notes here yet')
        ],
      ),
    );
  }

  Widget _bodyWidget(NoteLoaded noteLoadedState) {
    return Column(
      children: [
        Expanded(
          child: noteLoadedState.notes.isEmpty
              ? noNotesWidget()
              : GridView.builder(
                  itemCount: noteLoadedState.notes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
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
                              Text(
                                  "${DateFormat("dd MMMM YYYY HH:mm a").format(noteLoadedState.notes[index].time!.toDate())}"),
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
