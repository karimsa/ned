# ned - node editor

use javascript to manipulate stdin.

*Because sed is great but sometimes you just want some js*.

## Usage

To install, run `npm i -g nedjs`.

```
{{usage}}
```

## Examples

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