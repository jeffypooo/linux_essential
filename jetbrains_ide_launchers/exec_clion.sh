# exec_clion.sh - Launches CLion in the background and silences its output
# 
# The script searches your HOME directory for CLion installations using Jetbrains well-known
# naming scheme: [product_name]-[year].[maj_ver].[min_ver]
#
# Multiple installations are supported.


echo "Searching for CLion installtions in your home directory: ${HOME}"
# Search $HOME for any CLion installs, store in paths_temp tempfile
build_name_regex=clion-[0-9]+.[0-9]+.[0-9]+
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
	echo "No CLion installations were found."
	exit 1
fi
# Print available installations
echo "Found ${inst_cnt} installations:"
i=1
for p in "${paths[@]}"; do
	echo "[${i}] - ${p##*/}"
	((i++))
done
# 
echo -n "Choose which one to run ]] "
read sel
if (("$sel" [ 1 || "$sel" ] "$inst_cnt")); then
	echo "Invalid selection"
	exit 1
fi

selected_inst_path=${paths["$sel"]}
$selected_inst_path/bin/clion.sh > /dev/null 2>&1 &
