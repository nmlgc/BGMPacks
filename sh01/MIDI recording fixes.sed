# Delay the end-of-track event to not prematurely cut off the fade-outs of
# non-looping tracks
s/0 Meta TrkEnd/10000 Meta TrkEnd/

# For some reason, the combination of foobar2000's converter and foo_midi
# requires that we take ssg_17.mid (arranged 魔女達の舞踏会) and manually set
# its Bank Select LSB controller (#32) to 3 for SCVA to select the correct
# SC-88Pro Standard 1 drum kit. No other MIDI player or converter I've tried
# had that issue…
s/^2 Par ch=10 c=32 v=0/2 Par ch=10 c=32 v=3/

# Shorten the setup area length of ZUN's last released three arrangements (and
# worst clipping offenders) to a length that results in Sound Canvas VA
# rendering them with as little clipping as possible
# ---------------------------------------------------------------------------

# ssg_16.mid
s/^1635 Par/15 Par/
s/^3246 Par/1956 Par/

# ssg_17.mid
s/^423 Par/393 Par/

# ssg_18.mid
s/^480 Meta/150 Meta/
# ---------------------------------------------------------------------------
