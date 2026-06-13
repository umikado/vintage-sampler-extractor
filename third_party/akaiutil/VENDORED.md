# Vendored: akaiutil

This directory contains an **unmodified** copy of `akaiutil`, the Akai
S900/S1000/S3000 filesystem reader that `vse` uses as its backend.

- **Upstream:** https://github.com/Midi-In/akaiutil
  (a fork of https://sourceforge.net/projects/akaiutil/)
- **Vendored commit:** `38fef03a12c2bdf870d286e0741a35ea923c0993`
- **Original author:** Klaus Michael Indlekofer
- **Fork additions** (stereo + looped sample support): "neoman"
- **License:** GPL-2.0 — see [`gpl-2.0.txt`](gpl-2.0.txt) and the headers in each source file.

It is included here (rather than fetched at runtime) so the tool is
self-contained and works offline. No source files have been changed; only build
artifacts (`*.o`, the compiled `akaiutil` binary) and the upstream `.git`
history are omitted. To update, re-copy the source from the upstream commit
above and update this note.
