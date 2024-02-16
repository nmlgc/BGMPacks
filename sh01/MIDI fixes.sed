# Limit Sequence Names to the quoted name of the piece
s/(Meta SeqName \")\\x81y (.+) \\x81z.+(\")/\1\2\3/

# Insert missing Roland vendor prefix bytes (0x41)
# (The existing checksums in the files are correct, and already assume this
# byte to be present.)
s/SysEx f0 10/SysEx f0 41 10/g

# Move the first notes of ZUN's last released three arrangements to beat 2,
# matching the OST version
# -------------------------------------------------------------------------

# ssg_16.mid
s/^1635 Par/15 Par/
s/^3246 Par/66 Par/

# ssg_17.mid
s/^423 Par/243 Par/
s/^936 Par/156 Par/

# ssg_18.mid
s/^480 Meta/120 Meta/
s/^60 Meta Text/15 Meta Text/
s/^37 Par ch=4/7 Par ch=4/
s/^114 Par ch=12/4 Par ch=12/
s/^374 Par/4 Par/
# -------------------------------------------------------------------------
