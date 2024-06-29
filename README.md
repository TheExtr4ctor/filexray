# FileXray

FileXray is a Lua-based tool designed to analyze files for potential anomalies. It provides a simple command-line interface to examine files and detect unusual patterns, characters, or entropy levels that might indicate hidden or malicious content.

## Features

- ASCII art header for a visually appealing interface
- File existence verification
- Analysis of file content for:
  - Unusual characters (outside the printable ASCII range)
  - High entropy regions
  - Repeated patterns
- Contextual snippets around detected anomalies
- User-friendly command-line menu

## Requirements

- Lua 5.x (developed and tested with Lua 5.3)
- Input files for analysis

## Installation

1. Clone this repository.
2. Ensure Lua is installed on your system.

## Usage

1. Navigate to the FileXray directory
2. Run the script

3. Follow the on-screen prompts to analyze a file.

## How It Works

FileXray performs the following analyses:

1. **Unusual Character Detection**: Identifies bytes outside the standard printable ASCII range (32-126).
2. **Entropy Analysis**: Calculates the entropy of 256-byte windows throughout the file, flagging high-entropy regions that may indicate encryption or compression.
3. **Pattern Detection**: Searches for repeated patterns that could signify hidden data or file structures.

## Contributing

Contributions to FileXray are welcome! Please feel free to submit pull requests, report bugs, or suggest new features.

## Disclaimer

FileXray is a basic analysis tool and should not be solely relied upon for security purposes. Always use multiple tools and professional judgment when analyzing potentially malicious files.
