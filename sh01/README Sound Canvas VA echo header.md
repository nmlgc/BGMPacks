
### About the no-echo and echo variants

ZUN shipped 34 of the 39 tracks across both of Shuusou Gyoku's soundtracks with invalid Reverb Macro SysEx messages, using IDs outside the SC-88Pro's specified [0, 7] range. A real-hardware SC-88Pro [clamps invalid messages to this range](https://twitter.com/Romantique_Tp/status/1766895996645056902) which results in a panning delay echo, whereas the SC-8850 and Sound Canvas VA ignore these messages and thus leave the reverb settings at their unchanged defaults. This results in a significantly different overall sound on the latter synthesizers for the 11 tracks in the OST and the 8 tracks in the AST that actually activate reverb; see [issue #1](https://github.com/nmlgc/BGMPacks/issues/1) for details and [the corresponding ReC98 blog post](https://rec98.nmlgc.net/blog/2024-03-09#sysex-2024-03-09) for audio samples.

In particular, the following tracks are affected:

|    # | Title                      | OST | AST |
| ---: | -------------------------- | --- | --- |
|  #01 | 秋霜玉　～ Clockworks      | 🔊   | 🔊   |
|  #02 | フォルスストロベリー       | 🔊   | 🔊   |
|  #03 | プリムローズシヴァ         | ✔️   | ✔️   |
|  #04 | 幻想帝都                   | 🔊   | 🔊   |
|  #05 | ディザストラスジェミニ     | 0️⃣   | 0️⃣   |
|  #06 | 華の幻想　紅夢の宙         | 🔊   | 0️⃣   |
|  #07 | 天空アーミー               | 🔊   | 🔊   |
|  #08 | スプートニク幻夜           | 0️⃣   | 0️⃣   |
|  #09 | 機械サーカス　～ Reverie   | 0️⃣   | 0️⃣   |
|  #10 | カナベラルの夢幻少女       | 0️⃣   | 0️⃣   |
|  #11 | 魔法少女十字軍             | 0️⃣   | 0️⃣   |
|  #12 | アンティークテラー         | 🔊   | 🔊   |
|  #13 | 夢機械　～ Innocent Power  | 🔊   | 🔊   |
|  #14 | 幻想科学 ～ Doll's Phantom | 🔊   | 🔊   |
|  #15 | 少女神性　～ Pandora's Box | 🔊   | 0️⃣   |
|  #16 | シルクロードアリス         | 0️⃣   | ✔️   |
|  #17 | 魔女達の舞踏会　/ ～ Magus | 0️⃣   | ✔️   |
|  #18 | 二色蓮花蝶　～ Ancients    | 0️⃣   | ✔️   |
|  #19 | ハーセルヴス               | 🔊   | 🔊   |
|  #20 | タイトルドメイド           | 🔊   | N/A |

* 🔊: MIDI file specifies invalid reverb macro, and has different no-echo and echo versions
* ✔️: MIDI file specifies valid reverb settings
* 0️⃣: MIDI file sets Reverb Level to 0, Reverb Macro makes no audible difference

