#SQLite Notes

Various notes about SQLite
Some info is from https://www.sqlite.org

## Checking Database and Table Setup

Check tables in current database:
```
.tables
```
Example output:
```
sqlite> .tables
person      person_pet  pet
```

Check what columns exist for a table with `pragma table_info`.
* This pragma returns one row for each column in the named table. 
* Columns in the result set include the column name, data type, whether or not the column can be NULL, and the default value for the column. 
* The "pk" column in the result set is zero for columns that are not part of the primary key, and is the index of the column in the primary key for columns that are part of the primary key.
* The table named in the table_info pragma can also be a view.

Format:
```
pragma table_info(table_name);
```
Example output:
```
sqlite> pragma table_info(pet);
0|id|INTEGER|0||1
1|name|TEXT|0||0
2|breed|TEXT|0||0
3|age|INTEGER|0||0
```

See create statements already entered:
```
sqlite> .fullschema
CREATE TABLE test (id);
CREATE TABLE person (
id INTEGER PRIMARY KEY,
first_name TEXT,
last_name TEXT,
age INTEGER
);
CREATE TABLE pet (
id INTEGER PRIMARY KEY,
name TEXT,
breed TEXT,
age INTEGER
);
/* No STAT tables available */
```

##Create Database and Tables

Access or Create Database:
* At a shell or DOS prompt, type "sqlite3" optionally followed by the name the file that holds the SQLite database. 
* If the file does not exist, a new database file with the given name will be created automatically. 
* If no database file is specified, a temporary database is created, then deleted when the "sqlite3" program exits.

Format:
```
sqlite3 database_name.db
```
Create Tables and Insert Values

Example:
```
sqlite> create table tbl1(one varchar(10), two smallint);
sqlite> insert into tbl1 values('hello!',10);
sqlite> insert into tbl1 values('goodbye', 20);
```

##Navigation

Quit SQLite

```
.quit
.exit
```
Also:
* You can terminate the sqlite3 program by typing your systems End-Of-File character (usually a Control-D). 
* Use the interrupt character (usually a Control-C) to stop a long-running SQL statement.
