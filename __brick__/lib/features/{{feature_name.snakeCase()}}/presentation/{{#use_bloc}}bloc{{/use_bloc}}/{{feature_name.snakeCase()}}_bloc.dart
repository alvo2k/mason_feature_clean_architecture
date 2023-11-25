import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part '{{feature_name.snakeCase()}}_event.dart';
part '{{feature_name.snakeCase()}}_state.dart';

class {{feature_name.pascalCase()}}Bloc extends Bloc<{{feature_name.pascalCase()}}Event, {{feature_name.pascalCase()}}State> {
  {{feature_name.pascalCase()}}Bloc() : super({{#state_single_class}}const {{feature_name.pascalCase()}}State.initial(){{/state_single_class}}{{^state_single_class}}{{feature_name.pascalCase()}}Initial(){{/state_single_class}}) {
    on<Load{{feature_name.pascalCase()}}>(_load{{feature_name.pascalCase()}});
  }

  void _load{{feature_name.pascalCase()}}(
    Load{{feature_name.pascalCase()}} event,
    Emitter<{{feature_name.pascalCase()}}State> emit,
  ) {
    // TODO: implement event handler
  }
}
