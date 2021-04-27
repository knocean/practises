# Getting Some Clojure

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

## Extensible Data Notation

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

## Namespaces

namespaces
namespaced keywords

## Schemas

schemas
Clojure spec

## Queries

Datomic, Datascript, datalog

## Templates

macros
simple functions

## Fressian

- comparison https://groups.google.com/g/clojure/c/9ESqyT6G5nU/m/2Ne9X6JBUh8J

## Transit

## Limitations

As you can see, I think Clojure and EDN are amazing.
They provide nice solutions to a lot of the problems
that we saw with the other data languages.

So if Clojure is so great,
why isn't everybody using it?

I take that question seriously.
People have discussed it endlessly.
There are some simple answers with a grain of truth:

- beginners are scared off by "too many parentheses"
- data-driven programming is a new thing to learn
- Clojure "bucks the trend" toward strongly typed languages
- being a "hosted language" eventually requires
  that you know a fair bit about each of the hosts
- Clojure is used in many large organizations,
  but there's no big sponsor pushing for its use

But let's focus on EDN specifically:
If EDN is better than XML, JSON, and RDF,
why isn't everybody using it?
Some of the general answers above apply,
but here's what I think is at the core:
If JSON has the minimum number of features of any data language,
then EDN has the maximum number of features.
So while JSON "fits" into existing data structures of any programming language,
EDN only "fits" into existing structures of Clojure,
and to use EDN in any other programming language 
requires special data structures
that are at least a little different from what you're used to.


