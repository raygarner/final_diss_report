.TL
Unix Style Computer Aided Composition 

Appendix A: Function Listings
.AU
20156967 
.NH 1
Common Data
.LP
.TS
center;
c c .
Data	Encoding
_
Pitch	Int
Interval	Int
Degree	Int
Scale	\[ci][Interval]
Mode	(Scale, Degree)
Root	Pitch
Key	(Root, Mode)
Chord	[Pitch]
Line	[Pitch]
Harmony	[Line]
Alteration	Int
.TE
.NH 1
Common Functions
.NH 2
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
.NH 2
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
.NH 1
Mode Generating
.LP
.TS
center;
l lx .
Function	Description
_
check_relative_modes(r, k)	T{
For all k[root][mode] in matrix k which are relative to key r, increment the cell value
T}
process_notes(n, k)	T{
For each pitch in list n call check_relative_modes(key(note,m), k) for each mode m
T}
.TE
.NH 1
Interval Filtering
.LP
.TS
center;
l lx .
Function	Description
_
degree_val(d, m)	T{
Return the interval between the first and degree d in mode m of the major scale in semitones
T}
correct_alteration(d, m, a)	T{
Returns true if the interval between the first and degree d in mode m is different to the
corresponding interval in the major scale
T}
.TE
.NH 1
Melody Generation
.LP
.TS
center;
l lx .
Function	Description
_
count_scale_steps(k, start, end)	Return the steps it takes to reach pitch end from pitch start in key k
generate_line(len, tones, k)	T{
Returns a melody line of length len using pitches from list tones as a skeleton and filled out with pitches from key k
T}
.TE
.NH 1
Melody Harmonisation
.LP
.TS
center;
l lx .
Function	Description
_
is_primary_degree(p, k)	Return true if pitch p is degree 1, 4 or 5 in key k else returns false 
add_middle_note(b, m, k)	T{
Return the pitch x such that the chord made up of pitch b in the bass, pitch x in the middle and pitch m in the melody forms the most complete chord possible in key k
T}
generate_middle_line(b, m, k)	T{
Return a line between the bass line b and melody line m that would such that they would be harmonious together in the key k
T}
pick_primary_chord(d)	T{
Return a primary chord degree which melody degree d is a part of
T}
faulty_note(b, m, k)	T{
Return the number of faults incurred by having bass pitch b with melody pitch m in key k
T}
count_faults(b, m, k)	T{
Return the number of faults incurred by having the bass line b with melody line m in key k
T}
alt_chord_choice(c, d)	T{
Return another primary chord degree other than c which degree d is a part of if possible, otherwise return degree c
T}
improve_bass_line(b, m, k)	T{
Returns an improved version of a simple bass line b using melody line m and key k as context
T}
generate_bass_line(m, k)	T{
Returns a simple bass line to work with melody line m in key k
T}
.TE
.NH 1
Conversion to MusicXML
.LP
.TS
center;
l lx .
Function	Description
_
write_headers()	Print MusicXML headers
write_part_def(i, n)	Print the definition for a part with name n and ID i
write_part_line(i, l, o, c)	T{
Print the MusicXML representation of line l with ID i in octave o using clef c
T}
.TE
.NH 2
Stave Key Signature Display
.LP
.TS
center;
l lx .
Function	Description
_
spacing(a, l)	T{
Returns the indent as a number of spaces required for correct placement of accidental a on stave line l
T}
print_key_sig(a, l)	T{
Prints the key signature on a stave to the terminal where p is a list of flags defining which lines should be altered and a is the alteration which should be applied if so
T}
note_status(a, n)	T{
Returns a list of flags representing which lines should be altered using accidental a to represent
the key signature with n instances of accidental a
T}
is_flat_key(k)	T{
Returns true if key k must be represented using flats rather than sharps, otherwise returns false
T}
calc_accidentals(a, k)	T{
Returns the number of accidentals of type a which must be used to represent key k
T}
relative_ionian(k)	T{
Return the root pitch of the relative Ionian for key k
T}
note_to_cf(p)	T{
Returns the number of sequential perfect fifth steps pitch p is from the pitch C
T}
.TE
.NH 2
Fretboard Mode Display
.LP
.TS
center;
l lx .
Function	Description
_
write_string(k)	Return a single guitar string representation of key k
note_to_fret(p)	Return the guitar fret which pitch p lies on a guitar E string
.TE
