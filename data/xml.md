# XML

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

## eXtensible

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

## Schemas

DTD
RelaxNG

## Queries

XPath
XQuery

## Templates

XSLT

## Examples in XML

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

## Limitations

XML is great for documents.
It's not so great for 

