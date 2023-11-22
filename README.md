# md5_partial

md5_partial is a C program that calculates the MD5 hash of a binary file up to a **user-specified length**. This is particularly useful when you only need to hash a portion of a file, which can save time and resources when dealing with large files.

## Usage

The usage of `md5_partial` is similar to the `md5sum` command in BusyBox, with the addition of the `--length` option.

Example

```bash
./md5sum_partial -l 123 ./test/test.bin | awk '{print $1}'
# which should be equal to
dd if=./test/test.bin bs=1 count=123 2> /dev/null | md5sum | awk '{print $1}'
```

## Build and Test

```bash
make
make tests
```
See `test/test_md5sum.sh`

## Benchmark

My cracky benchmark command:

```bash
sudo hyperfine --runs 10 \
  "./md5sum_partial -l 102400 /dev/mem | awk '{print $1}'" \
  "dd if=/dev/mem bs=1 count=102400 2> /dev/null | md5sum | awk '{print $1}'"
```

### Result

`md5sum_partial` is really fast.

```
Benchmark 1: ./md5sum_partial -l 102400 /dev/mem | awk '{print }'
  Time (mean ± σ):       2.6 ms ±   2.3 ms    [User: 3.3 ms, System: 1.0 ms]
  Range (min … max):     1.2 ms …   8.8 ms    10 runs
 
  Warning: Command took less than 5 ms to complete. Results might be inaccurate.
 
Benchmark 2: dd if=/dev/mem bs=1 count=102400 2> /dev/null | md5sum | awk '{print }'
  Time (mean ± σ):     227.8 ms ±  22.4 ms    [User: 33.8 ms, System: 265.3 ms]
  Range (min … max):   201.7 ms … 275.9 ms    10 runs
 
Summary
  './md5sum_partial -l 102400 /dev/mem | awk '{print }'' ran
   86.26 ± 74.29 times faster than 'dd if=/dev/mem bs=1 count=102400 2> /dev/null | md5sum | awk '{print }''
```

## Note
This program uses the MD5 algorithm, which is widely used but not considered secure for all purposes. Please ensure it is appropriate for your use case.