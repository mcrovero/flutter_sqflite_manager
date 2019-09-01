# Flutter Sqflite Manager
To manage your sqflite database in Flutter. 

Browse the database's tables, see the rows inside them, empty tables and delete the entire database. 
Review your tables' columns and the corresponding column type.
> This is still an early preview, some behaviors can change or being removed. Every feedback, bug report or feature request is welcome, please send it at the <a href="https://github.com/mcrovero/flutter_sqflite_manager/issues">issue tracker</a>
<table>
  <tr>
    <td><img src="https://github.com/mcrovero/flutter_sqflite_manager/raw/master/assets/screen1.png" width="250"></td>
    <td><img src="https://github.com/mcrovero/flutter_sqflite_manager/raw/master/assets/screen2.png" width="250"></td>
    <td><img src="https://github.com/mcrovero/flutter_sqflite_manager/raw/master/assets/screen3.png" width="250"></td>
  </tr>
</table>

## Get started
Wrap your app with SqfliteManager passing the sqflite database as parameter. 
Usually the database is of `Future<Database>`, check the <a href="https://github.com/mcrovero/flutter_sqflite_manager/tree/master/example/lib/db_page.dart">example</a> to see a FutureBuilder implementation.
Use the enable parameter to switch between testing and production.
```dart
SqfliteManager(
    database: _database,
    // Update rowsPerPage parameter to avoid scrolling in different screen sizes
    rowsPerPage: 6
    enable: true,
    child: YourApp()
)
```
