# exec_android_studio.sh - Launches Android Studio in the background and silences its output
# 
# The script searches your HOME directory for Android Studio installations using Jetbrains well-known
# naming scheme: android-studio



echo "Searching for Android Studio installtions in your home directory: ${HOME}"
# Search $HOME for any Android Studio installs, store in paths_temp tempfile
build_name_regex=android-studio
ints_dir_regex=.*/${build_name_regex}
find ~/ -regextype posix-extended -regex ${ints_dir_regex} -print0 > paths_temp

# Read tempfile contents into array, delete tempfile
paths=()
while ifs= read -r -d $'\0'; do
	paths+=("$REPLY")
done < paths_temp
rm -f paths_temp

# Number of paths found
inst_cnt=${#paths[@]}
# Exit with error msg if no paths found
if (("$inst_cnt" == 0)); then
	echo "No Android Studio installations were found."
	exit 1
fi

run_path=${paths[0]}/bin
$run_path/studio.sh > /dev/null 2>&1 &