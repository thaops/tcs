import 'package:get/get.dart';

import '../domain/usecases/get_{{name.snakeCase()}}.dart';

class {{name.pascalCase()}}Controller extends GetxController {
  {{name.pascalCase()}}Controller({required this.get{{name.pascalCase()}}});

  final Get{{name.pascalCase()}} get{{name.pascalCase()}};

  // Rx states
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      await get{{name.pascalCase()}}();
    } finally {
      isLoading.value = false;
    }
  }
}
