import '../../domain/entities/{{name.snakeCase()}}_entity.dart';
import '../../domain/repositories/{{name.snakeCase()}}_repository.dart';
import '../models/{{name.snakeCase()}}_model.dart';

class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository {
  @override
  Future<{{name.pascalCase()}}Entity> fetch() async {
    // TODO: implement data source
    return {{name.pascalCase()}}Model();
  }
}
