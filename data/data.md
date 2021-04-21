# Data

Here are my thoughts about how data works in software.
I'm sure that most of what I say here
is *technically* wrong (the best kind of wrong!)
but I hope that it's still a useful way to think about things.

I'm specifically interested in "data languages".
These are similar to programming languages in some ways,
but they're for defining data, not programs.
Data languages tend to have corresponding
schema languages and query languages,
and libraries or APIs that make them easy to use from
many different programming languages.

This essay is organized as a kind of idealized history.
This is not really the order in which things happened,
and it's not the order in which most software developers learn things,
but I think this order makes sense as a teaching device.

I have a weakness for abstraction,
so let's introduce some concrete examples
to keep things from getting out of control.
We'll be talking about using various data languages
to build representations of:

- playing cards, poker hands, and decks of cards
- the hierarchy of an organization
- a wedding invitation

## Binary

For completeness, we should start with binary.
Nearly all the computers ever made store information in binary.

Why binary?
Because it's relatively easy to make a machine
(such as a transistor)
that can be in one of two states,
and then connect those little machines into larger logical circuits
so that information can flow through them
in predictable ways.
I say *relatively* easy:
it's actually a stunning accomplishment!
The history of early computing is fascinating.
I'm just trying to say that
binary turns out to be a lot simpler for building machines
than the base-10 numbers we're more familiar with,
or trinary,
or all the other things that have been tried.

So at bottom, all our data is represented as sequences of 1s and 0s.
Except for programmers,
most people never have to think about
the binary representation of their data.

## Strings

