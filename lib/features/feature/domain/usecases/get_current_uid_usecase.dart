import 'package:mynotes/features/feature/domain/entities/note_entity.dart';
import 'package:mynotes/features/feature/domain/entities/user_entity.dart';
import 'package:mynotes/features/feature/domain/repositories/firebase_repository.dart';

class GetCurrentUidUsecase {
  final FirebaseRepository repository;
  GetCurrentUidUsecase({required this.repository});
  Future<String> call() async {
    return repository.getCurrentUid();
  }
}
