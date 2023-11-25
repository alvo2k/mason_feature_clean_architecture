# Mason brick with clean architecture feature

[![License: MIT][license_badge]][license_link]

This brick generates the folder structure and empty classes for the new feature according to the clean architecture. Using this brick implies that you have the following folder structure in your project: ```lib/features/[feature_folder]```.

## Getting Started 

Make sure you have Mason installed. [installation guide](https://docs.brickhub.dev/installing)

```sh
dart pub global activate mason_cli
```

> NOTE: The following commands assume that you are in the project directory (where pubspec.yaml is located)

```sh
mason add feature_clean_architecture --git-url https://github.com/alvo2k/mason_feature_clean_architecture
```

```sh
mason make feature_clean_architecture
```
or
```sh
mason make feature_clean_architecture \
--feature_name "example brick" \
--generate_barrel_files true \
--use_equatable true \
--use_injectable false \
--use_json_serializable true \
--use_bloc true
```

## Variables ✨

The following table outlines the variables that can be used when generating a new feature folder:

| Variable       | Description                | Required | Type | Default |
|----------------| -------------------------- |----------| ---- | ------- | 
| `feature_name` | Name of the feature | `Yes`    | `string` | `"example brick"` |
| `generate_barrel_files`     | A barrel file is a collection of export statements for ease of importing. | `No`    | `bool` | `false` |
| `use_equatable`     | Whether to use the Equatable package. | `No`     | `bool` | `true` |
| `use_injectable`     | Whether to use the Injectable package (get_it generator). | `No`     | `bool` | `false` |
| `use_json_serializable`     | Whether to use the json_serializable package. | `No`     | `bool` | `true` |
| `use_bloc`     | Whether to use the flutter_bloc package (cubit is also supported). | `No`     | `bool` | `true` |

## Outputs 📦
The generated folder architecture will look like this:

```
lib/features/example_brick/
├── data
│   ├── datasources
│   │   └── example_brick_data_source.dart
│   ├── models
│   │   ├── example_brick_model.dart
│   │   └── models.dart
│   └── repositories
│       └── example_brick_repository_impl.dart
```
---
``` 
├── domain
│   ├── entities
│   │   ├── entities.dart
│   │   └── example_brick.dart
│   ├── repositories
│   │   └── example_brick_repository.dart
│   ├── usecases
│   │   ├── example_brick_usecase.dart
│   │   └── usecases.dart
│   └── view.dart
```
---
``` 
└── presentation
    ├── bloc
    │   ├── example_brick_bloc.dart
    │   ├── example_brick_event.dart
    │   └── example_brick_state.dart
    ├── pages
    │   └── example_brick_page.dart
    └── widgets
        ├── example_brick.dart
        └── view.dart
```

## Bloc events types
*Abstract:*
``` dart
part of 'example_brick_bloc.dart';

abstract class ExampleBrickEvent extends Equatable {}

class LoadExampleBrick extends ExampleBrickEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
```
*Sealed:*
``` dart
part of 'example_brick_bloc.dart';

sealed class ExampleBrickEvent extends Equatable {}

final class LoadExampleBrick extends ExampleBrickEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
```

## Bloc state types
*Abstract:*
``` dart
part of 'example_brick_bloc.dart';

abstract class ExampleBrickState extends Equatable {}

class ExampleBrickInitial extends ExampleBrickState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ExampleBrickLoading extends ExampleBrickState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ExampleBrickLoaded extends ExampleBrickState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
```
*Sealed:*
``` dart
part of 'example_brick_bloc.dart';

sealed class ExampleBrickState extends Equatable {}

final class ExampleBrickInitial extends ExampleBrickState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class ExampleBrickLoading extends ExampleBrickState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class ExampleBrickLoaded extends ExampleBrickState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
```
*Enum:*
``` dart
part of 'example_brick_bloc.dart';

class ExampleBrickState extends Equatable {
  const ExampleBrickState._({
    required this.status,
  });

  const ExampleBrickState.initial()
      : this._(status: ExampleBrickStatus.initial);

  final ExampleBrickStatus status;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  ExampleBrickState copyWith(
    ExampleBrickStatus? status,
  ) =>
      ExampleBrickState._(
        status: status ?? this.status,
      );
}

enum ExampleBrickStatus { initial, loading, loaded }
```

