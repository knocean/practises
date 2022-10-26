# Strings

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

