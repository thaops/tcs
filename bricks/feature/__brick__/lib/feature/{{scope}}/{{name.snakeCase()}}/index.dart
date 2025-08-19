export 'binding/{{name.snakeCase()}}_binding.dart';
export 'logic/{{name.snakeCase()}}_controller.dart';
export 'view/{{name.snakeCase()}}_screen.dart';

export 'domain/entities/{{name.snakeCase()}}_entity.dart';
export 'domain/repositories/{{name.snakeCase()}}_repository.dart';
export 'domain/usecases/get_{{name.snakeCase()}}.dart';

export 'data/models/{{name.snakeCase()}}_model.dart';
export 'data/repositories/{{name.snakeCase()}}_repository_impl.dart';

export '{{name.snakeCase()}}_routes.dart';
