# Relational Data (SQL)

One of the simplest forms of structure data is the table,
and one of the earliest and most successful data languages is "SQL".
I should be more precise and talk about "relational data"
and "relational databases" and "relational database management systems" (RBDMs)
but mostly I won't.
The Structured Query Language (SQL)
really only refers to one language
(well, more of a family of dialects)
used to query a relational database.
But SQL is so dominant in this space
that people tend to just say "SQL database" and "SQL database server",
and I'll mostly go with the flow.

People think of "relational data" and SQL as being about tables,
which is partly true and partly misleading.
The theory behind relational databases is really about sets.
Unlike a TSV file,
a table in a relational database isn't stored in any particular order.
It's more accurate to think of one of these tables as a set of records (rows)
and each row as a tuple that you can match up
with the tuple that defines the columns.
If you want your data to be ordered,
then you have to provide enough information to sort it properly,
and then specifically ask for it to be sorted in a certain order.

## Schemas

SQL is different from TSV files and the other data languages we'll discuss
becuase it requires you to specify a "schema" for your tables
before you can use them.
XML and JSON and RDF let you specify schemas later,
then check that your incoming data conforms to the schema,
but you don't really *need* a schema to work with them.

In you schema you specify your tables
and the datatype for each column in each table.
If you specify that column "name" is a "primary key" column
then every row in that table must have a distinct value for "name".
You can also link columns of one table to columns of another table
(usually to a primary key column of the other table)
using a "foreign key" constraint.
This is a good way to restrict values in a column
beyond just their datatype,
and to ensure that data is consistent across tables.
In our previous examples I've been complaining
about how employees should be linked to a more general employee record,
and now we have a chance to fix that.

There are many SQL implementations out there,
but lets look at SQLite and then Postgres.
SQLite supports a small number of datatypes:

- NULL
- INTEGER
- REAL: floating point
- TEXT
- BLOB: binary data

SQLite provides a number of date functions,
but they rely on dates being stored as INTEGER.
SQLite provides a number of functions for working with JSON,
but ultimately JSON data is stored as TEXT.

Postgres on the other hand supports many more datatypes
including some collections:

- boolean
- character types: char, varchar, and text.
- numeric types: integer, floating-point, currency
- temporal types: date, time, timestamp, and interval
- UUIDs
- binary types
- arrays (sequences)
- XML
- JSON
- hstore: key-value pairs
- more: network address, geometric data, etc.

## Queries

The main thing you want to do with an SQL database
is query your tables.
SQL is quite good for this.
One criticism I will mention here
is that in order to call SQL from a programming language
you have to construct a string and send it to the database.
This can require a lot of quoting and escaping,
and it opens the door for a class of common security vulnerabilities
called "SQL injection" attacks.
It would be nicer if you could sent structured data to the SQL server.

Often you want to shove a lot of data into the database
and still want your queries to return quickly.
RDBMs give you a lot of control over how this works.
You can send your query to the database and then ask for its "query plan",
which explains how it will execute your query.
You can build "indexes" on columns,
which takes time and uses storage on disk,
but makes it more efficient to filter data in a column.
The query planner will try to make best use of the indexes that you specify,
which can make a gigantic difference in query speed.

## Object-Relational Mapping (ORM)

SQL is so great that people want to use it for all sorts of things.
In particular, programmers working in a programming language such as Python
want to store data in SQL databases and then get it back out again,
in the most Pythonic way possible.
The programmers notice that a row in a relational database table
looks an awful lot like a struct,
and SQL queries produce collections (sets or lists) of these structs.
The problem is that the datatypes for the database
are never exactly the same
as the datatypes for the programming language you want to use.

This line of thinking has led to ORMs: Object-Relational Mappings.
These are systems that let you serialize the data for your program to SQL database
and then marshal it again.

## Examples in SQL

Let's start with playing cards again.
Remember that we have to start by defining the schema
for our tables and columns,
and their datatypes and relationships.
In the Python example above I started by defining all the ranks.
Let's do taht again here in a `rank` table:

```sql
CREATE TABLE rank (
  name TEXT PRIMARY KEY,
  position INTEGER UNIQUE
);
INSERT INTO rank(name, position) VALUES
("2", 1),
("3", 2),
("4", 3),
("5", 4),
("6", 5),
("7", 6),
("8", 7),
("9", 8),
("10", 9),
("jack", 10),
("queen", 11),
("king", 12),
("ace", 13);

.header on
SELECT * FROM rank LIMIT 3;
```

Each rank has a name and a "position".
I wanted to use the name "index" or "order" instead of "position",
but "index" and "order" are keywords in the SQL language,
and so using those as column names would have cause annoyances.
We make the "name" column a primary key
to enforce its uniqueness
and because we want to refer to in later with foreign key constraints.
We make the "position" unique, but not primary.

Let's do the same for suits:

```sql
CREATE TABLE suit (
  name TEXT PRIMARY KEY,
  position INTEGER UNIQUE
);

INSERT INTO suit(name, position) VALUES
("clubs", 1),
("diamonds", 2),
("hearts", 3),
("spades", 4);

SELECT * FROM suit;
```

Now let's make a `card` table (heh!).
We'll refer to `rank` and `suit` tables using foreign key constraints.
We'll make the pair of rank and suit the primary key this time.
Then we'll generate all the possible cards.

```sql
CREATE TABLE card (
  rank TEXT,
  suit TEXT,
  FOREIGN KEY(rank) REFERENCES rank(name),
  FOREIGN KEY(suit) REFERENCES suit(name),
  PRIMARY KEY(rank, suit)
);

INSERT INTO card(rank, suit)
SELECT rank.name, suit.name
FROM rank CROSS JOIN SUIT;

SELECT count(*) FROM card;
SELECT * FROM card LIMIT 3;
```

Now let's make a `hand` table using the cards as foreign key.
We'll also add a "hand_id" column for grouping card into a hand.

```sql
CREATE TABLE hand (
  hand_id INTEGER,
  rank TEXT,
  suit TEXT,
  FOREIGN KEY(rank, suit) REFERENCES card(rank, suit) 
);

INSERT INTO hand(hand_id, rank, suit) VALUES
(1, "2", "spades"),
(1, "queen", "hearts"),
(1, "ace", "hearts"),
(1, "6", "clubs"),
(1, "10", "diamonds"),
(2, "10", "diamonds"),
(2, "2", "spades"),
(2, "6", "clubs"),
(2, "ace", "hearts"),
(2, "queen", "hearts");

SELECT * FROM hand WHERE hand_id=1;
```

Finally we'll shuffle cards into decks.
For this we need to track the "deck_id"
and the position in the deck.
(This one took me a little while to figure out.)

```sql
CREATE TABLE deck (
  deck_id INTEGER,
  position INTEGER,
  rank TEXT,
  suit TEXT,
  FOREIGN KEY(rank, suit) REFERENCES card(rank, suit) 
);

INSERT INTO deck
SELECT 1, ROW_NUMBER() OVER (ORDER BY RANDOM()), rank, suit
FROM card;

SELECT * FROM deck WHERE deck_id=1 ORDER BY position LIMIT 3;
```

TODO: finish SQL examples

## Limitations

SQL is great.
SQL databases are ubiquitous and indispensable.
It's a huge success story.
But one thing SQL is not great for is storing documents.
This is partly because documents,
like language in general,
is best structured as a tree,
and representing tree is one thing that the relational model
is not particularly good at.

