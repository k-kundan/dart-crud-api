import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'db.dart';

// Configure routes.
final _router = Router()
  ..get('/', _getUsers)
  ..get('/<id>', _getUser)
  ..post('/', _createUser)
  ..put('/<id>', _updateUser)
  ..delete('/<id>', _deleteUser);

Future<Response> _getUsers(Request req) async {
  DatabaseConnection db = DatabaseConnection();
  final conn = await db.createConnection();
  List users = [];
  final result = await conn.execute("SELECT * FROM users");
  for (final row in result.rows) {
    users.addAll([row.assoc()]);
  }

  return Response.ok(json.encode(users),
      headers: {'Content-Type': 'application/json'});
}

Future<Response> _getUser(Request req) async {
  final id = req.params['id'];
  if (id != null) {
    DatabaseConnection db = DatabaseConnection();
    final conn = await db.createConnection();
    final userId = int.parse(id);
    Map<String, dynamic> userData = {};
    final result =
        await conn.execute("SELECT * FROM users WHERE id=$userId LIMIT 1");
    for (final row in result.rows) {
      userData = row.assoc();
    }
    return Response.ok(json.encode(userData),
        headers: {'Content-Type': 'application/json'});
  } else {
    return Response.notFound('User not found');
  }
}

Future<Response> _deleteUser(Request req) async {
  final id = req.params['id'];
  if (id != null) {
    DatabaseConnection db = DatabaseConnection();
    final conn = await db.createConnection();
    final userId = int.parse(id);
    await conn.execute("DELETE FROM users WHERE id=$userId");
    return Response.ok('user deleted successfully');
  } else {
    print('user');
    return Response.notFound('User not found');
  }
}

Future<Response> _createUser(Request req) async {
  final payload = jsonDecode(await req.readAsString());
  if (payload.containsKey('name') &&
      payload.containsKey('username') &&
      payload.containsKey('email') &&
      payload.containsKey('age') &&
      payload.containsKey('gender') &&
      payload.containsKey('address') &&
      payload.containsKey('city') &&
      payload.containsKey('created_by')) {
    DatabaseConnection db = DatabaseConnection();
    final conn = await db.createConnection();
    await conn.execute(
        "INSERT INTO users (name, username, email, age, gender, address, city, created_by) VALUES (:name,  :username,  :email,  :age,  :gender,  :address,  :city,  :created_by)",
        payload);
    return Response.ok('user created successfully');
  } else {
    return Response.notFound(
        jsonEncode({
          'success': false,
          'data': 'Invalid data sent to API',
        }),
        headers: {'Content-type': 'application/json'});
  }
}

Future<Response> _updateUser(Request req) async {
  final id = req.params['id'];
  if (id != null) {
    final userId = int.parse(id);
    final payload = jsonDecode(await req.readAsString());
    if (payload.containsKey('name') &&
        payload.containsKey('username') &&
        payload.containsKey('email') &&
        payload.containsKey('age') &&
        payload.containsKey('gender') &&
        payload.containsKey('address') &&
        payload.containsKey('city') &&
        payload.containsKey('created_by')) {
      DatabaseConnection db = DatabaseConnection();
      final conn = await db.createConnection();
      await conn.execute(
        "UPDATE users SET name = :name, username = :username, email = :email, age = :age, gender = :gender, address = :address, city = :city, created_by = :created_by WHERE id=$userId",
        payload,
      );
      return Response.ok('user updated successfully');
    } else {
      return Response.notFound(
          jsonEncode({
            'success': false,
            'data': 'Invalid data sent to API',
          }),
          headers: {'Content-type': 'application/json'});
    }
  } else {
    return Response.notFound('User not found');
  }
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment finaliable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
