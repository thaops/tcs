import '../entities/{{name.snakeCase()}}_entity.dart';
import '../repositories/{{name.snakeCase()}}_repository.dart';

class Get{{name.pascalCase()}} {
  final {{name.pascalCase()}}Repository repository;
  Get{{name.pascalCase()}}(this.repository);

  Future<{{name.pascalCase()}}Entity> call() => repository.fetch();
}
