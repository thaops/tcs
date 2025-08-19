import 'package:get/get.dart';
import 'binding/{{name.snakeCase()}}_binding.dart';
import 'view/{{name.snakeCase()}}_screen.dart';

class {{name.pascalCase()}}Routes {
  static const String route = '/{{name.paramCase()}}';

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: route,
      page: () => const {{name.pascalCase()}}Screen(),
      binding: {{name.pascalCase()}}Binding(),
    ),
  ];
}
