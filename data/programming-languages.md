# Programming Languages

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

