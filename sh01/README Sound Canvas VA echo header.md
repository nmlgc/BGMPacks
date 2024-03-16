
### About the no-echo and echo variants

ZUN shipped 34 of the 39 tracks across both of Shuusou Gyoku's soundtracks with invalid Reverb Macro SysEx messages, using IDs outside the SC-88Pro's specified [0, 7] range. A real-hardware SC-88Pro [clamps invalid messages to this range](https://twitter.com/Romantique_Tp/status/1766895996645056902) which results in a panning echo, whereas the SC-8850 and Sound Canvas VA ignore these messages and thus leave the reverb settings unchanged. This results in a significantly different overall sound on the latter synthesizers; see [issue #1](https://github.com/nmlgc/BGMPacks/issues/1) for details and [the corresponding ReC98 blog post](https://rec98.nmlgc.net/blog/2024-03-09) for audio samples.\
