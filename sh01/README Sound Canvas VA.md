
## About the recordings

This BGM pack was created by running the MIDI files through [Sound Canvas VA](https://www.roland.com/global/products/rc_sound_canvas_va/features/), a VST emulation of the original Roland SC-88Pro hardware synthesizer for which ZUN originally composed these soundtracks. This software-based rendering approach has several advantages over real-hardware recordings when it comes to looping BGM tracks:

* Note timing is perfectly accurate, rather than being impacted by MIDI cable and hardware processing delays.
* With no vintage synthesizer DAC or audio cables involved, the rendered output is free of recording noise and distortion.
* Loops can be perfectly continuous and inherently free of glitches, as they can be constructed by separately rendering the intro and loop parts and then splicing the two together at exact sample positions, instead of cutting them by ear in a trial-and-error process.

In exchange, the resulting sound is noticeably cleaner and drier compared to real hardware, which you may or may not prefer.\
Most notably, the reverb on most tracks also sounds noticeably different compared to real hardware and the Romantique Tp recordings, as Sound Canvas VA ignores the invalid Reverb Macro messages in 34 of the 39 tracks across both of Shuusou Gyoku's soundtracks. See [issue #1](https://github.com/nmlgc/BGMPacks/issues/1) for details, and [the corresponding ReC98 blog post](https://rec98.nmlgc.net/blog/2024-03-09) for a more detailed documentation of the differences.

### Rendering process

All edited MIDI files were rendered using Sound Canvas VA version 1.1.6, which was the latest version available in the [Roland Cloud](https://www.rolandcloud.com/) in mid-December 2023.\
The conversion was done in foobar2000 v2.0 x64, with v2.9.1.3 of the [foo_midi component](https://github.com/stuerp/foo_midi).
