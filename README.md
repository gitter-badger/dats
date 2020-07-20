# dats 
Compose music in a text editor.


Example: 
```
BEGIN
BPM 120.0;

NOTE 1 C3;
NOTE 4 D3;

END 
```
- A note begins by declaring the note length with the keyword,
"NOTE". "NOTE" must be immediately followed by it's value; either "1", "2",
"4", "8" or "16", then a key ([KEY][OCTAVE]), followed by a `semicolon`.


# Building 
Assuming you have flex and bison already installed, Dats can
be built by running `make` inside the `src` directory.

If dats was executed without arguments, the default input is stdin.

Once executed, dats's output is a wav file named "write.wav" playing
the text sheet.  For the moment, the default soundfont is a sine
wave. Technically, the attenuation of a sine wave.

To test dats, run, `./dats ../examples/kuchizuke/diamond.dats`.

## TODO
- [ ] Able to export midi files

- [ ] Able to take arguments (getopt.h)

