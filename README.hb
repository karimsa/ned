# ned - node editor

use javascript to manipulate stdin.

*Because sed is great but sometimes you just want some js*.

[![NPM](https://nodei.co/npm/nedjs.png?downloads=true&stars=true)](https://nodei.co/npm/nedjs/)

## Usage

To install, run `npm i -g nedjs`.

```
{{usage}}
```

## Examples

### Say hi to everyone

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

### Find the number of lines in a file

```
$ cat -n myfile.txt | ned -tr 0 '(a,b)=>Math.max(a,b.split(/\s/)[0])'
166
```

**OR**:

```
$ cat -n myfile.txt | ned -tfn 'a=>a' -j '\n' | ned -r 0 '(a,b)=>Math.max(a,b)'
166
```

## License

Licensed under [MIT license](LICENSE).

Copyright &copy; 2017 Karim Alibhai.