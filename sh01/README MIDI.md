
## MIDI edits

The MIDI files were slightly edited and bugfixed for in-game use:

* All Sequence Names were reduced to the name of the piece within the 【brackets】, removing the game, synth, and composer information that ZUN added at the end. This was necessary because Shuusou Gyoku reads the in-game track title from these Sequence Names.

* The missing Roland vendor ID prefix byte (`0x41`) was added to all SysEx setup messages in tracks #4 (幻想帝都), #5 (ディザストラスジェミニ), and #10 (カナベラルの夢幻少女). This fixes a clear bug in ZUN's MIDI files – the checksum bytes at the end of the respective messages already assume this vendor prefix byte to be present, and the SysEx messages are invalid without it.

* The setup measures of tracks #16 (シルクロードアリス), #17 (魔女達の舞踏会), and #18 (二色蓮花蝶　～ Ancients) were reduced to two beats to match their counterparts in the original soundtrack. This was particularly necessary for #16, whose three setup measures in ZUN's `ssg_16.mid` delay the first note to measure 4, or 5 seconds after playback started.

The current version of this BGM pack doesn't include ZUN's comments from the .TXT files in the .LZH archives, as Shuusou Gyoku's BGM pack implementation did not support custom Music Room comments at the time of this release. This feature is tracked in [Shuusou Gyoku issue #56](https://github.com/nmlgc/ssg/issues/56), and can be commissioned through the [ReC98 storefront](https://rec98.nmlgc.net).
