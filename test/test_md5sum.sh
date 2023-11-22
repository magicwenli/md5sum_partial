#!/bin/bash
# set -x
script_dir=$(dirname "$0")
my_bin="$script_dir/../md5sum_partial"

# Function to compare MD5 sum
compare_md5sum() {
  local test_name="$1"
  local input_file="$2"
  local expected_md5sum="$3"
  local actual_md5sum="$4"

  if [[ "$actual_md5sum" == "$expected_md5sum" ]]; then
    echo -e "Test case passed: \033[0;32m[$test_name]     $input_file\033[0m"
    echo "Result md5sum:               $expected_md5sum"
  else
    echo -e "Test case failed: \033[0;33m[$test_name]     $input_file\033[0m"
    echo "Expected MD5 sum:            $expected_md5sum"
    echo "Actual MD5 sum:              $actual_md5sum"
  fi
}

# Test case 1: Compare md5sum output with txt file
input="$script_dir/test.txt"
expect=$(md5sum "$input" | awk '{print $1}')
actual=$(./$my_bin "$input" | awk '{print $1}')
compare_md5sum "test_tty_full" "$input" "$expect" "$actual"

# Test case 2: Compare md5sum output with bin file
input="$script_dir/test.bin"
expect=$(md5sum "$input" | awk '{print $1}')
actual=$(./$my_bin "$input" | awk '{print $1}')
compare_md5sum "test_binary_full" "$input" "$expect" "$actual"

# Test case 3: Compare md5sum output with partial bin file
input="$script_dir/test.bin"
size=500
expect=$(dd if=$input bs=$size count=1 2> /dev/null | md5sum | awk '{print $1}')
actual=$(./$my_bin -l $size "$input" | awk '{print $1}')
compare_md5sum "test_binary_partial" "$input" "$expect" "$actual"

# Test case 4: Compare md5sum output with partial bin file again
input="$script_dir/test.bin"
size=768
expect=$(dd if=$input bs=$size count=1 2> /dev/null | md5sum | awk '{print $1}')
actual=$(./$my_bin -l $size "$input" | awk '{print $1}')
compare_md5sum "test_binary_partial 2" "$input" "$expect" "$actual"

# Test case 5: Compare md5sum output with /dev/mem
input="/dev/mem"
size=768
expect=$(sudo dd if=$input bs=$size count=1 2> /dev/null | md5sum | awk '{print $1}')
actual=$(sudo ./$my_bin -l $size "$input" | awk '{print $1}')
compare_md5sum "test_device_partial" "$input" "$expect" "$actual"