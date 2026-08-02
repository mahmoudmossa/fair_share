import 'package:dartz/dartz.dart';
import '../repositories/{{feature_name.snakeCase()}}_repository.dart';

class {{feature_name.pascalCase()}}UseCase {
  final {{feature_name.pascalCase()}}Repository _repository;

  const {{feature_name.pascalCase()}}UseCase(this._repository);

  // TODO: Implement use case call method
  // Example:
  // Future<Either<Exception, void>> call() async {
  //   return _repository.someMethod();
  // }
}
