{{#use_json_serializable}}import 'package:json_annotation/json_annotation.dart';{{/use_json_serializable}}

import '../../domain/entities/{{feature_name.snakeCase()}}.dart';

{{#use_json_serializable}}part '{{feature_name.snakeCase()}}_model.g.dart';
@JsonSerializable(){{/use_json_serializable}}

class {{feature_name.pascalCase()}}Model extends {{feature_name.pascalCase()}} { 

{{#use_json_serializable}}
  const {{feature_name.pascalCase()}}Model();

  factory {{feature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) => _${{feature_name.pascalCase()}}ModelFromJson(json);

  Map<String, dynamic> toJson() => _${{feature_name.pascalCase()}}ModelToJson(this);
{{/use_json_serializable}}

{{#use_equatable}}  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
{{/use_equatable}}
}