You can interpret a series of 1s and 0s as just about anything.
One useful interpretation is as letters of the alphabet
and familiar base-10 numbers.
Perhaps the best known system for doing this is ASCII:
[American Standard Code for Information Interchange](https://en.wikipedia.org/wiki/ASCII).
It uses seven bits (binary digits) to represent 128 characters, including:

- digits 0-9
- the English alphabet, lowercase and uppercase
- common punctuation characters
- 33 non-printing control codes

If you use an eighth bit for something else
(such as error checking)
then you get a convenient one byte per character.
Given a sequence of bytes,
you can interpret it as a "string" of alphanumeric characters in English,
and now you have something that looks more like "data":
a document, an email, a report, etc.

You may have noticed that not everyone in the world reads and writes English.
The world is full of fascinating written languages.
We also have crazy things like emojis.
[Unicode](https://en.wikipedia.org/wiki/Unicode)
is an evolving standard for representing
all the world's written languages for computers.
It turns out to be really complicated!
There are several Unicode standards,
but we'll focus on one that programmers like the best
for sharing data:
[UTF-8](https://en.wikipedia.org/wiki/UTF-8).
UTF-8 starts with ASCII
and uses between one and four bytes
to encode up to 1,112,064 "character code points".
I have no idea how this works in practise.
But I do know that many smart people have figured out the details,
so that I can remain content and ignorant.
For now, let's assume that UTF-8
can encode any string that we care about.

## Unstructured Text

Say we have a bunch of binary data.
Most of it is text.
Maybe the strings are stored in files
or coming in over the network
or from some other device connected to our computer.
Now what?

This is kind of what you have in the Unix shell.
One of the defining features of Unix is
"everything is a file".
Like most short phrases,
it needs a lot of unpacking.
But I would rephrase it as
"everything is a stream of bytes",
and "most of those are text".

So what we do next is use text for input and output.
We send messages to a process as text,
and it sends messages back to us as text.
We set up these processes so that they can also talk to each other using text.
Then we combine them,
mixing and matching them
to accomplish our goals.
We can do things like:

- read the contents of a file
- write files using an interactive text editor
- move, copy, split, and combine files
- attach metadata to files, such as file names and permissions
- search files for matching names or matching text
- sort lines in different ways
- write programs that do something when they can match certain text

That's quite a lot,
but there's one critical piece missing.
We may understand what we mean by each piece of text,
but the computer does not.
All text looks the same to the computer.
If we want the computer to recognize
that some text is different from other text,
then the text has to have *structure*.

### Examples of Unstructured Text

Unstructured text is kind of easy:

- a playing card: "Queen of Hearts"
- a poker hand: "full house, Queens and Threes"
- a deck of cards: "Queen of Hearts, Ace of Spades, ..." (tedious)
- an organization chart:
  "Jamie is in charge of shipping, which includes Terri and Amundsen"
- a wedding invitation:

> You are cordially invited to the wedding of 
> Donna Dominique Diangello and
> Donald Donatello Donaldson,
> at Two O'Clock on the afternoon
> of the First of June, Two-Thousand Twenty-One,
> on the steps of Toronto City Hall.

Why is it easy?
Because people are pretty smart.
(Well, we can be. Sometimes. I mean, smarter than computers, at least.)
People can usually figure out the context
and come up with an interpretation
that's pretty close to your intention.

But what is a computer supposed to do with this?

## Structured Text

Most of the standard Unix "coreutils"
work with text line-by-line.
So a text file is split on newline characters
into a sequence of shorter strings.
The shell also splits lines on whitespace
before it interprets them,
then we have quoting rules for controlling splitting.
A lot of tools split lines by tabs.
Splitting by lines and tabs is enough
to give you tables.
Tools such as `cut` and `join` let you operate on tables.
If the first row of your table is a header row
then you kind of map structure (see below).
An awful lot of data is stored in tables.
Some Unix tools can also understand numbers.

These are the first steps towards "structured data",
but it's pretty ad hoc.

The distinction between unstructured and structured text is not binary, 
but more of a spectrum.
For example, a text file may have a structured header with metadata
followed by unstructured "free" text document.

### Examples of Structured Text

This gets more interesting,
and there's lot of ways we could go.

Here are some ideas:

- playing card: "QH"
- poker hand: "QH QD 3H 3S 3C"
- deck of cards: "QH AS ..." (still a bit tedious)
- organization chart: "Shipping: Amir; Terri, Amundsen"
- wedding invitation

```
TYPE invitation
SUBTYPE wedding
BRIDE Donna Dominique Diangello
GROOM Donald Donatello Donaldson
DATE 2021-06-01
TIME 14:00 EDT
LOCATION 100 Queen Street West, Toronto, Ontario, Canada
```

That last one lacks the flair of the unstructured wedding invitation example,
but it's the kind of thing that a computer can begin to work with.

Let's talk some more about the playing card examples.
How should we represent the Queen of Hearts?
Here are some options:

- `"Queen of Hearts"` a verbose, human-readable string
- `"QH"` a very concise string 
- `"Q❤"` a concise string using a symbol for "Hearts"
- `"12:H"` replace "Queen" with the number 12, add a separator

All of these represent the information we care about: one playing card.
There's a million different representations we *could* use.
What reasons do we have to pick one over the others?
Let's think about what we want to do with the representation.

The first thing to consider is reading and writing.
We want to write the representations down,
which means typing on a keyboard.
I'd say that it's very easy to read the symbol "❤"
and somewhat easy to figure out from the context
that we're talking about playing cards.
A lot of systems support symbols like this,
but there can be glitches and bugs.
The biggest reason that I would prefer "H" or "Hearts"
is that they're easy to type with a keyboard,
while I needed to do much more work to find "❤"
and insert it into this document.

Lowercase is a little bit easier to type than mixed case,
and arguably a little harder to read.
When you have multiple words you often need to decided on a convention
such as camelCase or snake_case.
But the biggest consideration is consistency:
I shouldn't have to check each time I write out this representation
which case or case convention to use.
This is a common frustrating when moving between programming languages and codebases.
For our examples, let's consistently use lowercase.

Reading depends heavily on context.
If we're reading a lot of dense information about playing cards,
then a concise representation such as "QH" can be best.
Concision is also important if we're entering a lot of data "by hand".
But if the context is not so clear,
then it's better to be more verbose: "queen of hearts".

In any case, consistency is crucial!

For a poker hand and a deck of cards
we try to build on the representation of individual card.
For a hand, what about these options?

- "2S QH AH 6C 10D"
- "2S, QH, AH, 6C, 10D"
- "(2S QH AH 6C 10D)"
- "hand(2S, QH, AH, 6C, 10D)"

First of all, you want to separate the cards from each other.
Punctuation is good.
I find simple spaces cleaner and prefer them,
but I think I'm in the minority,
and most people like commas better.
Then it's nice to have paired delimiters to "contain" the cards
and separate one hand from other hands.
Good paired delimiters include `()`, `[]`, `{}`, and `<>`,
Sometimes you want "heavier" delimiters such as `BEGIN` and `END`,
or like HTML `<div>` and `</div>`,
on in this case `head(...)`.

If we like the last option "hand(2S, QH, AH, 6C, 10D)",
then we can do something similar for decks of cards:
"deck(2S, QH, ...)".
But one thing to keep in mind is that
order of cards in a hand is not important,
but order of cards in a deck is important.
That distinction is not visible
in the structured text representation that we've chosen here.

### Limitations

Structured text is great.
"Everything is a file" is very powerful.
But the dark side of this is:
"everything has to be parsed".
Text comes in to a program,
then the program tries to figure out what it means,
and when it's done it "flattens" everything back into text.
The next program has to start from scratch,
figuring things out for itself.
That's very flexible,
but sometimes very wasteful
and prone to errors,
doing the same work over and over again
in slightly different ways.

## Programming Languages

Most programs are written in text that we call "source code".
The source code is parsed into a tree structure
which is then interpreted or compiled
and then executed.

(Remember that this isn't really history,
and it isn't the order that things really happened.
We've kind of skipped ahead
and muddled up this section with the previous section.)

Parsing is a fascinating subject of its own.
We'll talk a bit about parsing data formats as we go,
and leave aside the deeper topic
of parsing programming languages.
For now let's just note
that source code is another kinds of data,
and programs operate on data.

Each programming language has its own way of structuring data,
but they tend to have a lot in common.
Let's talk about primitive datatypes, structs, and collections.
The primitives are the building blocks,
while structs and collections are combinations of primitives.

### Primitive Datatypes

Most programming languages have most of these datatypes
defined as "primitives" implemented by the language:

- boolean: True and False
- character
- string
- number
  - integer
  - floating point
- date

Dates start to overlap with the more complex datatypes discussed next.

The dark horse of the primitive datatypes is "Null" or "Nil" or "None".
We'll have more to say about that later.
We'll also set aside interesting questions
about how one datatype can be converted into another,
such as converting an integer to a string or a string to an integer.

### Structs

Many languages allow you to specify your own compound datatypes
out of primitive datatypes.
Most of the time you have a string that names a "field"
and a value that must have a certain datatype.
Sometimes these are called "records" or "data classes"
but let's use the general term "struct"
which is just short for "structure".
You can usually build structs where some of your fields
have another struct as its datatype.

Structs are usually "closed",
so once you define the set of fields
you can't add or remove fields.
You have to define a new struct.
Sometimes you can specify inheritance relations between structs,
or say that they implement a set of interfaces.
The details of how this works
makes a big difference between types of languages.
For now I want to emphasize that structs are "closed".

Defining a struct requires at least a bit of code.
This code is often predictable and repetitive,
so it gets called "biolerplate".
If you have a schema in one of the data languages that we discuss later,
such as SQL, XML, or JSON,
then you can usually find a way to have code
that automatically generates the code
that defines your structs.

### Collections

Unlike structs, collections are "open",
so you can continue to add to them.
Depending on the language, 
they're sometimes called "generics".
Most languages have these collections:

- set
- sequence
- map (dict, "object")

Each datatype can have a specific implementation,
and this becomes more important with collections.
So we have sets in general,
and then we have sorted sets, array sets, hash sets, etc.
each of which have different pros and cons
in different circumstances,
such as how much data you want to store
and what you want to do with it.
We'll set those differences aside for now.

Once you get to maps,
there's another big question
about what datatypes are allowed for keys.
Often only strings are allowed for keys,
but sometimes even compound data structures can be keys.

These generic collections can often be nested
to create bigger structures.
For example, nested sequences can form a tree structure.

In some languages,
every item in the collection needs to have the same datatype,
while in other languages you're allowed to mix datatypes in a collection.

The key difference I'd like to point to
is that structs are similar to maps,
because they both have keys (fields) and values,
but structs are closed while maps are open.

### Serializing and Marshalling

So you wrote a source code file,
then compiled it into a program,
then ran your program on some unstructured text,
and did a lot of work to parse it into structured text.
Now what?
Well, some languages provide tools
for *serializing* your structured data as a text file
and then *marshalling* it from text back into structured data.
This is a good idea,
but these serializations tend to be
quite specific to the programming language that you're using.
For example Python has `pickle`
but other languages can't really read from a pickle file.

More generally,
programs include a lot of information that's not really about the data
and is more about how the program should work.
Source code has to be recompiled for different hardware
and often depends on other software to be installed
before it can run.

These are some of the reasons why people have created "data languages"
that are good for communicating between programs in different languages,
and often kinda sorta useful for humans to write data.
The rest of this essay is about those data languages.

### Examples of Data in Python

To give specific examples
we need to pick a specific programming language.
Let's start with Python
and build on the structure text discussion examples above.

We also have to start to get much more specific about
what each of our running examples means.

How should we represent the Queen of Hearts in Python?
Here are some options:

- `"QH"` a very concise string, from the structured data example above
- `("Queen", "Hearts")` a tuple (sequence) of strings
- `{"rank": "Queen", "suit": "Hearts"}` a dictionary (map)
- `{"rank": "queen", "suit": "hearts"}` a dictionary (map) all lowercase

All of these represent the information we care about: one playing card.
What reasons do we have to pick one over the others?
Let's think about what we want to do with the representation.

The reading, writing, and consistency points discussed above
still apply here.
But keep in mind that computers are good at transforming data
from one structured form into another structured form
or just a string.
If we really want to type "QH",
then we can write a tiny program
to transform it into `{"rank": "queen", "suit": "hearts"}`.
We can also write a program to transform that
into "Queen of Hearts" or "Q❤" or an image of the card.
So these considerations of reading and writing need to be balanced.
Who is doing the reading?
Who is doing the writing?
What are the contexts?
It's usually better to err on the side of being too verbose than too concise.

There's still more to consider.
We're going to want to build on this representation
to represent poker hands and decks of cards.
In order to decide which poker hand is better than another
we need to be able to sort the playing card representations.
In particular, we need to sort by rank (e.g. Queen) and suit (e.g. Hearts),
so it would be nice to have that information cleanly divided.
The tuple and the map representations above do that for us.

How would we implement sorting?
Well it's easy to sort letters and numbers,
but playing cards have a special order:
2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King, Ace.
We could assign numbers to the "face" cards:
Jack 11, Queen 12, King, 13, Ace 14.
Suits also have an order, which can vary, but let's use:
spades 4, hearts 3, diamonds 2, clubs 1.

Where do we store this information?
We could store it in each playing card representation:
`{"rank": "queen", "suit": "hearts", "rank-order": 12, "suit-order": 3}`
but then we'd be repeating ourselves a lot,
and opening the door to typos and other mistakes.
It's better to store this in one shared place in the code.
Which representation is primary, "queen" or "12"?
That also depends.
"queen" is easier to read, but 12 is easy to sort.
Let's favour words over numbers.

One more question:
do we store the rank "2" as a string or a number?
Well we have to store "queen" as a string and not a number,
and we want to be consistent,
so let's store numeric ranks such as "2" as a string.

This code defines the ranks and suits
as lists (sequences) in the proper order (lowest to highest)
then a `sort_cards` function that takes a list of cards
and returns a sorted list.
It works by transforming the card representation into a tuple of integers,
where the first integer is the index of the card's rank in the `ranks` list,
and the section integer is the index of the card's suit in the `suits` list.
Python can then easily sort the tuples of integers,
and we use `reverse` to get cards from highest to lowest.
Then we run a quick check.

```python
ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king", "ace"]
suits = ["clubs", "diamonds", "hearts", "spades"]

def sort_cards(cards):
    """Given a list of cards,
    return a list of those cards sorted from highest to lowest."""
    return sorted(cards,
        key=lambda card: (ranks.index(card["rank"]), suits.index(card["suit"])),
        reverse=True
    )

cards = [
  {"rank": "2", "suit": "spades"},
  {"rank": "queen", "suit": "hearts"},
]
print(sort_cards(cards))
```

Wow, that example got really long!
There was a lot of stuff I wanted to say about creating
a good structured representation of data,
and a concrete example was the best way to work through those ideas.
Now we can cover the rest of the examples much more quickly.

How do we represent a poker hand?
A list of cards seems like a good idea:

```python
hand1 = [
  {"rank": "2", "suit": "spades"},
  {"rank": "queen", "suit": "hearts"},
  {"rank": "ace", "suit": "hearts"},
  {"rank": "6", "suit": "clubs"},
  {"rank": "10", "suit": "diamonds"},
]
hand2 = [
  {"rank": "10", "suit": "diamonds"},
  {"rank": "2", "suit": "spades"},
  {"rank": "6", "suit": "clubs"},
  {"rank": "ace", "suit": "hearts"},
  {"rank": "queen", "suit": "hearts"},
]
```

How do we tell if two hands are the same?
Well we use `==` to compare them:
`print(hand1 == hand2)`.
Uh oh!
We can see that `hand1` and `hand2` have the same cards
just mixed up.
In poker it doesn't matter what order you hold the cards in your hand.
We also aren't worried about duplicate cards,
since a deck only has one of each card.
We can see that `print(sort_cards(hand1) == sort_cards(hand2))`,
so what went wrong?
Well, lists preserve data about the sequence of elements,
so the same elements in a different order means a different list.

In many languages,
the solution is to use the collection datatype
that preserve just the information that we care about.
In this case, that's a set.
But in Python you can't directly make a set of dictionaries --
we'll skip the technical reasons for this,
and just point out that it's surprising how often
technical details like this weigh on design choices.
You can make a set of tuples,
so that's one reason to reconsider some our design choices above.
Another option is to always sort hands before comparing them,
but this is the kind of thing you're simply going to forget at some point,
which will lead to a bug that will be hard to see
since `hand1 == hand2` just "looks right".

Here's the same code as above but using tuples instead of dictionaries:

```python
hand1 = {
  ("2", "spades"),
  ("queen", "hearts"),
  ("ace", "hearts"),
  ("6", "clubs"),
  ("10", "diamonds"),
}
hand2 = {
  ("10", "diamonds"),
  ("2", "spades"),
  ("6", "clubs"),
  ("ace", "hearts"),
  ("queen", "hearts"),
}
print(hand1 == hand2)

def sort_card_tuples(cards):
    """Given a list of cards,
    return a list of those cards sorted from highest to lowest."""
    return sorted(cards,
        key=lambda card: (ranks.index(card[0]), suits.index(card[1])),
        reverse=True
    )
print(sort_card_tuples(hand1))
```

To represent a deck of cards we do care about the order,
so a `list` is a good choice in Python.
We can write a little function to generate a deck
and there's even a nice library function to shuffle it:

```python
deck = []
for rank in ranks:
    for suit in suits:
        deck.append({"rank": rank, "suit": suit})
print(len(deck))
print(deck[0:2])

import random
random.shuffle(deck)
print(deck[0:2])
```

That was a lot,
but these lessons apply very generally,
and not just to playing cards.

For an organization chart in Python
I would try to us a nested dictionary (i.e. map):

```python
organization = {
  "departments": {
    "shipping": {
      "head": "Amir",
      "employees": {"Terri", "Amundsen"},
    },
  },
}
print(organization)
```

The biggest problem here
is that we're not doing a good job of representing the people:
we're just using short names,
but it would be better to use full names
or better yet an employee identifier that's unique across the company.

For the wedding invitation we could rework the structured text as a dictionary,
and use Python's `datetime` library:

```python
from datetime import datetime
invitation = {
  "type": "invitation",
  "subtype": "wedding",
  "bride": "Donna Dominique Diangello",
  "groom": "Donald Donatello Donaldson",
  "datetime": datetime.fromisoformat("2021-06-01T14:00-04:00"),
  "location": "100 Queen Street West, Toronto, Ontario, Canada",
}
print(invitation)
```

Again the main limitation here
is that the data isn't linked to other data about people and places,
so it's not as useful as it could be.

## Relational Data (SQL)

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

### Schemas

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

### Queries

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

### Object-Relational Mapping (ORM)

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

### Examples in SQL

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

### Limitations

SQL is great.
SQL databases are ubiquitous and indispensable.
It's a huge success story.
But one thing SQL is not great for is storing documents.
This is partly because documents,
like language in general,
is best structured as a tree,
and representing tree is one thing that the relational model
is not particularly good at.

## XML

The eXtensible Markup Language (XML)
is a data language for documents.
More accurately, it's a set of technologies
for building specific data languages for documents
and converting between them.

When you look at XML for the first time,
you'll see a family resemblance to HTML,
specifically lots of angle brackets: `<`, `>`.
That's because they share a common ancestor:
[Standard Generalized Markup Language (SGML)](https://en.wikipedia.org/wiki/Standard_Generalized_Markup_Language)
This whole family of data languages
is specifically designed for documents.

An XML document is fundamentally a tree
consisting of nodes,
which belong to a few different types,
of which the most important are:

- document
- element
- attribute
- text

An element has a set zero or more attributes
then a sequence of zero or more nodes as children.
There's a couple of different standard APIs
for working with an XML tree.

### eXtensible

Structs are closed.
The columns of a SQL table are closed.
You have to rework your data
to add or change or delete fields.

The "X" in "XML" stands for eXtensible,
which means that if you follow certain rules,
you can extend a given XML document with more information
without changing how it's interpreted by existing tools.
This lets you merge information from several sources
using different XML dialects
into a single XML document
and still process that information in a consistent way.

Every XML element has a name.
In early versions of XML these were simple words,
and you could define your own XML language by specifying 
the names of elements you allow.
(More on this in the "Schemas" section below.)
With the introduction of XML Namespaces,
element names were connected to the space of URLs.
This connected XML languages to the wider Web,
letting you define an XML language using a namespace that you control,
and also letting you find out more about the XML languages
used in the documents you read
by looking up the URLs for the elements.

XML Namespaces let you really mix and match XML languages
in a single document.
They're amazing.
But they're also kind of difficult to work with.

prefixes
QNames
NCNames

### Schemas

DTD
RelaxNG

### Queries

XPath
XQuery

### Templates

XSLT

### Examples in XML

These are snippets of XML
that I would use to represent playing cards, hands, and decks:

```xml
<cards xmlns="http://example.com/cards">
  <card rank="queen" suit="hearts"/>

  <hand>
    <card rank="2" suit="spades"/>
    <card rank="queen" suit="hearts"/>
    <card rank="ace" suit="hearts"/>
    <card rank="6" suit="clubs"/>
    <card rank="10" suit="diamonds"/>
  </hand>

  <deck>
    <card rank="2" suit="spades"/>
    <card rank="queen" suit="hearts"/>
    <!-- tedious ... -->
  </deck>
</cards>
```

Note that the cards in the hand are ordered,
so we face the same sorting problem that we saw earlier
when using lists in Python.

```xml
<organization>
  <departments>
    <department>
      <name>Shipping</name>
      <head>Amir</head>
      <employees>
        <employee>Terri</employee>
        <employee>Amundsen</employee>
      </employees>
    </department>
  </departments>
</organization>
```

The wedding invitation is more interesting,
because we can mix structured text with free text:

```xml
<invitation subtype="wedding">
  <greeting>You are cordially invited to the wedding of</greeting>
  <bride>Donna Dominique Diangello</bride>
  and
  <groom>Donald Donatello Donaldson</groom>,
  <datetime isoformat="2021-06-01T14:00-04:00">
  at Two O'Clock on the afternoon
  of the First of June, Two-Thousand Twenty-One
  </datetime>,
  <location address="100 Queen Street West, Toronto, Ontario, Canada">
  on the steps of Toronto City Hall
  </location>.
</invitation>
```

We've managed to combine
the unstructured data aimed at the human reader
with the structured data that the machine can use.
We can easily convert from this
to the unstructured text of our unstructured text example
simply by stripping away the XML tags.
And we can use the standard XML APIs or XSLT
to convert to any of the structured formats we've seen so far:
structured text, Python map, or SQL tables.

### Limitations

XML is great for documents.
It's not so great for 


## JSON

### Namespaces

JSON-LD
CSV on the Web

### Schemas

JSONSchema

### Queries

jq, JSON Path?

### Templates

I don't know.

## RDF

multiple serializations, including XML and JSON-LD

### Namespaces

IRIs, CURIEs, QNames

### Schemas

ShEX, ShACL

### Queries

SPARQL
datalog?

### Templates

OTTR

## Getting Some Clojure

Clojure
is a programming language.

Emphasis on open-ended information processing
data-driven, literal data
homoiconic

The best current thinking on data processing.

- SQL: sequences of maps, no ORMs
- XML: data.xml
- JSON: superset
- RDF: EDN-LD

### Extensible Data Notation

- nil
- boolean
- string
- keyword (namespaced)
- symbol
- comment
- integer
- float
- set
- list
- vector
- map
- metadata
- custom datatypes

### Namespaces

namespaces
namespaced keywords

### Schemas

schemas
Clojure spec

### Queries

Datomic, Datascript, datalog

### Templates

macros
simple functions

## Conclusion


## Appendix

### Optional and Maybe

### Lenses


