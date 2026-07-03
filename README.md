# icanc

A tiny bash script that compiles every `.c` (or `.cpp`) file in a folder into
a single binary, no Makefile or CMake required. Handy for small learning
projects or quick experiments.

## Usage

```bash
./icanc.sh -p=<path> [-f=<extension>] [-r]
```

| Flag | Description | Default |
|------|-------------|---------|
| `-p=<path>` | Folder to search for source files (required) | - |
| `-f=<extension>` | Extension to compile: `.c` or `.cpp` | `.c` |
| `-r` | Run the resulting binary after a successful build | off |
| `-h`, `--help` | Show help | - |

## Examples

```bash
./icanc.sh -p=./my_project
./icanc.sh -p=./my_project -f=.cpp -r
```

## Requirements

- `bash`
- `gcc` / `g++` on your `PATH`

Works on Linux, WSL, and Windows via Git Bash / MSYS2.

## License

MIT - do whatever you want with it
