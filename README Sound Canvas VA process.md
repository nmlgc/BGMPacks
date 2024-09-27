
#### Conversion

1. Restrict foobar2000 to a single conversion thread by setting *File → Preferences* (Ctrl+P) *→ Advanced → Tools → Converter → Thread count* to 1.\
   As it's typical for the VST industry, Sound Canvas VA is excessively DRM'd and allows only a single process to run at any given time. This causes foobar2000's regular parallel bulk conversion to throw a *Parameter File1 Read Error* for every Sound Canvas VA process spawned beyond the first.

2. Set foo_midi to use the *GS SC-88 Pro* flavor (*File → Preferences* (Ctrl+P) *→ Playback → Decoding → MIDI Player → MIDI → Flavor*).

3. In Sound Canvas VA's VST Editor, enable SC-88Pro mode by setting *Option → SYSTEM → Map Mode* to *SC-88Pro*.\
   Leave all other settings at their defaults, including the volume.

4. Set foobar2000's conversion feature to output 32-bit float .WAVs. This preserves any waveform content above 0&nbsp;dBFS, which would otherwise be permanently clipped for any FLAC conversion, and allows the volume to be tuned independently of the rendering.

#### Per-file loop construction steps

1. Split each MIDI into two files that only contain the notes of the intro and loop part, respectively:

   ```console
   <file.mid mly filter-note -v 0 (loop start) >file_intro.mid
   <file.mid mly filter-note -v (loop start) (loop end) >file_loop.mid
   ```

2. Render all MIDI files through foobar2000's converter.

3. Trim leading and trailing silence from all resulting .WAV files. I used GoldWave's feature here, with a threshold of -77.00&nbsp;dB. Both the intro and loop files now end immediately after the release/reverb trail of their last notes has faded out to silence.

4. Inside `file_intro.wav`:

   1. Take the `First note` sample position reported by `mly loop-find` and add that many samples of leading silence to synchronize it with both the source MIDI and the sample numbers reported by mly.

   2. Mix in all of `file_loop.wav` at the `Loop start` sample (𝐒).

   3. 𝐃 = Number of samples between the `Loop end` sample (𝐄) and the end of the file.

   4. Mix in the first 𝐃 samples of `file_loop.wav` at 𝐄.

   5. The final loop start point is at (𝐒 + 𝐃), forming a continuous waveform with the end of the file.

#### Non-looping files

1. Synchronize the `First note` as explained for looping files.

2. Non-looping files must still be an exact number of samples long to ensure that the Music Room note display syncs up with the MIDIs after looping. This length can be determined via `mly duration`; add trailing silence as necessary.

#### Volume adjustment and FLAC conversion

Bringing down the volume level of the rendered tracks below 0 dbFS now presents a choice:

1. Should the MIDI volume differences between the tracks be retained, or
2. should each track be individually normalized to 0 dbFS?

Thanks to the `GAIN FACTOR` tag, we can just go for 1) and then provide 2) via that tag on the same file.

1. Perform a ReplayGain scan in *album* mode across an entire soundtrack, and write the results to the .WAV files.

   In foobar2000: Context menu *→ ReplayGain → Scan as a single album → Update file tags*

2. Convert the soundtrack from 32-bit float .WAV to 16-bit FLAC while hard-applying ReplayGain in *album* mode with a limiting pre-amp and clipping prevention. These are the files we ship.

   In foobar2000: Context menu *→ Convert → … → Current settings → Processing → ReplayGain*

   * Source mode: *album*
   * Processing: *apply gain and prevent clipping according to peak*
   * Preamp / With RG info: *+6.0dB*

3. Determine the peak level of each converted track, for example using ffmpeg:

   ```shell
   $ ffmpeg -nostats -i input.flac -filter_complex astats=measure_perchannel=none:measure_overall=Min_level+Max_level -f null -
   ```

   This should yield at least one track that peaks at the maximum sample value for a 16-bit PCM file (-32768 / 32767).

4. Calculate the gain factor by dividing 32766 (minus 1 for a bit of headroom) by the larger level of every track, and write the result to the `GAIN FACTOR` tag.\
   This should *not* use the standard ReplayGain tags because it's a different measurement: We use all headroom of 16-bit PCM instead of conforming to ReplayGain's target loudness, and also express the result as a linear factor instead of in dB.

Now, the final FLAC files can be cut into loop files at the previously calculated loop start positions.
