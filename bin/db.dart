import 'package:mysql_client/mysql_client.dart';

class DatabaseConnection {
  late String host = "127.0.0.1";
  late String userName = "kay";
  late String password = "Password#12345";
  late int port = 3306;
  late String databaseName = "user_db";

  dynamic createConnection() async {
    var conn = await MySQLConnection.createConnection(
        host: host,
        port: port,
        userName: userName,
        password: password,
        databaseName: databaseName);

    await conn.connect();

    return conn;
  }
}
