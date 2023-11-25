{{#use_injectable}}import 'package:injectable/injectable.dart';{{/use_injectable}}
{{#generate_barrel_files}}import '../../domain/entities/entities.dart';{{/generate_barrel_files}}
{{^generate_barrel_files}}import '../../domain/entities/{{feature_name.snakeCase()}}.dart';{{/generate_barrel_files}}

import '../datasources/{{feature_name.snakeCase()}}_data_source.dart';
import '../../domain/repositories/{{feature_name.snakeCase()}}_repository.dart';

{{#use_injectable}}@LazySingleton(as: {{feature_name.pascalCase()}}Repository){{/use_injectable}}
class {{feature_name.pascalCase()}}RepositoryImpl implements {{feature_name.pascalCase()}}Repository {
  {{feature_name.pascalCase()}}RepositoryImpl(this.dataSource);

  final {{feature_name.pascalCase()}}DataSource dataSource;
}