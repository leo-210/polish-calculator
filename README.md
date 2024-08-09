# Reverse polish notation calculator

A [reverse polish notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation)
calculator made with gleam !

The program pushes the last result to the stack, so you can easily use it, while 
still enabling you to do different calculations. For example :
```
> 3 4 +
7
> 3 +
10
> 3 4 +
7
```
The second input line is actually equivalent to `7 3 +`. The third one is equivalent
to `10 3 4 +`, and in these cases the program will ignore the first number instead 
of returning an error.

The 4 principal operation are supported (i.e. addition, substraction, multiplication 
and division), and only integers are valid. All other characters are treated as whitespace.

So this is valid syntax :
```
> h3ll0 w0rld++
3
```

## Running the program

You have to [install gleam](https://gleam.run/getting-started/installing/), 
clone the project, then run :
```
gleam run
```
