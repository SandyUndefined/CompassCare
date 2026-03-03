import 'package:compasscare_flutter/app/app.dart';
import 'package:compasscare_flutter/core/config/app_config.dart';
import 'package:compasscare_flutter/core/network/api_client.dart';
import 'package:compasscare_flutter/core/storage/app_database.dart';
import 'package:flutter/widgets.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  const config = AppConfig();
  final database = AppDatabase();
  final apiClient = ApiClient(baseUrl: config.apiBaseUrl);

  runApp(
    CompassCareApp(config: config, apiClient: apiClient, database: database),
  );
}
