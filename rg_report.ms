.ds DY
.RP no
.TL
Unix Style Computer Aided Composition
.AU
Ray Garner
.AU
20156967 
.AU
psyrg4@nottingham.ac.uk
.AI
Computer Science with Year in Industry Bsc
.AB
Computer aided composition is when a musician employs software tools to
create music.
The scope of computer aided composition varies from the production of small 
ideas such as melodies or chords to entire pieces.
In computer science terms, computer aided composition software reduces the 
search space a musician explores to find successful ideas.
This paper attempts to evaluate the effectiveness of applying Unix philosophy
to computer aided composition by implementing a system using orthogonal programs,
text streams and pipes and comparing the results to existing popular compositions.
.AE
I would like to thank God for everything.
.bp
.SH 1
List of abbreviations
.LP
.TS
l l .
CAC	Computer aided composition
DAW	Digital audio workstation
IRCAM	Institut de recherche et coordination acoustique/musique
LSEPI	Laws, social, ethical and professional issues
MIT	Massachusetts Institute of Technology
.TE
.SH 1
Music Glossary
.LP
.TS
l l .
Pitch	A value used to represent how high or low a note sounds
Interval	Difference between 2 pitches
Scale	A circular sequence of intervals and optionally a starting pitch
Degree	Ordinal representing where a pitch lies in a given scale. Also used to describe intervals
Mode	A scale with a specific interval treated as the first
Melody	A line either played alone or higher in pitch than all other concurrent parts
Chord	Two or more notes played concurrently
Harmony	The combination of notes in a sequence of 1 or more chords
Tonality	The mode or scale which the melody and harmony is built from primarily
Key	Representation of tonality for practical interpretation
Line	A sequence of single notes
Natural	Unaltered pitch
Sharp	Pitch raised by one semitone
Flat	Pitch lowered by one semitone
.TE
.bp
.NH 1
Introduction
.XS
Introduction
.XE
.LP
Computer aided composition is when a musician employs software tools to
create music.
The scope of computer aided composition varies from the production of small 
ideas such as melodies or chords to entire pieces.
In computer science terms, computer aided composition software reduces the 
search space a musician explores to find successful ideas.
Software can generate music from a range of input types:
`Bach in a Box'
.[
bach94
.]
shows harmony being generated from a specifically defined melody and
`COMPoZE'
.[
compoze
.]
shows music being generated from variable descriptors such as `ambition' and
`distribution'.
.PP
A scorewriter is a tool for writing and formatting sheet music.
A digital audio workstation is a tool for manipulating audio data.
The requirements for a tool to be a scorewriter, digital audio 
workstation and composition aid are different but a tool may be any combination
of the three.
This project focuses on computer aided composition.
.PP
The IRCAM
.[
composition99
.]
computer aided composition philosophy is that a user is best served by a
`visual programming language' because it provides the flexibility
required for accurate expression.
IRCAM's 
`PatchWork'
.[
patchwork89
.]
proved the effectiveness of this approach.
`OpenMusic'
.[
openmusic11
.]
, an IRCAM 
PatchWork 
successor, is used by institutes for 
research and education as well as by individuals for composition.
IRCAM solutions are an abstraction of Lisp, with `boxes' corresponding to
Lisp functions.
The IRCAM style solutions allow for ideas to be built by combining multiple 
individual ideas, each operating in one different element of music. 
For example, you could combine  
melody data with a tonality data to produce music.
.PP
`Unix Music Tools at Bellcore'
.[
unixmusic90
.]
demonstrates music software written for Unix and explains the
motivations for the design choices made.
Langston says that consumer music programs lack the ability to communicate with
each other, an issue caused by limitations of consumer PC operating systems.
The music software written at Bellcore was written with the Unix design 
philosophy 
in mind: an approach combining small orthogonal programs to solve 
larger problems
.[ (
unix84
.]).
Using a shell script, the Bellcore music tools can be combined to generate 
music and were even combined to form the backend of
`IMG/1'
.[(
img191
.]),
a tool for generating backing music for presentations.
More detail on the languages used to transmit musical data between programs
can be seen in
`Little Languages for Music'
.[(
littlelangmusic
.]).
.NH 1
Motivation
.XS
Motivation
.XE
.LP
The motivation for this project follows from the flaws in the Bellcore music
tools and IRCAM tools.
These tools share many similarities and what one fails at, the other tends to succeed at.
As shown in table 1, this project attempts to combine the successes of both of these systems.
.DS C
Table 1
.DE
.TS
center;
c | c c .
	OpenMusic workflow	IMG/1 workflow 
_
OpenMusic implementation		
IMG/1 implementation	This project	
.TE
.PP
Parallels between the IRCAM style solutions and the Bellcore music tools
can be drawn: both make the user interact with the system by sequentially applying
functions to a flow of data.
Functions in the IRCAM solutions are abstractions of Lisp functions, shown as
`functional boxes'
but in the Bellcore solutions, they are standalone programs written in C which read
from 
.CW STDIN 
and write to 
.CW STDOUT .
Data-flow handling for the Bellcore solutions is handled by the Unix operating
system with pipes and streams but
in the IRCAM solutions it is done with
Lisp data structures during the runtime of the main program.
A further parallel can be drawn between this contrast and the contrast
between `MIT' and `New Jersey' approaches described in `The Rise of Worse is Better'
.[ (
worseisbetter91
.]),
with OpenMusic falling into the `MIT' category (Lisp, correctness) and the
Bellcore music tools falling into the `New Jersey' category (see the literature
review section for more on this).
.PP
Viewing the IRCAM methodology through the lens of Unix philosophy raises the
question- why implement functionality already implemented by the operating 
system?
That is, why should the IRCAM solutions build another data flow framework when
one already exists built into Unix-style operating systems?
.PP
Comprising of over 90 separate programs, becoming acquainted with the Bellcore
music tools would be a daunting challenge for a non-technical composer and the
more user friendly `IMG/1', built on top of said tools, fails to provide an interface
facilitating sequential function application on a data stream like the `visual
programming language' of OpenMusic does.
.PP
This project attempts to create a modern Unix style counterpart to OpenMusic,
preserving the generality and expressiveness of its interface but implementing
its functionality using traditional Unix methods.
.NH 1
Aims and Objectives
.XS
Aims and Objectives
.XE
.LP
.NH 2
Musical
.LP
Primarily, this software will need to produce musical output in the form of
tonal, melodic and harmonic ideas for a human composer to interpret.
These ideas must adhere appropriately to established music theory principles
and relate accordingly to the input used to generate them.
For this project we will define `melody' as single voice sequential lines, 
`harmony' as a chord or sequence of chords (where a chord is 2 or more notes
played concurrently) and `tonality' as scales (where a scale is a set of intervals
combined with a starting note).
.NH 2
Architectural
.LP
For this project it is important that the musical goals are achieved using the
right means. The function of the system should be broken down into small
orthogonal programs which are combined by the user using Unix pipes to produce
the various outputs.
This is advantageous to a user because it shows them clearly how the aspects of
the system can be rearranged to produce a different desired output.
Monolithic systems such as IRCAM style solutions have a huge amount of internal
functions implemented to facilitate proper output production but they are not
exposed to the user for them to utilise, even though they may be of use.
Building the system up in a modular fashion allows the user to just use the
specific functions which they need rather than having to load the whole program
just to use a small portion of it.
.PP
The output format must be easy for a human to read, but also simple for a
computer program to interpret. This will make the user interaction more intuitive
by removing the need for intermediary translation programs in the pipeline.
.NH 2
Not objectives
.IP
MIDI output
.IP
Audio output
.IP
Entire piece composition
.IP
Rhythmic and textural manipulation
.IP
Real time interaction
.LP
This is not to say that these things may not be built on top of this system in
the future. It is important that this solution is extendable but this 
dissertation is not concerned with implementing these features.
.PP
MIDI describes more than just tonality, harmony and melody so it is beyond the
initial focus of this project. Audio output would require implementing support
for a whole new interface: speakers. This project is focused on human readable
text output which could be interpreted by a composer.
.PP
This software is not trying to be a composer, it is trying to be a tool which
a composer can use to generate prompts which they can implement. The composition
of an entire piece is a different problem to what is being solved by this
project.
.PP
Tonality, harmony and melody can all be handled in the same terms: sets
of pitches. Rhythm and texture require special notation beyond this for 
accurate representation so are outside the scope of this solution.
.PP
The execution of each of the 3 programs will begin with the reading of data
and end with the writing of data. Between these two points in time, no further
data will be inputted to the program.
This contrasts IRCAM solutions which are running constantly while a user works
on them but is in line with the Bellcore approach.
.NH 1
Literature Review
.XS
Literature Review
.XE
.LP
The crux of this project is combining elements IRCAM and Bellcore approaches 
to computer aided composition.
The `IRCAM' approach refers to PatchWork
.[
patchwork89
.]
and OpenMusic
.[ (
openmusic11
.]),
systems which provide a real-time, monolithic system developed using Lisp
based languages.
The `Bellcore' approach refers to the tool-set developed at Bellcore which provides
a wide array of music functionality.
Since there are so many tools listed
we will focus on one example demonstrated in `Unix Music Tools at Bellcore'
.[ (
unixmusic
.]):
generating chord progressions and generating melodies.
.PP
The contrast of approaches here is a strong reflection of the contrast of approaches
described in 'The Rise of Worse is Better'
.[ (
worseisbetter91
.]).
Gabriel compares what he called the `MIT approach' and the `New Jersey' approach.
The IRCAM approach is in line with the MIT approach because of its Lisp style 
and the Bellcore approach is inline with the New Jersey approach because of its
Unix style.
Initially Gabriel frames the MIT approach to be superior thanks to its 
unwillingness to compromise correctness, consistency and completeness for the
sake of simplicity.
By contrast, the New Jersey approach assigns greater value to simplicity,
going as far as to say that it is `slightly better to be simple than correct'.
Following this, it may be surprising to read further and discover Gabriel 
praising the New Jersey approach for its `better survival characteristics',
saying that software written in that style is more portable, allowing it to
spread faster and gain more use.
Currently there is no `New Jersey' style counterpart to the `MIT Style'
software like OpenMusic, so with this project I intend to explore the application
of `New Jersey' style software development in the field of computer aided composition,
building on ideas demonstrated by the Bellcore music tools.
.NH 2
IRCAM
.LP
IRCAM say the purpose of computer aided composition research was to `provide
composers with the means to develop musical ideas and models using the 
computer.'
Contrast with the Bellcore philosophy can be seen here because Bellcore tools
attempt automate composition but IRCAM leave the composition up to the composer
and just provide a means for them to work expressively with the computer.
My goal with this project is inline with the IRCAM philosophy, however I want
to implement a solution using a methodology inline with the Bellcore philosophy
(Unix philosophy).
.NH 2
Bellcore
.LP
Figure 1 in `Unix Music Tools at Bellcore' shows a script generating a `march'
style piece of music.
This task is decomposed into generating a chord chart, generating an 
accompaniment, generating a melody and then merging the melody and accompaniment.
For each of these tasks, there is an individual program to perform it and each
of these programs communicate by writing and reading to files.
First a 32 bar chord chart in the key of F with a `march' structure is generated.
This is then used to generate an accompaniment, and then used again to generate
a melody.
Finally the melody and accompaniment are merged to produce the finished piece.
.PP
This example shows an almost textbook application of the unix philosophy:
the system is broken down into orthogonal programs which each solve a general
problem and they are tied together using a shell script.
This makes things simpler for a developer because each individual program can be
debugged on its own and it is more expressive for a user because a system
structured this way allows for the components to be combined in various ways,
producing interesting results.
One shortcoming apparent here is that the tonality aspect of the system is 
limited: the user appears to be limited to only a major and minor 
key for each note in a western harmony system.
7 different modes can be derived from just a standard western 7 note major scale, 
these being used in different styles of music (more on this later).
What this example shows is also closer to computer composition than computer
aided composition.
For this project I am more interested in a computer aided composition system
producing prompts for a composer to arrange and implement.
In this context, the flexibility and expressiveness
of the user interaction is more important than the output being a finished piece.
.PP
A system built on top of the Bellcore tools is IMG/1
.[ (
img191
.]).
IMG/1 is used to generate musical accompaniment for powerpoint
style presentations.
This system falls more into the category of algorithmic composition than computer 
aided composition because it is aimed at users unskilled in music composition.
This contrasts OpenMusic and similar IRCAM projects because they try to provide
as much flexibility and freedom to allow skilled composers to express themselves
as accurately as possible. 
.NH 2
Justification for this work
.LP
This project attempts to combine the implementation philosophy of IMG/1
(Bellcore, Unix, New Jersey) with the composition and UI philosophy of OpenMusic
(general, flexible, and expressive).
The justification for this project follows from there being no `New Jersey'
or Unix-style counterpart to the `MIT' style IRCAM computer aided composition
software such as OpenMusic.
The closest thing there has been to this was definitely the Bellcore music
tools, however they were only available internally and not to real world
composers. Not only this, but the the Bellcore tools aren't focused on enabling 
computer aided composition and would be daunting and confusing for a
composer to use rather than a Unix expert.
IMG/1, built on top of the Bellcore music tools and aimed at unskilled users,
doesn't offer the generality, flexibility or expressiveness which IRCAM style
tools such as OpenMusic do.
This project attempts to fill this gap in the field and evaluate whether this
style of development can lead to effective computer aided composition software
being produced.
.NH 1
Methodology
.XS
Methodology
.XE
.NH 2
Technologies
.LP
Since this project is about exploring the effectiveness of applying Unix philosophy to
computer aided composition, the software will target Unix based platforms.
These include operating systems based on Linux, Hurd and BSD.
The basic requirement for the platform is that is provides Unix pipes for the
programs to communicate with.
.PP
The language with the most portability across Unix-like platforms is C.
Like Unix, C is strongly associated with the `New Jersey' philosophy
.[ (
worseisbetter91
.]).
According to Gabriel it was `designed using the New Jersey approach' and 
`designed for writing Unix'.
He attributes its popularity to its simplicity because it makes C 
compilers easier to develop.
As mentioned in the `Program Design in the UNIX Environment'
.[ (
unix84
.]),
C was originally the language for the Unix kernel and applications and
`essentially everything was written in C', which made the software easy to
modify and customise.
Continuing with the theme of Unix style and `New Jersey' style, I will write
the software in C.
This is also to make the software as portable as possible between the 
various Unix-like operating systems.
.NH 2
Music Theory
.LP
To understand the algorithms used in this project, it is essential to have a
basic grasp of western music theory.
In this section I will describe the core aspects of music theory which this
project primarily deals in: melody, chords and modes.
If at any point you are unsure the meaning of a musical term, please refer to
the music glossary at the beginning of this document.
Some useful further reading if you desire it is ``The AB Guide to Music Theory''
.[ (
abtheory1
.]).
.PP
Traditionally there are 12 tones used to represent pitch:
C, C#, D, D#, E, F, F#, G, G#, A, A# and B (using only sharps and no flats to represent them).
The interval between two adjacent tones in this sequence is known as a semitone
and the interval between every other tone in
this sequence known as a whole-tone.
For example, C and D are a whole tone apart and C and C# are a semitone apart.
.PP
The most fundamental scale in western music is the major scale, which is a
sequence of seven intervals: tone, tone, semitone, tone, tone, tone, semitone.
Scales such as this can be given a root note (note to start on) to produce a
set of notes which can be used to create music.
For example, a major scale with a root of C (aka C major scale) contains the
following notes: C, D, E, F, G, A and B because C is the first, a tone above C
is D, a tone above D is E, a semitone above E is F, and so on (recall the
sequence of intervals defining the major scale if this is not clear to you).
Each pitch in a scale can be given an ordinal to represent its function within
the scale and this is known as the degree of the scale which it is.
For example, C is the first degree of the C major scale and D is the second,
E is the third and so on. Each interval between each adjacent note in a scale
is known as a `step' and the other various intervals between notes in the scale
can be described in a similar way to how we use degrees. For example, E is a third 
above C and A is a third above F. 
.PP
Bare in mind that not every step in the scale represents the same difference
in pitch because some intervals of the scale are a tone and some are a semitone.
This means that the difference in pitch between C and E is different to that
of D and F. All `thirds' in the scale
are either the same as the difference between the first degree and the third
degree in the major scale intervals or of that in the minor scale intervals.
Hence, thirds are always `major' or `minor'.
Whether something is major or minor is an example of tonality, and when tonality
is not explicitly stated it is assumed major is being refered to.
.PP
Once we have established what scale we are using, we can begin to build chords.
The most fundamental chord structure is known as the triad which contains 3 notes:
the first, third and fifth. For each note of the major scale there is a triad
chord where it is the root. For example, chord 1 in the major scale is C, E
and G. Chord 4 in the major scale is F, A and C. The following table describes
the tonality of each chord in the major scale.
.TS
center;
c c .
Chord	Tonality
_
I	Major
II	Minor
III	Minor
IV	Major
V	Major
VI	Minor
VII	Diminished
.TE
Other than chord VII, the fifth in each of these chords is known as `perfect'.
It is called a perfect fifth because the difference in pitch between the first 
and fifth degrees is the same in the major and minor scales.
Chord VII is special because it is the only one where the interval between
its first and fifth is not that of the major scale, it is one semitone smaller.
The third of chord VII is minor.
.PP
The major scale has 7 modes because a mode is defined by treating a specific
degree as the first.
The following table shows the modes of the major scale, where ``relativity''
is the degree of the major scale treated as the first to define that mode.
.TS
center;
c c c .
Name	Relativity	Intervals
_
Ionian	1	TTSTTTS
Dorian	2	TSTTTST
Phrygian	3	STTTSTT
Lydian	4	TTTSTTS
Mixolydian	5	TTSTTST
Aeolian	6	TSTTSTT
Locrian	7	STTSTTT
.TE
Ionian is the modal name for the major scale and Aeolian is the modal name for the
minor scale. These 2 modes are by far the most common in western pop music but
others are used more frequently in different genres and styles.
To help understand the relativity of the modes, consider why C Ionian contains
all of the same notes as A Aeolian.
.NH 2
Algorithms
.NH 3
Melody Generation
.LP
``Melody Generator: A Device for Algorithmic Music Construction'' 
.[
melody10
.]
discusses some ideas for algorithmic melody generation.
One of these it calls the ``Chord-Based Model'' and it fundamentally works by 
using a chord
as a template for melody construction. Notes within the chord are placed on
`strong' beats in the rhythm to create a `skeleton melody' and notes of the 
scale are used to connect them to create the final melody. 
This simple technique serves as an ideal basis for a program within our system
which could be passed a chord as input and produce as melody as output.
Such input and output types are ideal for a program designed to sit in a pipeline
of others such as ours.
.NH 3
Harmony Generation
.LP
Harmonising Bach chorales is a common exercise for music students, whereby they
are given a melody line and tasked with adding 3 additional lines beneath it
in pitch to produce a satisfying piece of music.
``Bach in a box''
.[
bach94
.]
attempts to automate this process by producing a large amount of potential
solutions and evaluating them on criteria established by musicology.
This criteria is standard for Bach chorales and includes smoothness, range
and motion.
ChoraleGUIDE
.[
choraleguide
.]
is a popular resource for undergraduate and A Level music students looking to
improve their chorale harmonisation skills.
The algorithm I implemented for the harmony generating aspect of the system
is based on the method outlined by Pankhurst:
.IP
add simple bassline beneath melody
.IP
modify bassline to boost its evaluation against certain criteria
.IP
fill in middle part
.LP
A depth-first search is carried out in the bassline improvement step to find
the solution which best satisfies the criteria he proposes for the bassline
including:
.IP
balance of steps and leaps
.IP
no consecutive leaps in same direction
.IP
no repeated notes
.IP
not too similar to melody line
.IP
no `sirening' (up-down-up-down stepwise repetition)
.LP
Techniques he suggests to best avoid these are to modify the bassline line by
inverting the chords, using a different chord or both (hence why each node has
up to three children in the search tree).
.NH 1
Design
.XS
Design
.XE
.NH 2
Overview
.LP
As there are many ways to cut a cake, there are many ways to divide the overall
functionality of our system into orthogonal programs. The following outlines
how the system is broken down into building blocks which can be combined in
various ways to produce output.
.PS
F: box "Figure 1: example program functionality" invis at (1, 1)
A: box "a" invis wid 0.3 at (0, 0)
P: box "program" wid 1 at (1, 0)
B: box "b" invis wid 0.3 at (2, 0)
X: box "c" invis ht 0.3 wid 0.2 at (1, 0.75)
Y: box "d*" invis ht 0.3 wid 0.2 at (1, -0.75)
arrow from A.e to P.w
arrow from P.e to B.w
arrow from X.s to P.n
arrow from Y.n to P.s
.PE
Figure 1 shows an example program in the format we use to represent the components
of our system.
The program takes input of type
.CW a
via
.CW STDIN
as well as input of type
.CW c
as a command line argument and optionally input of type
.CW d
as another command line argument.
After reading these inputs, the program writes output of type
.CW b
to
.CW STDOUT .
.NH 2
Mode Generator
.LP
The ``mode generator'' is a program which takes as command line arguments a
set of notes and outputs the set of modes which each contain all of the notes
in the input.
If STDIN input is supplied then only modes also in the input set will be in
the output set, otherwise all modes are considered.
This functionality can be formalised using the following notation:
.EQ
pile {
INP = roman{"set of modes inputted via STDIN"} 
above { M = roman{"set of all modes"} }
above { N = roman{"set of notes passed as arguments"} }
above { P(m) = \[fa]n\[mo]N:n\[mo]m }
above { output = \[lC] m\[mo]M | (m \[mo] INP \[OR] INP = \[es]) \[AN] P(m) \[rC]}
}
.EN
Figure 2 shows the functionality of the mode generator in terms of its input
and output types.
.PS
F: box "Figure 2: mode generator functionality" invis at (1,0.5)
A: box "mode set*" invis 0.7 at (-0.5, 0)
P: box "mode generator" wid 1 at (1, 0)
B: box "mode set" invis wid 0.7 at (2.5, 0)
X: box "note set" invis ht 0.3 wid 0.8 at (1, -0.75)
arrow from A.e to P.w
arrow from P.e to B.w
arrow from X.n to P.s
.PE
.NH 2
Interval filter
.LP
The interval filter is a program which takes as input a set of modes and also
a set of intervals. It outputs all of the modes from the input which have the
intervals specified. If no modes are given as input it outputs the modes from
the set of all modes which have those intervals. This functionality is formalised
by the following notation.
.EQ
pile {
INP = roman{"set of modes inputted via STDIN"} 
above { M = roman{"set of all modes"} }
above { I = roman{"set of intervals passed as arguments"} }
above { P(m) = \[fa]i\[mo]I:i\[mo]m }
above { output = \[lC] m\[mo]M | (m \[mo] INP \[OR] INP = \[es]) \[AN] P(m) \[rC]}
}
.EN
Figure 3 shows the functionality of the interval filter in terms of its input
and output types.
.PS
F: box "Figure 3: interval filter functionality" invis at (1,0.5)
A: box "mode set*" invis 0.7 at (-0.5, 0)
P: box "interval filter" wid 1 at (1, 0)
B: box "mode set" invis wid 0.7 at (2.5, 0)
X: box "interval set" invis ht 0.3 wid 0.8 at (1, -0.75)
arrow from A.e to P.w
arrow from P.e to B.w
arrow from X.n to P.s
.PE
.NH 2
Chord Builder
.LP
The chord builder is a program which takes as input a set of modes and also
a degree of the scale to build a chord from with it as the root.
Optionally, it may also take the degrees of any extensions to be added to the chord,
relative to the chord root.
For each mode in the input there is a corresponding chord in the output set.
Chords are written to the output paired with the mode from the input used to
build them.
As with the previously mentioned programs which take as input a mode set via
.CW STDIN ,
if no modes are supplied the set of all modes is used.
.PS
F: box "Figure 4: chord builder functionality" invis at (1,1)
A: box "mode set*" invis wid 0.7 at (-0.5, 0)
P: box "chord builder" wid 1 at (1, 0)
B: box "chord set" invis wid 0.7 at (2.5, 0)
X: box "root degree" invis ht 0.3 wid 0.2 at (1, 0.75)
Y: box "extensions relative to root*" invis ht 0.3 wid 0.2 at (1, -0.75)
arrow from A.e to P.w
arrow from P.e to B.w
arrow from X.s to P.n
arrow from Y.n to P.s
.PE
.NH 2
Melody Generator
.LP
The melody generator is a program which takes as input as set of chords and
produces a melody for each one which would work played concurrently with that
chord. In addition to a set of chords as input, it takes the length of the
melody to be generated and a seed value for randomness.
.PS
F: box "Figure 5: melody generator functionality" invis at (1, 1)
A: box "chord set" invis wid 0.7 at (-0.5, 0)
P: box "melody generator" wid 1 at (1, 0)
B: box "melody set" invis wid 0.7 at (2.5, 0)
X: box "length" invis ht 0.3 wid 0.2 at (1, 0.75)
Y: box "seed" invis ht 0.3 wid 0.2 at (1, -0.75)
arrow from A.e to P.w
arrow from P.e to B.w
arrow from X.s to P.n
arrow from Y.n to P.s
.PE
.NH 2
Melody Harmoniser
.LP
The melody harmoniser takes a set of melodies as input and for each one
writes 3 part harmony for it to the output set of harmonised melodies.
Each 3-part harmony has the melody in the highest pitch line, with 2 accompanying
lines beneath it in pitch.
.PS
F: box "Figure 6: melody harmoniser functionality" invis at (1, 0.5)
A: box "melody set" invis wid 0.7 at (-1, 0)
P: box "melody harmoniser" wid 1.2 at (1, 0)
B: box "harmonised-melody set" invis wid 1.5 at (3, 0)
arrow from A.e to P.w
arrow from P.e to B.w
.PE
.NH 2
MusicXML Formatter
.LP
The musicxml formatter reads a set of harmonised melodies and outputs sheet music
containing each one after the other, represented using MusicXML
.[ (
musicxml01
.]).
.PS
F: box "Figure 7: melody harmoniser functionality" invis at (1, 0.5)
A: box "harmonised melody set" invis wid 1.5 at (-1, 0)
P: box "musicxml formatter" wid 1.2 at (1, 0)
B: box "musicxml data" invis wid 1 at (3, 0)
arrow from A.e to P.w
arrow from P.e to B.w
.PE
.NH 2
Mode Displays
.LP
To demonstrate the extensibility of the system, I developed 2 alternate 
end-points for mode sets to be pipes into.
Instead of generating musical ideas which could be piped into other programs, 
these draw alternate representations of modes in the terminal for the user to
read.
There is one to display modes on a guitar fretboard and one to display them
on a stave using traditional key signature notation.
.PS
F: box "Figure 8: fretboard formatter functionality" invis at (1,0.5)
A: box "mode set" invis wid 0.7 at (-1, 0)
P: box "fretboard formatter" wid 1.2 at (1, 0)
B: box "fretboard display" invis wid 1 at (3, 0)
arrow from A.e to P.w
arrow from P.e to B.w
.PE
.PS
F: box "Figure 9: stave formatter functionality" invis at (1, 0.5)
A: box "mode set" invis wid 0.7 at (-1, 0)
P: box "stave formatter" wid 1.2 at (1, 0)
B: box "stave display" invis wid 1 at (3, 0)
arrow from A.e to P.w
arrow from P.e to B.w
.PE
.NH 2
Component Combinations
.LP
Although each component program provides useful functionality alone, it is the
compatibility between them which is the main asset of this design.
Various permutations of the programs can be used to produce different results.
.PP
Figure 10 shows a particularly long pipeline beginning with generating a set of 
modes and ending with a set of harmonised melodies represented in MusicXML 
format. The number of harmonies in the output will be the same as the number of 
chords outputted from the chord builder because for each of the programs 
between them there is one member in the output set generated from each 
member of the input set. 
.PS
F: box "Figure 10: from modes to harmonies" invis at (2.25, 1.1)
A: box "mode" "generator" wid 0.6 at (0, 0)
B: box "interval" "filter" wid 0.6 at (0.75, 0)
C: box "chord" "builder" wid 0.6 at (1.5,0)
D: box "melody" "generator" wid 0.6 at (2.25,0)
E: box "melody" "harmoniser" wid 0.7 at (3.1,0)
F: box "musicxml" "formatter" wid 0.6 at (3.9,0)
arrow from A.e to B.w
arrow from B.e to C.w
arrow from C.e to D.w
arrow from D.e to E.w
arrow from E.e to F.w
I: box "mode" "set*" invis wid 0.3 at (-0.75, 0)
O: box "MusicXML" "harmonies" invis wid 0.6 at (4.65, 0)
arrow from I.e to A.w
arrow from F.e to O.w
P: box "note" "set" invis wid 0.5 at (0, -0.75)
Q: box "interval" "set" invis wid 0.6 at (0.75, -0.75)
R: box "root" "degree" invis wid 0.5 at (1.5, 0.75)
S: box "extensions*" invis wid 0.5 ht 0.2 at (1.5, -0.75)
T: box "length" invis wid 0.4 ht 0.2 at (2.25, 0.75)
U: box "seed" invis wid 0.3 ht 0.2 at (2.25, -0.75)
arrow from P.n to A.s
arrow from Q.n to B.s
arrow from R.s to C.n
arrow from S.n to C.s
arrow from T.s to D.n
arrow from U.n to D.s
.PE
.PP
A user may choose to build up such a pipeline incrementally by first only only
using the mode generator, analysing the output and then deciding to append
the interval filter to the pipeline, thereby removing modes which do not meet their
criteria. Once satisfied, they could examine the chord of a given nature for
each of these modes using the chord builder and then if they wish append the
melody generator to produce a melody to work over each of the chords built.
From here it would be simple to append the harmoniser and MusicXML formatter
to the pipeline and redirect the output to a file using the standard
.CW >
Unix operator.
MusicXML files can be opened in a variety of scorewriters, such as Musescore 
.[ (
musescore15
.]),
which offer playback
functionality, allowing the harmonies to be listened to and edited in other
programs.
.PP
It is important to note that the pipeline could end with any of the programs
and the output could be redirected to a file by the user. This may be satisfactory
and the end of the users interaction with the system, or they may wish to use
the file later to input into another pipeline build using the components of 
the system.
Not only this, but the user may wish to manually write musical data to files
and then input them into a pipeline. The transmission language used by the system
has deliberately been kept as simple as possible to make this easier for users.
.PP
The following table lists the STDIN input and STDOUT output types for each
of the component programs. If a program Y has input type of A and and
a program X has output type of A then X can be piped into Y.
.TS
center;
c c c .
Program	Input Type	Output Type
_
Mode generator	Mode set	Mode set
Interval filter	Mode set	Mode set
Chord builder	Mode set	Chord set
Melody generator	Chord set	Melody set
Melody harmoniser	Melody set	Harmonised melody set
MusicXML formatter	Harmonised melody set	MusicXML
Stave formatter	Mode set	Stave display
Fretboard formatter	Mode set	Fretboard display
.TE
.NH 1
Implementation
.XS
Implementation
.XE
.LP
Focus on pseudocode and diagrams
.NH 2
Common Data Types
.LP
.TS
center;
c c .
Data	Encoding
_
Pitch	Int
Interval	Int
Degeree	Int
Scale	\[ci][Interval]
Mode	(Scale, Degree)
Root	Pitch
Key	(Root, Mode)
Chord	[Pitch]
Line	[Pitch]
Harmony	[[Pitch]]
Alteration	Int
.TE
.NH 2
Common Functions
.NH 3
Input/Output
.LP
.TS
center;
l lx .
Function	Description
_
read_accidental(a)	Return encoded alteration a
read_note(p)	Return encoded natural pitch p
read_tone(p, a)	Return encoded pitch p with alteration a
read_mode(m)	Return encoded mode m
init_key_field(k, i)	T{
Initialise all cells of M\[mu]N matrix k with value i where M is number of pitches and N is number of major scale modes
T}
read_key_list(k, x)	For each key(root, mode) read from STDIN set k[root][mode] to x
print_matching_keys(k, x)	For each k[root][mode] equal to x print key(root, mode)
is_accidental(p)	Returns true if the decoding of p requires a sharp or flat else returns false
is_correct_accidental(k, a)	Returns true if the decoding of key k can be represented using accidental a
get_correct_accidental(k)	Returns an accidental which the decoding of key k can be written using
print_note(a, p)	Print decoding of pitch p using accidental a
.TE
.NH 3
Internal
.LP
.TS
center;
l lx .
Function	Description
_
clock_mod(x, m)	T{
Returns a member of {0..m} congruent to x where x may be positive or negative
T}
step(d, k)	T{
Returns the pitch one step up from degree in key
T}
calc_degree(p, k)	T{
Returns the degree of pitch p in the context of key k
T}
is_diatonic(p, k)	T{
Returns true if pitch p is in key k, false otherwise
T}
apply_steps(d, k, s)	T{
Returns the pitch s steps from degree d in key k where s may be positive or negative
T}
min_tone_diff(p, q)	T{
Returns the minimum pitch difference between pitches p and q in semitones
T}
.TE
.NH 2
Mode Set Building
.NH 2
Mode Set Filtering
.NH 2
Chord Building
.NH 2
Melody Generation
.NH 2
Melody Harmonisation
.NH 2
Conversion to MusicXML
.NH 2
Stave Key Signature Display
.NH 2
Fretboard Mode Display
.NH 1
Evaluation
.XS
Evaluation
.XE
.NH 2
Methodology
.LP
For effective testing and evaluation of the system a 
quantitative method of output analysis must be established.
Empirical analysis on Bach chorales has been done by segmenting the the music
into `pitch-class sets'
.[ (
bach08
.]).
This abstracts away intricacies of individual voice 
lines and represents the music as a sequence of chords.
With a simpler representation of the music, frequency of pitch-class sets and
pitch-class set transitions can be examined.
Rohrmeier discusses the significance of symmetry in pitch-class set transitions.
He finds that transitions show a high degree of symmetry.
That is, for all pitch-class sets X and Y, the frequency of X-Y transitions is
roughly equal to the frequency of Y-X transitions.
This corresponds with music theory ideas of `tension' and `resolution'.
.PP
A `tonal hierarchy' represents the importance of each diatonic note in a given
tonality.
An empirical investigation into this concept has been done in `A Theory of
Tonal Hierarchies in Music' 
.[
tonal10
.]
where listeners were played an incomplete scale followed by the tonic of the
scale and then rated the completeness of what they heard.
This experiment is known as the `probe tone method' and figure 3.1 in that 
paper shows the results.
These results also reflect ideas established in traditional western music theory
because notes belonging to the tonic triad scored the highest.
The results from this experiment provide a good benchmark for the frequency
of notes in music.
That is, the frequency of notes in melodies which listeners find satisfying 
will roughly match the results of the `probe tone' experiment.
.PP
With these ideas in mind, we can start to apply similar methods to existing
compositions and build a picture to which we can compare analysis
of the output of this project against. `Music21'
.[
music21
.]
is a Python module which provides a framework for musicology.
As well as providing a rich toolkit for the analysis of music, it also
has a built in corpus of roughly 3000 pieces comprised of popular folk songs
and works by over 20 iconic classical composers from varying eras.
To create a benchmark to compare the output of my system to, I will apply
the aforementioned music analysis techniques to the Music21 corpus using the
functions it provides.
.NH 2
Melody
.LP
To evaluate the musicality of melodic ideas generated using our system, we
compared output from the melody generator to data in the ``Essen Folksong Collection''
.[ (
essen87
.]),
which is included in the Music21 corpus.
Folksongs are quintessentially melodic; they propagated through societies and
gained cultural significance not because populations learned the chord progressions
but simply because the melodies where `catchy' to the ear.
Explained more concretely, there structure agrees with the findings of the
aforementioned `probe tone' experiment which found that listeners consider
melodic phrases to sound more `complete' when they end on specific notes of
the scale (notes in the tonic triad).
It follows then that if we use as input to the melody generator the tonic
triad of a scale, the melodic output will have similar characteristics to
folksongs.
Conveniently, the Essen Folksong Collection is encoded in ABC format
.[ (
abcmusic
.]),
which focuses primary on representing the main melody line of the music while
additionally providing the tonality of the piece (the musical mode it is built 
from).
.PP
To test this theory, I produced 100 6-note melodies (each with a different seed value)
using the melody generator and used Music21 to carry out frequency analysis on
degrees of the scale in the melody. For example, if a C note is found in the
key of C then the frequency of 1st degree notes has increased by 1. If a D note
is found in the key of C then the frequency of 2nd degree notes has increased
by 1, and so on.
Evaluating the frequency of degrees of the scale rather than of notes is
much more useful because the degree of the scale it is built from represents
the function of that note in its melodic context.
This idea of scalic context being what gives a note its character to listeners
is proven by the probe-tone experiment because they were only able to assign
a `completeness' value to each note of the scale when it was preceded by stepwise
ascension of the scale.
Corresponding analysis was produced a subset of the Essen Folksong 
Collection. The pieces in the Essen Folksong Collection use a variety of
tonalities so the tonality information in the ABC encoding was used to
convert notes to degrees of their respective scales.
The following graph shows a comparison of the frequency analysis of my system compared 
with that of the folksongs.
.PSPIC -C img/eval/note_freq.eps
As you can see, the notes of the tonic triad (1, 3 and 5) are the most common
in both, which correlates with the results of the probe-tone experiment.
However, the extent to which these notes are emphasised is higher in the output of our
system. This is probably because the melodies were generated using a tonic
triad as input. The emphasis of these notes could be made less prominent by
passing extensions to the chord generator as arguments, but the level
of emphasis played on the tonic triad notes in the example is acceptable.
Alternatively, the amount of randomness used in the generation of melodies
could be increased to even out the distribution.
.PP
The next graph shows the same method analysis applied note transitions rather
than notes. It is essential to analyse the frequency of transitions as well
as the frequency of individual notes to prove the musicality of the output
of our system because it shows that the distribution of the note instances in
the melody is satisfactory Aspell as just the overall frequency.
The frequencies are shown on matrices whereby the value at row N column M
represents the frequency of N-M transitions. Lighter colours represent higher
frequencies.
.PSPIC -C img/eval/melody_note_trans_freq.eps
This analysis shows that both sets of melodies have a tendency to move stepwise,
that is most transitions are to an adjacent note in mode used to build the
melody.
The analysis shows that our systems tends to produce a pattern-like and
uniform melodies, which could be deemed as un-musical according to taste. 
A simple way to rectify this would be to increase the amount of randomness 
used in the algorithm.
Both sets also show to have high levels of transition symmetry. That is,
the amount of N-M transitions is similar to the amount of M-N transitions.
.NH 2
Harmony
.LP
Harmonic analysis was performed by comparing output from the melody harmoniser
to a subset of the Music21 Bach corpus.
As in ``Statistical Properties of Tonal Harmony in Bach's Chorales'', 
.[
bach08
.]
the music of Bach has been selected due to its consistent style and overwhelming
popularity. Additionally, the principle of taking a single line melody and adding
additional voices beneath it in pitch to create harmony was popularised by his
working applying this technique to hymn tunes and it is this principle which
the melody harmoniser applies. The techniques I used to analyse harmony are
similar to those used to analyse melody, except instead of converting notes
to scale degrees, chords are converted to scale degrees. The scale degree a
chord maps to is the scale degree of its root note.
The Essen Folksong Corpus would have been a poor choice for comparison because
the pieces lack the harmonic depth which Bach provides and also the ABC format
cannot accurately represent multiline harmonies such as what Bach and the output
of the melody harmoniser deal in.
As with the melodic analysis, I used our system to generate 100 6-note melodies
but then piped them into the melody harmoniser and then into the musicxml 
formatter.
The Music21 Bach corpus is also encoded using MusicXML which means we can use
the Music21 MusicXML `chordify' function on our data as well as the Bach corpus
to convert them to a list of chords.
Bach's music changes key often (the mode used to generate the music can change
to a different one during a piece) so this must be considered when converting
the chords to scale degrees. Thankfully, Music21 provides functionality to
re-analyse the key frequently at any point during the MusicXML data, which allows
us to accurately perform frequency analysis on the scale degrees of the chords used.
The following graph compares the frequency of chords in Bach's compositions and
the output of the melody harmoniser.
.PSPIC -C img/eval/chord_freq.eps
In music theory, chords 1, 4 and 5 are considered the primary chords and have
particular importance.
.[ (
abtheory1
.]),
so it follows that they should be the most frequent in music adhering to a
fundamental style.
The analysis shows that this is the case for the output of our melody 
harmoniser and that it is the case for the Bach, apart from he seems to
emphasise chord 2.
The emphasis on chord 2 could be due to Bach's heavy usage of the 2-5-1
progression in his music, which is a staple of Baroque era music
.[ (
westmusic99
.]).
.PP
As with the melody analysis, it is essential to examine the frequency of
transitions as well of individual chords to ensure the distribution is also
accurate. The next graph presents chord transition data the same way as was
done for melody note transitions.
.PSPIC -C img/eval/chord_trans_freq.eps
In music a `cadence' refers to a chord transition at the end of a phrase
and the most fundamental cadences are the `perfect cadence' (5-1), `plagal
cadence' (4-1) and `imperfect cadence' (1-5)
.[ (
abtheory1
.]).
It is satisfying then that these transitions are shown to be the most common
in the output of the melody harmoniser.
The Bach analysis shows some emphasis towards the primary cadences, however
not as much as I expected, with a distinct lack of 4-1 transitions.
This could be due to the algorithm which Music21 uses to `chordify' the 
MusicXML representations misinterpreting some instances of chord 4 as chord 1
(they both have the first degree of the scale as a note). The MusicXML for
the Bach works is far more complex than the MusicXML for my harmonised melodies
so its possible this is causing some complications for the chordify algorithm.
Nonetheless, the correlation between the harmonised melodies produced by my system,
Bach works and fundamental music theory is strong enough to be acceptable
in my opinion as subjective factors such as `taste' and `style' mean this kind 
of analysis is not an exact science.
.NH 1
Summary
.XS
Summary
.XE
.NH 2
Project Management
.NH 2
Contributions and Reflections
.NH 2
Future Extensions
.IP
Parameterise the amount of voices for hrm
.IP
chord identifier
.IP
melody generator arg to switch argv and stdin input types
.IP
readers for musicxml and abc
.[
unixabc13
.]
.ds CH
.bp
.TC
.bp
