# Structured Text

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

## Examples of Structured Text

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

## Limitations

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

