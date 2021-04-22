# Data

Here are my thoughts about how data works in software.
I'm sure that most of what I say here
is *technically* wrong (the best kind of wrong!)
but I hope that it's still a useful way to think about things.

## Overview

The overall goal here is to find ways to make data more useful.
Sometimes that means giving it more structure,
so that we can search and transform it
more efficiently and effectively.
Sometimes that means making it more "portable"
so we can share it more easily
across different communities and different computing infrastructures.
Sometimes it means just thinking about data more clearly.

I'm specifically interested in "data languages",
including SQL, XML, JSON, and RDF.
These are similar to programming languages in some ways,
but they're for defining data, not programs.
Data languages tend to have corresponding
schema languages and query languages,
and libraries or APIs that make them easy to use from
many different programming languages.
They way they are structured makes
certain search and transformation operations easier than their rivals
while others are more difficult.
I'm really interested in these trade-offs.
Get the data representation right,
and so many other things become much easier.

This essay is organized as a kind of idealized history.
This is not really the order in which things happened,
and it's not the order in which most software developers learn things,
but I think this order helps make certain connections
that I think are important.

## Sections

1. [Binary](binary.md) a few short words, for completeness
2. [Strings](strings.md)
3. [Unstructured Text](unstructured-text.md)
4. [Structured Text](structured-text.md)
5. [Programming Languages](programming-languages.md)
6. [Tables](tables.md)
7. [Relational Data (SQL)](sql.md)
8. [eXtensible Markup Language (XML)](xml.md)
9. [JavaScript Object Notation (JSON)](json.md)
10. [Resource Description Framework (RDF)](rdf.md)
11. [Getting some Clojure](clojure.md)

## Running Examples

I have a weakness for abstraction,
so let's introduce some concrete examples
to keep things from getting out of control.
We'll be talking about using various data languages
to build representations of:

- playing cards, poker hands, and decks of cards
- the hierarchy of an organization
- a wedding invitation
