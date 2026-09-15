import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

final _webDatabaseFactory = createDatabaseFactoryFfiWeb(
  noWebWorker: true,
  options: SqfliteFfiWebOptions(
    sqlite3WasmUri: Uri.parse(
      'https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-3.6.0/sqlite3.wasm',
    ),
    indexedDbName: 'gameshelf_databases',
  ),
);

Future<void> initializeDatabasePlatform() async {
  databaseFactory = _webDatabaseFactory;
}

Future<String> resolveDatabasePath(String fileName) async => fileName;
