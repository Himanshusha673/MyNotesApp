import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/features/feature/domain/entities/note_entity.dart';
import 'package:mynotes/features/feature/domain/usecases/add_new_task_Usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/delete_note_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/get_notes_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/update_note_usecase.dart';
part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final GetNotesUsecase getNotesUsecase;
  final AddNewNoteUseCase addNewNoteUseCase;
  NoteCubit(
      {required this.addNewNoteUseCase,
      required this.deleteNoteUseCase,
      required this.getNotesUsecase,
      required this.updateNoteUseCase})
      : super(NoteInitial());

  Future<void> addNote({required NoteEntity note}) async {
    try {
      await addNewNoteUseCase.call(note);
    } on SocketException catch (_) {
      emit(NoteFailure());
    } catch (_) {
      emit(NoteFailure());
    }
  }

  Future<void> deleteNote({required NoteEntity note}) async {
    try {
      await deleteNoteUseCase.call(note);
    } on SocketException catch (_) {
      emit(NoteFailure());
    } catch (_) {
      emit(NoteFailure());
    }
  }

  Future<void> updateNote({required NoteEntity note}) async {
    try {
      await updateNoteUseCase.call(note);
    } on SocketException catch (_) {
      emit(NoteFailure());
    } catch (_) {
      emit(NoteFailure());
    }
  }

  Future<void> getNotes({required String uid}) async {
    emit(NoteLoading());
    try {
      getNotesUsecase.call(uid).listen((notes) {
        emit(NoteLoaded(notes: notes));
      });
    } on SocketException catch (_) {
      emit(NoteFailure());
    } catch (_) {
      emit(NoteFailure());
    }
  }
}
