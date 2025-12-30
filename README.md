# CHD to M3U Generator

![License](https://img.shields.io/badge/License-MIT-blue.svg)

A simple Bash script to create `.m3u` playlist files for CHD disc images. Groups multi-disc games into single M3U files and handles single-disc games automatically.

## Features

- ✅ Automatically detects multi-disc games (files containing `(Disc X)` pattern)
- ✅ Groups all discs of the same game into one `.m3u` file
- ✅ Creates individual `.m3u` files for single-disc games
- ✅ Removes old `.m3u` files before processing
- ✅ Provides statistics and progress feedback
- ✅ Works with case-insensitive disc patterns (`(Disc`, `(disc`, etc.)
- ✅ Handles complex filenames with additional info after disc number

## Installation

1. Clone or download the script:
```
git clone https://github.com/yourusername/chd-to-m3u.git
cd chd-to-m3u
```
2. Make the script executable:
```
chmod +x chd2m3u.sh
```
## Usage

Place the script in the same directory as your `.chd` files and run:
```
./chd2m3u.sh
```

### Example

**Before:**
```
Final Fantasy VII (Disc 1).chd
Final Fantasy VII (Disc 2).chd
Final Fantasy VII (Disc 3).chd
Chrono Trigger.chd
Resident Evil 2 (Disc A).chd
Resident Evil 2 (Disc B).chd
Metal Gear Solid.chd
```

**After:**
```
Final Fantasy VII.m3u # contains 3 lines
Chrono Trigger.m3u # contains 1 line
Resident Evil 2.m3u # contains 2 lines
Metal Gear Solid.m3u # contains 1 line
```


## Filename Patterns

The script recognizes these patterns:

### Multi-disc games:
- `Game Name (Disc 1).chd`
- `Game Name (Disc A).chd`
- `Game Name (Disc 2) (Extra Info).chd`
- `Game Name (disc 3).chd`

### Single-disc games:
- `Game Name.chd`
- `Game Name (Version).chd`

## How It Works

1. Removes all existing `.m3u` files in the current directory
2. Processes each `.chd` file:
   - **Multi-disc games**: Extracts the base name (everything before `(Disc`) and adds the file to `[base_name].m3u`
   - **Single-disc games**: Creates `[game_name].m3u` with just that file
3. Displays progress and statistics
4. Outputs a summary of created files

## Example Output
```
CHD to M3U Generator
====================
Removing all old m3u files...

Processing: Final Fantasy VII (Disc 1).chd
-> added to 'Final Fantasy VII.m3u'
Processing: Final Fantasy VII (Disc 2).chd
-> added to 'Final Fantasy VII.m3u'
Processing: Chrono Trigger.chd
-> created 'Chrono Trigger.m3u' (single disc)

Results:

📀📀 Final Fantasy VII.m3u (2 discs)
📀 Chrono Trigger.m3u (1 disc)

Statistics:
Total CHD files processed: 3
Total M3U files created: 2

Single-disc games: 1

Multi-disc games: 1

Done! All .m3u files created in current folder.
```


## Requirements

- Bash shell (tested on macOS, Linux, Windows WSL)
- No external dependencies required

## Notes

- The script only processes files in the **current directory** (not subdirectories)
- Filenames with special characters should work correctly
- The script is case-insensitive for `(Disc` pattern matching
- Empty `.m3u` files are reported but should not occur in normal operation

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Feel free to submit issues or pull requests for improvements.

---

**Tip**: Run the script whenever you add new CHD files to your collection to keep your M3U playlists up to date.
