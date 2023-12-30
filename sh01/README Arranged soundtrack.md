
Recordings of Shuusou Gyoku's arranged MIDI soundtrack, as released in 2001 on [東方幻想的音楽, ZUN's old MIDI page](https://www16.big.or.jp/~zun/html/music_old.html), looped for in-game playback.\
The loop points were algorithmically detected using [mly](https://github.com/nmlgc/mly), using the following command lines:

| File            | Command line                                                                 |
| --------------- | ---------------------------------------------------------------------------- |
| ssg_02.mid      | `mly cut 466: \| mly loop-unfold 240: \| mly -r 44100 loop-find`             |
| ssg_04.mid      | `mly smf0 \| mly -r 44100 loop-find`                                         |
| ssg_05.mid      | `mly smf0 \| mly cut 386: \| mly loop-unfold 226: \| mly -r 44100 loop-find` |
| ssg_06.mid      | `mly cut 494: \| mly loop-unfold 270: \| mly -r 44100 loop-find`             |
| ssg_10.mid      | `mly smf0 \| mly -r 44100 loop-find`                                         |
| ssg_12.mid      | `mly cut 602: \| mly loop-unfold 312: \| mly -r 44100 loop-find`             |
| ssg_14.mid      | `mly cut 550: \| mly loop-unfold 322: \| mly -r 44100 loop-find`             |
| ssg_15.mid      | `mly cut 522: \| mly loop-unfold 328: \| mly -r 44100 loop-find`             |
| ssg_16.mid      | `mly cut 624: \| mly loop-unfold 344: \| mly -r 44100 loop-find`             |
| Everything else | `mly -r 44100 loop-find`                                                     |

Since ZUN did not arrange track #20 (タイトルドメイド), the corresponding files in this BGM pack are taken from the respective recording of the original soundtrack.
