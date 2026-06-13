# vintage-sampler-extractor (`vse`)

Extract audio from **Akai S900 / S1000 / S3000 sampler CD-ROM images** to WAV on
modern macOS and Linux — and automatically rejoin the Akai format's split
**`-L` / `-R` mono files into proper stereo**.

These classic 1990s sample-CD images are usually distributed as `.iso` files,
but they are **not** ISO9660. They use Akai's own sampler partition format, so
macOS Disk Utility, `hdiutil`, and archive tools like The Unarchiver simply
fail to open them. `vse` reads that format directly and gives you ordinary WAV
files, organised by the disc's original partition/volume/bank structure.

```
$ vse all "Distorted Reality 2 [Disc 1].iso" ./out
>> reading '...' (read-only) and converting samples to WAV ...
>> done: 904 WAV files under .../out
>> rejoining -L/-R stereo pairs ...
stereo merged : 440
left as mono  : 0
failed        : 0
```

## Why this exists

On an Akai sampler disk a **stereo sample is physically stored as two separate
mono files** named `NAME-L` and `NAME-R`, linked by a "stereo partner" pointer
in the sample header; the sampler recombines them at playback. A plain dump
therefore gives you two mono WAVs per stereo sound. `vse stereo` detects those
pairs and interleaves them back into one stereo WAV (`-L` → left, `-R` → right),
sample-accurately, then removes the mono pair (only after verifying the result
is genuinely 2-channel).

## Requirements

| Tool | For | Install |
|------|-----|---------|
| C compiler + `make` | building the backend | macOS: `xcode-select --install` · Debian/Ubuntu: `sudo apt install build-essential` |
| `ffmpeg` (incl. `ffprobe`) | stereo rejoin | macOS: `brew install ffmpeg` · Debian/Ubuntu: `sudo apt install ffmpeg` |
| `tar`, `git`, `bash` | extraction / setup | preinstalled on macOS & Linux |

Tested on macOS (Apple Silicon). The akaiutil backend is vendored in this repo
(`third_party/akaiutil`), so no network is needed after cloning.

## Install

```bash
git clone https://github.com/umikado/vintage-sampler-extractor.git
cd vintage-sampler-extractor
./vse build          # compiles the akaiutil backend (once)
```

Optionally put it on your `PATH`:

```bash
ln -s "$PWD/vse" /usr/local/bin/vse
```

## Usage

```bash
vse build                                # compile the backend (run once)
vse list    <image>                      # read-only: list partitions/volumes/files
vse extract <image> <outdir>             # extract all samples -> mono WAV
vse stereo  <dir> [--dry-run] [--keep]   # rejoin -L/-R pairs -> stereo
vse all     <image> <outdir>             # extract + stereo merge (the common path)
```

Examples:

```bash
# Inspect a disc without extracting anything (read-only):
vse list "Zero-G Datafile (AKAI S1000,S1100).iso"

# Extract to mono WAVs, keeping the disc's bank structure:
vse extract "AMG Gota Yashiki AKAI.iso" ./gota-yashiki

# Rejoin stereo pairs in an already-extracted folder:
vse stereo ./gota-yashiki              # add --dry-run to preview, --keep to retain -L/-R

# Do it all in one shot:
vse all "Distorted Reality 2 [Disc 1].iso" ./dr2-disc1
```

## Safety

- **Images are always opened read-only** (`akaiutil -r`); `vse` never writes to
  your `.iso` files.
- `vse stereo` writes the merged file and **verifies it is 2-channel before
  deleting** the `-L`/`-R` originals. On any failure the originals are kept.
- True mono samples (no `-L`/`-R` partner) are never modified.
- Extraction re-applies search permissions to directories, working around a
  quirk where akaiutil writes directories as mode `0600` (which otherwise makes
  the folders look "permission denied" in Finder).

## How it works

1. **Read** — `akaiutil` walks the Akai disk image (`/disk0` → partitions
   `A`, `B`, … → volumes → sample files) and exports each sample as a mono WAV
   via its `tarcwav` command, preserving the original names.
2. **Rejoin** — `vse` pairs every `*-L.wav` with its `*-R.wav` sibling and uses
   `ffmpeg` (`join=inputs=2:channel_layout=stereo`) to interleave them into a
   16-bit PCM stereo WAV named after the base sample.

## Credits

- **[akaiutil](https://sourceforge.net/projects/akaiutil/)** — the Akai
  filesystem reader that does the heavy lifting — © Klaus Michael Indlekofer,
  licensed GPL-2.0. Stereo/looped-sample improvements by "neoman"
  ([Midi-In/akaiutil fork](https://github.com/Midi-In/akaiutil)). Vendored
  unmodified under [`third_party/akaiutil`](third_party/akaiutil) — see
  [`third_party/akaiutil/README.md`](third_party/akaiutil/README.md).
- **[ffmpeg](https://ffmpeg.org/)** — stereo interleaving and validation.

## License

GPL-2.0-or-later. See [LICENSE](LICENSE). This project bundles akaiutil, which
is GPL-2.0; distributing `vse` under the GNU GPL keeps the whole work
license-consistent.
