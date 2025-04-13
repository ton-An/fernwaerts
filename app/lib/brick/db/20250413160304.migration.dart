// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250413160304_up = [
  InsertTable('User'),
  InsertColumn('id', Column.varchar, onTable: 'User', unique: true),
  InsertColumn('username', Column.varchar, onTable: 'User'),
  InsertColumn('email', Column.varchar, onTable: 'User')
];

const List<MigrationCommand> _migration_20250413160304_down = [
  DropTable('User'),
  DropColumn('id', onTable: 'User'),
  DropColumn('username', onTable: 'User'),
  DropColumn('email', onTable: 'User')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250413160304',
  up: _migration_20250413160304_up,
  down: _migration_20250413160304_down,
)
class Migration20250413160304 extends Migration {
  const Migration20250413160304()
    : super(
        version: 20250413160304,
        up: _migration_20250413160304_up,
        down: _migration_20250413160304_down,
      );
}
