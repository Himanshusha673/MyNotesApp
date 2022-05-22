import 'package:mynotes/features/feature/domain/entities/note_entity.dart';
import 'package:mynotes/features/feature/domain/entities/user_entity.dart';
import 'package:mynotes/features/feature/domain/repositories/firebase_repository.dart';

class GetNotesUsecase {
  final FirebaseRepository repository;
  GetNotesUsecase({required this.repository});
  Stream<List<NoteEntity>> call(String uid) {
    return repository.getNotes(uid);
  }
}
