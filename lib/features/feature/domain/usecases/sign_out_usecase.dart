import 'package:mynotes/features/feature/domain/entities/user_entity.dart';
import 'package:mynotes/features/feature/domain/repositories/firebase_repository.dart';

class SignOutUseCase {
  final FirebaseRepository repository;
  SignOutUseCase({required this.repository});
  Future<void> call() async {
    return await repository.signOut();
  }
}
