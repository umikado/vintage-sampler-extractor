# vintage-samplerCD-extractor (`vse`)

[![shellcheck](https://github.com/umikado/vintage-samplerCD-extractor/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/umikado/vintage-samplerCD-extractor/actions/workflows/shellcheck.yml)
[![license: GPL-2.0](https://img.shields.io/badge/license-GPL--2.0-blue.svg)](LICENSE)
![platform: macOS | Linux](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)

Extract audio from **Akai S900 / S1000 / S3000 sampler CD-ROM images** to WAV on
modern macOS and Linux — and automatically rejoin the Akai format's split
**`-L` / `-R` mono files into proper stereo**.

These classic 1990s sample-CD images are usually distributed as `.iso` files,
but they are **not** ISO9660. They use Akai's own sampler partition format, so
macOS Disk Utility, `hdiutil`, and archive tools like The Unarchiver simply
fail to open them. `vse` reads that format directly and gives you ordinary WAV
files, organised by the disc's original partition/volume/bank structure. It takes
flat dumps (`.iso`/`.img`) as well as raw `.bin` CD rips (2352-byte sectors), which
it de-interleaves to flat data automatically.

```
$ vse all "Distorted Reality 2 [Disc 1].iso" ./out
>> reading '...' (read-only) and converting samples to WAV ...
>> done: 904 WAV files under .../out
>> rejoining -L/-R stereo pairs ...
stereo merged : 440
left as mono  : 0
failed        : 0
```

## Download — macOS app (Apple Silicon)

Prefer a GUI to the command line? A drag-and-drop macOS app is on the
[**Releases**](https://github.com/umikado/vintage-samplerCD-extractor/releases/latest)
page (`Vintage-SampleCD-Extractor-…-macOS-arm64.zip`). Drop in your `.iso`/`.img`
files, choose mono or stereo, and it extracts — `akaiutil` is bundled and stereo
merging is built in, so **no `ffmpeg` or other setup is required**.

> **Apple Silicon only** (arm64), macOS 13+.
>
> The app is **not notarized** (this is a free project without a paid Apple
> Developer ID), so on first launch macOS Gatekeeper will warn that it "cannot be
> checked for malicious software." To open it, either:
> - **right-click the app → Open → Open**, or
> - clear the quarantine flag after moving it to `/Applications`:
>   ```bash
>   xattr -dr com.apple.quarantine "/Applications/Vintage SampleCD Extractor.app"
>   ```
>
> The app's full source is in [`macos-app/`](macos-app) — build it yourself
> (`macos-app/Scripts/package-app.sh`) to avoid the Gatekeeper prompt entirely.

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
git clone https://github.com/umikado/vintage-samplerCD-extractor.git
cd vintage-samplerCD-extractor
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

## Example output

Inspect a disc without extracting (read-only):

```text
$ vse list "AMG Gota Yashiki AKAI.iso"
disk  type parts  blksize tot/blks  tot/MB  free/blks free/MB free/%
   0    HD     5   0x2000   0x804b   256.6     0x1de6    59.8   23.3
part  type startblk size/blks  size/MB  free/blks free/MB free/%
   A    HD   0x0000    0x1e00     60.0     0x0334     6.4   10.7
   B    HD   0x1e00    0x1e00     60.0     0x0177     2.9    4.9
   ...
```

Extract everything and rejoin stereo in one shot:

```text
$ vse all "Distorted Reality 2 [Disc 1].iso" ./dr2-disc1
>> reading '...' (read-only) and converting samples to WAV ...
>> unpacking into: .../dr2-disc1
>> done: 904 WAV files under .../dr2-disc1
>> rejoining -L/-R stereo pairs ...
------------------------------------------------------------
stereo merged : 440
left as mono  : 0   (no -L/-R partner)
failed        : 0
```

The disc's original partition / volume / bank layout is preserved, with the
`-L`/`-R` pairs rejoined into single stereo files:

```text
dr2-disc1/
├── A/01 50-69 BPM/ ...
├── B/04 140-159/DRMZ N OH.wav      # stereo  (was "DRMZ N OH -L/-R")
└── I/03 FORCE HIT/BETRAYAL.wav     # stereo
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
