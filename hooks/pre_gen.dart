import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

// If you want this brick to generate bloc/cubit from another brick,
// then in addition to the variables from brick.yaml you need to pass the logger or the following variables
//
// 'state_manager': 'bloc' or 'cubit'
// if 'state_manager' == 'bloc'
//    'event_modifier': 'abstract' or 'sealed'
//    'state_type': 'abstract', 'sealed' or 'single_class'
void run(HookContext context) async {
  if (context.vars['use_bloc'] as bool) {
    if (!(context.vars['use_equatable'] as bool))
      context.logger.warn(
          'Since you are not using the Equatable package, you must manually override the == operator as well as hashCode for the bloc or cubit state classes for them to work correctly.');

    if (context.vars['state_manager'] == null) {
      final stateManager = context.logger.chooseOne<String>(
        'Which type of state manager to generate: bloc or cubit?',
        choices: ['bloc', 'cubit'],
        defaultValue: 'bloc',
      );

      context.vars['state_manager'] = stateManager;
    }

    if (context.vars['state_manager'] == 'bloc') {
      _setBlocEventModifiers(context);
      _setBlocStateModifiers(context);
    } else if (context.vars['state_manager'] == 'cubit') {
      context.vars['use_cubit'] = true;
      context.vars['use_bloc'] = false;
      // Null error otherwise
      context.vars['state_single_class'] = false;

      await _generateCubit(
        name: context.vars['feature_name'],
        style: (context.vars['use_equatable'] as bool) ? 'equatable' : 'basic',
        logger: context.logger,
      );
    }
  }
}

void _setBlocEventModifiers(HookContext context) {
  if (context.vars['event_modifier'] == null) {
    final eventModifier = context.logger.chooseOne<String>(
      'Which modifier for the event class should be used?',
      choices: ['abstract', 'sealed'],
      defaultValue: 'abstract',
      display: (choice) => choice == 'sealed' ? '$choice (Dart 3.0+)' : choice,
    );

    context.vars['event_modifier'] = eventModifier;
  }

  final eventModifier = context.vars['event_modifier'];
  context.vars.addAll({
    'event_abstract': eventModifier == 'abstract',
    'event_sealed': eventModifier == 'sealed',
  });
}

void _setBlocStateModifiers(HookContext context) {
  if (context.vars['state_type'] == null) {
    final stateType = context.logger.chooseOne<String>(
      'Which type of state class should be used?',
      choices: ['abstract', 'sealed', 'single_class'],
      defaultValue: 'abstract',
      display: (choice) {
        if (choice == 'sealed') return '$choice (Dart 3.0+)';
        if (choice == 'single_class') return '${choice.lowerCase} (enum state)';
        return choice;
      },
    );

    context.vars['state_type'] = stateType;
  }

  final stateType = context.vars['state_type'];
  context.vars.addAll({
    'state_abstract': stateType == 'abstract',
    'state_sealed': stateType == 'sealed',
    'state_single_class': stateType == 'single_class',
  });
}

Future<void> _generateCubit({
  required String name,
  required String style,
  required Logger logger,
}) async {
  final brick = Brick.version(name: 'cubit', version: '0.2.0');
  final generator = await MasonGenerator.fromBrick(brick);

  final directory = Directory(
    p.join(
      Directory.current.path,
      'lib',
      'features',
      name.snakeCase,
      'presentation',
      'cubit',
    ),
  );
  await directory.create(recursive: true);
  final target = DirectoryGeneratorTarget(directory);

  var vars = <String, dynamic>{'name': name, 'style': style};
  await generator.hooks.preGen(
    vars: vars,
    onVarsChanged: (v) => vars = v,
    workingDirectory: directory.path,
  );
  await generator.generate(
    target,
    vars: vars,
    logger: logger,
    fileConflictResolution: FileConflictResolution.overwrite,
  );
  await generator.hooks.postGen(vars: vars);
}
