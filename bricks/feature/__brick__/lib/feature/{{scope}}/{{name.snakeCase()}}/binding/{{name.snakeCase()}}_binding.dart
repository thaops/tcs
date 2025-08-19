import 'package:get/get.dart';
import '../logic/{{name.snakeCase()}}_controller.dart';
import '../domain/repositories/{{name.snakeCase()}}_repository.dart';
import '../domain/usecases/get_{{name.snakeCase()}}.dart';
import '../data/repositories/{{name.snakeCase()}}_repository_impl.dart';

class {{name.pascalCase()}}Binding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<{{name.pascalCase()}}Repository>(
      () => {{name.pascalCase()}}RepositoryImpl(),
    );

    // UseCase
    Get.lazyPut<Get{{name.pascalCase()}}>(
      () => Get{{name.pascalCase()}}(Get.find<{{name.pascalCase()}}Repository>()),
    );

    // Controller
    Get.lazyPut<{{name.pascalCase()}}Controller>(
      () => {{name.pascalCase()}}Controller(
        get{{name.pascalCase()}}: Get.find<Get{{name.pascalCase()}}>(),
      ),
    );
  }
}
