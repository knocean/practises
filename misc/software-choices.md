# Why I Don't Use Your Software

**Spoiler alert!**
I wrote this for myself, asking myself a question:
Why don't people use *my* software?

I'm sure that you're an amazing developer,
and your software is excellent.
You did all sorts of work to build it.
Maybe you're giving it away for free
or for a very reasonable price.
I'm not asking you to change anything.
You're great and your software is great,
but I don't use it because:

## It's SaaS (Software as a Service)

I don't mind paying for great services and software,
but I can't afford to be locked in to it.
I need to be confident that your service will still be around in 5-10 years.
Sooner or later, your service will shut down or change.
I need a clear off-ramp.
So I tend to host my own services on my own infrastructure.

Exceptions:

- GitHub: has built a lot of trust, and has clear off ramps
- Slack: borderline; there's a strong network effect;
  it offers data exports;
  I don't use the integration features;
  I'm careful not to use it for critical data

## It isn't open

When I put time and effort into open source software
I'm fairly confident that I can continue to benefit from it.
I feel like I'm making an investment.
I can't invest in a closed platform,
because I have no control over it.
I can't ask my clients and collaborators to invest in a closed platform.
Most of the work I do is open source and open science,
and it's really important to me that the whole toolchain is open.
I need to know that if you stop supporting this software
then I still have options
such as fixing bugs myself or paying somebody to fix them.

Exceptions:

- macOS/iOS: I use it, but I'm careful that all my data is stored in open formats, so I have an off ramp
- MS Office: I use it, but only to the extent that there are open libraries for accessing the content;
  I avoid the fancy features that don't have open implementations

## It uses a weird license

I'm sure you have good reasons to choose the license that you chose,
but I need to worry about how your license interacts with
the licenses for all the other software that I might use it with.
And I'm just not going to spend money on a lawyer
to get an answer like "it depends".
Common licenses might be strictly worse than your license,
but "safety in numbers" is a thing.
I want to stick with the herd.

## It uses a weird language

I have my favourite languages,
just like you do.
A lot of the time I have to use languages that I don't like.
I'm not telling you what language to use,
especially not if you're giving this code away for free!
You spend your time as you choose!
But if I'm going to use your code,
then it has to fit into platforms and deployment scenarios
that I'm comfortable with.
Even if your code is open,
I still need to know that I can get somebody to fix bugs.

Exceptions:

- PostgREST: Haskell is a bit "weird", but it has "critical mass";
  PostgREST is just really solid, and I don't expect to ever need to change it

## It uses a common language that I don't trust

Here you might start getting annoyed with me,
but there are some common languages and platforms that I don't trust.
This might be because I had a bad experience,
or because I see that a lot of people have had bad experiences,
or it might be because I have unfair biases.
Maybe I'm just wrong.
But I don't have time to argue with you about it,
and I'm not likely to change my mind without a huge array of diverse data.
Languages I don't trust include PHP.
Platforms I don't trust include Node.js.
I do use JavaScript,
but only grudgingly,
when it's the only good option that I see.

## It's too "big"

I've been burned in the past by software that was too "big".
I'm not talking about the size of the code base, really.
I'm not talking about the number of dependencies, really.
I'm really talking about the size of the problem you're trying to solve:
the problem is too big.
You're trying to solve too many problems at once.

I like small, sharp tools.
They're small because they solve small, well-defined problems.
They're sharp because they're focused on solving that small problem well.
For a different problem, I'll use a different tool.

Other ways to say this:

- the Unix philosophy
- orthogonality and compositionality

I would much rather solve a big problem
with a combination of small sharp tools
than one big tool.
The single best reason for this is: managing change.
If the big problem changes,
it's usually pretty easy to replace one or two small tools.
It's often hard or impossible to change the big tool.
The big tool was built to solve one specific big problem.
It solves that problem -- great!
But now I have a different problem.



## I don't understand it

