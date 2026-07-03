#!/bin/bash
#
# icanc compiles all C/C++ files in a folder into a single binary.
#
# Usage:
#   icanc.sh -p=<path> [-f=<extension>] [-r]
#
# Options:
#   -p=<path>        Folder to search for source files (required)
#   -f=<extension>   File extension to compile, e.g. .c or .cpp (default: .c)
#   -r               Run the resulting binary after a successful build
#   -h, --help       Show this help message
#
# Example:
#   ./icanc.sh -p=./my_project_folder -f=.cpp -r

print_help() {
	cat <<EOF
icanc compiles all C/C++ files in a folder into a single binary

Usage:
  $(basename "$0") -p=<path> [-f=<extension>] [-r]

Options:
  -p=<path>        Folder to search for source files (required)
  -f=<extension>   File extension to compile, e.g. .c or .cpp (default: .c)
  -r               Run the resulting binary after a successful build
  -h, --help       Show this help message

Example:
  $(basename "$0") -p=./my_project -f=.cpp -r
EOF
}

if [ $# -eq 0 ]; then
	echo "Executing folder was not specified. Use -f=folder_name";
	exit 1;
fi;

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
	print_help;
	exit 0;
fi;

if [[ "$1" != -p=* ]]; then
	echo "-p=path expected as a first argument";
	print_help;
	exit 2;
fi;

RUN_AT_THE_END_FLAG=0;
FOLDER="";
FORMAT=".c";

for arg in "$@"; do
	case $arg in
		-p=*)
			FOLDER=$(echo "${arg}" | sed 's/^-p=//');
			;;
		-f=*)
			FORMAT=$(echo "${arg}" | sed 's/^-f=//');
			;;
		-r)
			RUN_AT_THE_END_FLAG=1;
			;;
		-h|--help)
			print_help;
			exit 0;
			;;
		*)
			echo "Cannot recognize ${arg} parameter";
			exit 3;
			;;
	esac;
done;

FOLDER="${FOLDER%/}";

if [ ! -d "$FOLDER" ]; then
	echo "Folder '${FOLDER}' does not exist";
	exit 5;
fi;

printf "\n#####################"
printf "\n%s provided as path\n%s provided as type\n" "$FOLDER" "$FORMAT";
printf "#####################\n"

FILES_TO_RUN=();
while read -r filepath; do
	FILES_TO_RUN+=("$filepath");
done < <(find "$FOLDER" -type f -name "*${FORMAT}"); # to provide format

if [ ${#FILES_TO_RUN[@]} -eq 0 ]; then
	echo "No files with provided format (${FORMAT}) were found";
	exit 4;
fi

printf "\n#####################"
printf "\nFollowing files are going to be compiled: \n";
for element in "${FILES_TO_RUN[@]}"; do
	printf "%s\n" "$element";
done;
printf "#####################\n"

if [ ! -d "$FOLDER/output" ]; then
	mkdir "$FOLDER/output";
fi

COMPILED_PROGRAM="$FOLDER/output/program";

if [ "${FORMAT}" == ".c" ]; then
	gcc "${FILES_TO_RUN[@]}" -o "$COMPILED_PROGRAM";
elif [ "$FORMAT" == ".cpp" ]; then
	g++ "${FILES_TO_RUN[@]}" -o "$COMPILED_PROGRAM";
else
	echo "Unsupported format: ${FORMAT} (only .c and .cpp are supported)";
	exit 6;
fi

BUILD_STATUS=$?;
if [ $BUILD_STATUS -ne 0 ]; then
	echo "Build failed";
	exit $BUILD_STATUS;
fi

#Windows and git bash appends .exe automatically, otherwise it will be appended here:
if [ -f "${COMPILED_PROGRAM}.exe" ]; then
	COMPILED_PROGRAM="${COMPILED_PROGRAM}.exe";
fi

printf "\n#####################";
printf '\nSuccessfully compiled and stored at %s' "${COMPILED_PROGRAM}";
printf "\n#####################\n";

if [ $RUN_AT_THE_END_FLAG -eq 1 ]; then
	printf "\n#####################";
	printf '\nStarting program at %s' "${COMPILED_PROGRAM}";
	printf "\n#####################\n\n";
	"$COMPILED_PROGRAM";
fi

