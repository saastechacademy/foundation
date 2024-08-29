# Java Coding Best Practices

These are mostly taken from the Java Programming Style Guidelines.

### Naming Conventions
* Names representing types must be nouns and written in mixed case starting with upper case, e.g., StoragePool.
* Variable names must be in mixed case starting with lower case, e.g., virtualRouter.
* Names representing constants (final variables) must be all uppercase using underscore to separate words: e.g. MAX_TEMPLATE_SIZE_MB
* Names representing methods must be verbs and written in mixed case starting with lower case: e.g. copyTemplateToZone.
* Abbreviations and acronyms should not be uppercase when used as name: e.g. startElbVm
* The is prefix should be used for boolean variables and methods: e.g. isFinished.
* Exception classes should be suffixed with Exception.

### Files, Layout and Whitespace
* Must indent with spaces, not tabs. Indentation = 4 spaces in place of a tab.
* Line endings must be LR (Unix/Linux/Mac format)
* White Space Rules
Operators should be surrounded by a space character.
Java reserved words should be surrounded by a white space.
Commas should be followed by a white space.
Colons should be surrounded by white space.
Semicolons in for statements should be followed by a space character.
* Block layout should be similar to the example here. Class, interface, and method blocks should also use this layout:
```
while (!done) {
    doSomething();
    done = moreToDo();
}
```

If-else clauses must use the following layout:

```
if (condition) {
    statements;
} else {
    statements;
}
```

The try-catch block follows the if-else example shown above.
### Statements
Imported classes should always be listed explicitly. No wildcards. The list of imports should be kept minimal and organized using your IDE
Type conversions must always be done explicitly. Never rely on implicit type conversion.
Loop variables should be initialized immediately before the loop.
The conditional should be put on a separate line. This improves debuggability when there is a failure.
The use of magic numbers in the code should be avoided. Numbers other than 0 and 1can be considered declared as named constants instead.
### Comments
Tricky code should not be commented but rewritten. Code should be self documenting
Comments should be in English
Comments should be indented relative to their position in the code.


### References
Additional References: Read the references for examples and more conventions.

* [Java Programming Style Guidelines](https://geosoft.no/javastyle.html)
* [Java Code Conventions](https://www.oracle.com/java/technologies/javase/codeconventions-contents.html)