I don't want to know all the details of your code.
I don't even want to know all the details of my code!
I'm not the sharpest cookie in the shed,
but I try to have at least a vague idea of what's going on.
But if I'm going to put time and effort into using a piece of software
then I need to have some idea of what it's doing and why.

I like to see the first paragraph of the README
spelling out what problem this software solves
and a quick summary of how it solves the problem.
That makes a very good first impression.

Next I'll look for documentation.
Documentation comes in various different forms,
but there should be *something*.
I especially like looking at integration tests
(when I can find them)
to see examples of how to use the software.

If I'm interested in a piece of software,
I'll look around the source tree.
If the files and directories I see
are nicely organized using names that clearly
apply to the problem space and the solution,
then I start to understand better,
and I'm more confident that if I *do* want to dive into the details
(say to fix a bug)
then I'll be able to figure things out.

This point really builds on the previous point:
if the problem is too big,
then it will be hard to explain.


## I tried and it didn't work

It looks like it could be what I'm looking for, and I found a nice step-by-step instructions in your documentation. 
But it doesn't work. It could be missing examples files, not listing all depedencies, or need that special encironemnt variable be set up. 
I tried, looked around a bit, but it still doesn't work. 

The issue is that I trusted you and the tutorial, and you've broken that trust.
I end up resenting the hour of my life I'm not getting back.

## It doesn't seem to be maintained

If your code is open,
I expect to see a public version control repository
with an issue tracker.
I do prefer GitHub, because it's familiar,
 but other hosting solutions are ok.
I admit that I usually glance at the number of GitHub stars.
If the last modification was years ago
then I'll need to be convinced that the software is "done".
That usually happens when it solves well-defined problem
and builds on a stable platform
(a lot of Clojure libraries are like this).
If there's a ton of open issues and PRs
then I'll be a little worried.

## It doesn't look polished

Now we're getting a big nitpicky, I admit.
But if I have the choice between two software packages,
all else being equal,
I'll probably pick the one with the better website.
I don't really care about the cute logo,
but it's a signal that a bunch of people really care about this project.
I need to see a clear license,
but it's also nice to see clear contribution guidelines and policy statements.
I like to see that continuous integration is passing,
that there's been a recent release to the relevant package manager,
that somebody took the time to write a nice CHANGELOG.

I know that stuff takes a ton of work.
I don't like doing that stuff -- who has time?!
But that's exactly the point.
This is all a signal that people are putting work into this project,
likely a bunch of different people with different skill sets,
and they're sweating the details.
It gives me a warm feeling.

So first I look for all those other things,
but then I look at the level of polish.

## To say it again...

I'm not asking you to change your software.
I'm not making any demands on you.
You're great and your software great, just the way it is!
I'm just trying to explain why
(no matter how great it is)
I just can't, or I just won't, use it.

## Twist ending!!

I wasn't talking to you at all!
You've been eavesdropping on a private conversation
between me and my [rubber duck](https://en.wikipedia.org/wiki/Rubber_duck_debugging).
He was politely explaining to *me*
why he doesn't use *my* software,
and now I'm rethinking a lot of things.


<a href="https://commons.wikimedia.org/wiki/File:Rubber_duck_assisting_with_debugging.jpg#/media/File:Rubber_duck_assisting_with_debugging.jpg"><img src="https://upload.wikimedia.org/wikipedia/commons/d/d5/Rubber_duck_assisting_with_debugging.jpg" alt="Rubber duck assisting with debugging.jpg"></a>

Image by <a href="//commons.wikimedia.org/wiki/User:Tom_Morris" title="User:Tom Morris">Tom Morris</a> - <span class="int-own-work" lang="en">Own work</span>,
<a href="https://creativecommons.org/licenses/by-sa/3.0" title="Creative Commons Attribution-Share Alike 3.0">CC BY-SA 3.0</a>,
<a href="https://commons.wikimedia.org/w/index.php?curid=16745966">Link</a>
