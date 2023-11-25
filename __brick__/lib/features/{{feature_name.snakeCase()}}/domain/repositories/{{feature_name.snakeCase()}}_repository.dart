{{#generate_barrel_files}}import '../entities/entities.dart';{{/generate_barrel_files}}
{{^generate_barrel_files}}import '../entities/{{feature_name.snakeCase()}}.dart';{{/generate_barrel_files}}

abstract class {{feature_name.pascalCase()}}Repository {

}