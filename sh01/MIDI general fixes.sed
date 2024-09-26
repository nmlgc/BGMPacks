# Insert missing Roland vendor prefix bytes (0x41)
# (The existing checksums in the files are correct, and already assume this
# byte to be present.)
s/SysEx f0 10/SysEx f0 41 10/g
