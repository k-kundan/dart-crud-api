# Table Users: 

```
-- user_db.users definition

CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

```

# Change Database Connection Config in server.dart file: 

```
var conn = await MySQLConnection.createConnection(
    host: "127.0.0.1",
    port: 3306,
    userName: "DB_USER",
    password: "DB_PASSWORD",
    databaseName: "DB_NAME",
  );

```


# Should have:

- Dart SDK version: 2.17.0 (stable) 

# Install Packages:

- dart pub get


# Create User:

method: POST
url: localhost:8080
payload:

    {
        "name": "test user",
        "username": "testuser",
        "email": "testuser@gmail.com",
        "age": 28,
        "gender": "MALE",
        "address": "Mumbai, India",
        "city": "Mumbai",
        "created_by": "admin"
    }


# Get All Users:

method: get
url: localhost:8080

# Get Specific User:

method: get
url: localhost:8080/id


# Delete Specific User:

method: delete
url: localhost:8080/id