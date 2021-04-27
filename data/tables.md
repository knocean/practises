# Tables

A lot of structured data is tabular data.
You know: columns and rows.


## XSV

Plain text tables usually come in comma-separated values (CSV) format.
Rows are separate lines,
and cells are separated by commas.
It would be nice if that was all there was to say about this.
Unfortunately we immediately get into trouble.
What if your cell contains a comma?
(Hmm, what are the odds of that?!)
Well, you have "quote" the contents
by wrapping the cell contents in double quotation marks.
Ok, what if the cell contains a double quotation mark?
Then you have to "escape" that double quotation mark
by inserting another double quotation mark before it: `""`.
That doesn't sound too bad,
but it does make it a lot harder to write a CSV parsing program.
You also end up with different newline characters from different operating systems,
and some CSV writers quote everything
while others only quote as necessary.

CSV is ubiquitous,
but when I have the option I prefer tab-separated values (TSV).
TSV is more commmon in Unix and so Unix-style LF newlines are the norm.
Tabs are a lot less common inside cells,
so there's much less need for quoting and escaping.

Settling on TSV doesn't get you all the way out of the woods.
There's a lot of variation in how trailing tabs are handled:
if the last X columns are empty,
should there still be delimiters (tabs or commas) for them?
And every if you're consistent about this
it's still very common to accidentally have
the wrong number of columns in some of your rows.
That's especially bad when you're trying to match column headers to cells.
One more common problem is how to inteprety empty cells:
empty strings or nulls?

The last major limitation of XSV files
is handling multiple tables.
It's vry convenient to have a spreadsheet file with multiple sheets/tabs.
You can have a directory of XSV files
but that's a "loose" kind of collection,
and sometimes its hard to know which of the files really belong together.

## Spreadsheets

The spreadsheet was the first "killer app" for the personal computer market.
There were many rival options in the 1980s and into the 1990s,
but now there are really just two games in town:
Microsoft Excel and Google Sheets.

Both of these are incredible pieces of software.
It's hard to argue with success.
And their cell forumla design is actually a powerful programming paradigm.
But I guess I do argue with success:
I kinda hate both of these programs.

First of all is their formats.
For a long time Excel had a proprietary file format `.xls`,
and when they switched to a more open XML based format `.xslx`
they made sure to keep big chunks effectively proprietary.
So while there are good open source libraries for reading and writing `.xlsx` format
they can't handle all the advanced features.
Google Sheets, on the other hand, doesn't provide any access to its native format,
just exports and APIs.
The thing I hate the most
is that these formats don't play well with all my other tools,
especially version control systems.

Excel does an amazing job at remaining backwards compatible
with versions going back to the 1990s.
That's a huge benefit to users.
But it also means that (almost) every mistake and misfeature continues to be supported,
and that we're stuck with an antiquated "programming language".
The forumla language for Excel is brutal to write,
and you have to do it in a stupid little text box instead of your favourite editor.
Google Sheets has a slightly cleaner language
but keeps a lot of ugly stuff for compatability with Excel.

Let's set those criticisms aside
and look at what spreadsheets offer that XSV doesn't:

- nice graphical user interface
- multiple tables
- charts
- datatypes
- formulas

You can get most of these features in a much lighter package.
For instance, you can convert XSV to HTML tables,
and you can run XSV through a program to make a chart.
But spreadsheet programs put this all together
in an interactive, visual way,
giving you instant feedback.

I want to emphasize datatypes:
spreadsheets let you specify the datatype for cells (and columns and ranges)
which means you can do numeric things with numbers
and money things with currencies
and scheduling things with dates.
XSV formats let you write numbers and currencies and dates,
but there's no standard way to tell a program what datatypes are intended.

## Examples of Tables

rank
----
2
3
4
5
6
7
8
9
10
jack
queen
king
ace

suit
----
clubs
diamonds
hearts
spades

Single cards might fit in a table like this:

rank | suit
---|---
queen | hearts

And this also seems to work fine for a poker hand:

rank  | suit
------|---------
2     | spades
queen | hearts
ace   | hearts
6     | clubs
10    | diamonds

or a deck of cards:




## Limitations

Tables are great.
Spreadsheets are great.
They're a huge success.
But sharing data by sharing spreadsheet files
only works for small groups and slow-moving data,
and eventually you have too much data to fit in one file.
You'll want to move that tabular data into a database.

And while a lot of data does fit nicely into a table,
there's quite a lot that does not.
The linked columns of relational databases help somewhat.
A key example of a poor fit is tree datastructures
which are natural for documents and source code.

