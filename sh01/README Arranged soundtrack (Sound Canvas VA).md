
#### MIDI preparations

The MIDI files of the arranged soundtrack require further pre-processing to improve rendering quality within the workflow described below. You can find the respective patches at [`sh01/MIDI recording fixes.sed`](https://github.com/nmlgc/BGMPacks/blob/main/sh01/MIDI%20recording%20fixes.sed) in the repo.

Most notably, the setup area of the three Extra Stage themes can benefit from shortening their MIDI setup area to a length that results in Sound Canvas VA rendering them with as little clipping as possible.\
ZUN shifted his sequencing style for these final tracks of his Shuusou Gyoku arrangement project, introducing

* shrill resonant effects that cause significant clipping, and
* a much longer setup area compared to their OST counterparts, used for setting up these effects.

We want to shorten the setup area to match the OST, but this happens to cause Sound Canvas VA to render all three of these tracks with a slightly higher peak amplitude compared to rendering the original files. As by far the loudest track in the AST, track #16 (シルクロードアリス) controls the peak volume that every other track gets normalized to, so we ideally want to reduce its volume as much as possible.\
By trying all setup area lengths at a fixed step size within the interval between the in-game target and ZUN's original files, we can find a better solution:

| Setup PPQN length / SCVA peak | shipped by ZUN  | in-game target | worst           | best            |
| ----------------------------- | --------------- | -------------- | --------------- | --------------- |
| #16 シルクロードアリス        | 5760 / 2.031896 | 960 / 2.130164 | 4140 / 2.355454 | 2850 / 1.899765 |
| #17 魔女達の舞踏会            | 1920 / 1.290760 | 960 / 1.304532 | 1500 / 1.435035 | 1890 / 1.277443 |
| #18 二色蓮花蝶　～ Ancients   | 1920 / 1.351405 | 960 / 1.424081 | 1440 / 1.491013 | 1590 / 1.305400 |

The extra leading silence then has to be manually cut at the end of the process.

You can find the full dataset of attempted trials at [`Setup area trials for the arranged soundtrack.tsv`](https://github.com/nmlgc/BGMPacks/blob/main/sh01/Setup%20area%20trials%20for%20the%20arranged%20soundtrack.tsv) in the repo, or at

> <https://docs.google.com/spreadsheets/d/1j8wy9SLrjCiD9C3SXRU9dr7p22k0S6cg1hhHUAQ8TYA/edit?usp=sharing>

The values were determined based on unlooped files truncated to the rough length of the loop. The final loop-cut MIDI files turn out to be slightly louder, but not significantly enough to bother.
