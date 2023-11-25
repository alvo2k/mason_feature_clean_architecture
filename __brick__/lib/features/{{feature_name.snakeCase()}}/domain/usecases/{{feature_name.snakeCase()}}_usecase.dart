{{#use_injectable}}import 'package:injectable/injectable.dart';{{/use_injectable}}
{{#generate_barrel_files}}import '../entities/entities.dart';{{/generate_barrel_files}}
{{^generate_barrel_files}}import '../entities/{{feature_name.snakeCase()}}.dart';{{/generate_barrel_files}}
import '../repositories/{{feature_name.snakeCase()}}_repository.dart';

{{#use_injectable}}@LazySingleton(){{/use_injectable}}
class {{feature_name.pascalCase()}}UseCase {
  {{feature_name.pascalCase()}}UseCase(this._repository);

  final {{feature_name.pascalCase()}}Repository _repository;
}