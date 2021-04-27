# Unstructured Text

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


