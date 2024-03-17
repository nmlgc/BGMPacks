# Clamp invalid Reverb Macros to 7 (Panning Delay), ensuring the behavior of
# real hardware on other Roland synths:
#
# 	https://twitter.com/Romantique_Tp/status/1766895996645056902
#
s/f0 41 10 42 12 40 01 30 14 7b f7/f0 41 10 42 12 40 01 30 07 08 f7/g
s/f0 41 10 42 12 40 01 30 0b 04 f7/f0 41 10 42 12 40 01 30 07 08 f7/g
