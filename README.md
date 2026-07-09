# icanc

A tiny bash script that compiles every `.c` (or `.cpp`) file in a folder into
a single binary. Handy for small learning projects or quick experiments. 
You can extend supported types by providing type in list below and specifying compiler at the end of the file. 
Srcipt uses gcc and g++ compilers, which can be replaced manually.

## Usage

```bash
./icanc.sh -p=<path> [-f=<extension>] [-r]
```

| Flag | Description | Default |
|------|-------------|---------|
| `-p=<path>` | Folder to search for source files (required) | - |
| `-f=<extension>` | Extension to compile: `.c` or `.cpp` (can be extended manually) | `.c` |
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
