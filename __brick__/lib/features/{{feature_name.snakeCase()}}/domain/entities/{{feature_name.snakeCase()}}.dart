{{#use_equatable}}import 'package:equatable/equatable.dart';{{/use_equatable}}

class {{feature_name.pascalCase()}} {{#use_equatable}}extends Equatable {{/use_equatable}}{
  const {{feature_name.pascalCase()}}();
  
{{#use_equatable}}
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
{{/use_equatable}}
}