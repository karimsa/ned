# ned - node editor

use javascript to manipulate stdin.

*Because sed is great but sometimes you just want some js*.

[![NPM](https://nodei.co/npm/nedjs.png?downloads=true&stars=true)](https://nodei.co/npm/nedjs/)

## Usage

To install, run `npm i -g nedjs`.

```
usage: ned [options] [function]
use javascript to manipulate stdin

  Types of manipulation:
    --filter, -f            Filter the input with [function]
    --reduce, -r [initial]  Reduce the input with [function]
    --sort, -s              Sort using [function] for comparisons
  
  Or leave out these flags to map over the input.
  
  General options:
    --trim, -t              Trim all data from stdin
    --single, -c            Replace all multiple spaces with a single space
    --delim, -d [delim]     Choose a delimeter to split by
    --join, -j [delim]      Choose a delimeter to join by (after processing)
    --numeric, -n           Treat all incoming data as numeric
    --version, -v           Output the version number
    --help, -h              Output help information

```

## Examples

### Simple: Say hi to everyone

```
$ cat test.txt
Bob
Joe
Anne
World
$ cat test.txt | ned 'name => "Hello, " + name'
Hello, Bob
Hello, Joe
Hello, Anne
Hello, World
```

### Replace a delimeter in stdin

```
$ echo '1,2,3' | ned -d , -j '\n' 'a=>a'
1
2
3
```

### Get sum of numbers

```
$ echo '1,2,3' | ned -d , -r 0 '(a,b)=>a+b'
6
```

### Remove non-numbers

```
$ echo '1,2,3,a,b,c' | ned -fnd , -j ',' 'a=>a'
1,2,3
```

## License

Licensed under [MIT license](LICENSE).

Copyright &copy; 2017 Karim Alibhai.