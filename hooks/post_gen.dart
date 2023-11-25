import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

void run(HookContext context) async {
  final featureFolderName = (context.vars['feature_name'] as String).snakeCase;
  final pathToFeatureFolder = p.join('lib', 'features', featureFolderName);
  // context.vars['feature_folder_path'] = pathToFeatureFolder;
  // context.vars['feature_folder_name'] = featureFolderName;

  // if (context.vars['use_bloc']) {
  //   await _generateBloc(context);

  //   context.vars['bloc_type'].contains('cubit')
  //       ? context.vars['bloc_type'] = 'cubit'
  //       : context.vars['bloc_type'] = 'bloc';
  //   await _modifyBlocInstallation(context);
  // }

  await _formatCode(pathToFeatureFolder, context);

  if (context.vars['use_injectable'] || context.vars['use_json_serializable']) {
    await _runBuildRunner(pathToFeatureFolder, context);
  }
}

Future<void> _formatCode(
  String pathToFeatureFolder,
  HookContext context,
) async {
  final progress =
      context.logger.progress('Running: dart format $pathToFeatureFolder');

  await Process.run('dart', ['format', pathToFeatureFolder]);

  progress.complete();
}

Future<void> _runBuildRunner(
  String pathToFeatureFolder,
  HookContext context,
) async {
  final limitToFeatureFolder = !(context.vars['use_injectable'] as bool);
  final buildFilter = p.join(pathToFeatureFolder, '**');

  final progress = context.logger.progress(
    'Running: dart run build_runner build ${limitToFeatureFolder ? '--build-filter=$buildFilter' : ''}',
  );

  final result = await Process.run('dart', [
    'run',
    'build_runner',
    'build',
    //* Since @InjectableInit() and injectable.config.dart are outside our feature folder,
    //* in order to regenerate them we need to run build_runner at the root level of the project,
    //* otherwise we can limit build_runner to the feature folder.
    if (limitToFeatureFolder) '--build-filter=$buildFilter',
  ]);

  if (result.exitCode == 0) {
    progress.complete();
  } else {
    context.logger.err(result.stderr);
    progress.fail(
      'Running build_runner failed with exit code ${result.exitCode}',
    );
  }
}

Future<void> _generateBloc(HookContext context) async {
  final brick = Brick.version(
    name: 'flutter_bloc_feature',
    version: '0.3.0',
  );
  final generator = await MasonGenerator.fromBrick(brick);

  final presentationPath = p.join(
    context.vars['feature_folder_path'],
    'presentation',
  );
  final generateDirectory = Directory(presentationPath);

  final blocType = context.logger.chooseOne<String>(
    'What type of bloc do you want to use?',
    choices: [
      'bloc',
      'cubit',
      'hydrated_bloc',
      'hydrated_cubit',
      'replay_bloc',
      'replay_cubit',
    ],
  );
  context.vars['bloc_type'] = blocType;

  var vars = <String, dynamic>{
    'name': context.vars['feature_name'],
    'style': context.vars['use_equatable'] ? 'equatable' : 'basic',
    'type': blocType,
  };
  await generator.hooks.preGen(
    vars: vars,
    onVarsChanged: (v) => vars = v,
    workingDirectory: presentationPath,
  );
  await generator.generate(
    DirectoryGeneratorTarget(generateDirectory),
    vars: vars,
    logger: context.logger,
    fileConflictResolution: FileConflictResolution.overwrite,
  );
}

Future<void> _modifyBlocInstallation(HookContext context) async {
  final progress = context.logger.progress(
    'Modifying ${context.vars['bloc_type']} installation',
  );

  final directoryWithBlocFiles = Directory(p.join(
    context.vars['feature_folder_path'],
    'presentation',
    context.vars['feature_folder_name'],
    context.vars['bloc_type'],
  ));
  final moveTo = Directory(p.join(
    context.vars['feature_folder_path'],
    'presentation',
    context.vars['bloc_type'],
  ));
  await moveTo.create();

  if (!await directoryWithBlocFiles.exists()) {
    context.logger.warn('Couldn\'t find ${directoryWithBlocFiles.absolute}');
    return;
  }

  var importFixed = false;
  final blocFiles = directoryWithBlocFiles.list().listen((blocFile) async {
    final newFile = await blocFile.rename(p.join(
      moveTo.path,
      // file name
      blocFile.path.split(p.separator).last,
    ));

    if (importFixed) return;

    final file = File(newFile.path);
    final fileString = await file.readAsString();
    if (fileString.contains('import \'package:bloc/bloc.dart\';')) {
      await file.writeAsString(fileString
        ..replaceFirst(
          'import \'package:bloc/bloc.dart\';',
          'import \'package:flutter_bloc/flutter_bloc.dart\';',
        ));
      importFixed = true;
      context.logger.info('Bloc import fixed');
    }
  });

  blocFiles.onDone(() async {
    await directoryWithBlocFiles.parent.delete(recursive: true);
    context.logger.info('The block files have been successfully moved');
  });

  progress.complete();
}
