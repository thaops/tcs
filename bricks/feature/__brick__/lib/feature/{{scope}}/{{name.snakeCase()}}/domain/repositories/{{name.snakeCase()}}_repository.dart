import '../entities/{{name.snakeCase()}}_entity.dart';

abstract class {{name.pascalCase()}}Repository {
  Future<{{name.pascalCase()}}Entity> fetch();
}
