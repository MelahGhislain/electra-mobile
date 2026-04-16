import 'package:electra/app.dart';
import 'package:electra/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:electra/common/blocs/app_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:electra/core/configs/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // For debugging Bloc events
  Bloc.observer = AppBlocObserver();

  // Initialize HydratedBloc storage (Mobile only)
  final tempDir = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(tempDir.path),
  );

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Detect which environment to load
  const env = String.fromEnvironment('ENV', defaultValue: 'development');
  final fileName = env == 'production'
      ? '.env.production'
      : env == 'staging'
      ? '.env.staging'
      : '.env';

  await dotenv.load(fileName: fileName);

  // Optional: Print env in debug mode
  if (env == 'development') {
    Env.debugPrintAll();
  }

  // Initialize dependency injection
  await init(); // DI (Service Locator)

  runApp(const MainApp());
}
