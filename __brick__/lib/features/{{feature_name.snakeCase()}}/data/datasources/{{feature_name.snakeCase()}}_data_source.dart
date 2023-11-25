{{#generate_barrel_files}}import '../models/models.dart';{{/generate_barrel_files}}
{{^generate_barrel_files}}import '../models/{{feature_name.snakeCase()}}_model.dart';{{/generate_barrel_files}}

abstract class {{feature_name.pascalCase()}}DataSource {

}


class {{feature_name.pascalCase()}}DataSourceImpl implements {{feature_name.pascalCase()}}DataSource {

}