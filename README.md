# fzfd

Fuzzy file finder written to test the D language.

## Opts

-d --depth denotes how many directories deep to go. default 0  
-p --path sets path to start the fuzzy find defaults to '.'  
--pattern to explicitly set the pattern but any args without a predicate will be treated as the pattern, first pattern found will be used

Pattern can be either regex pattern:

`fzf t.*st -d 1`  

or a string pattern that will match all files with those characters in that order:

`fzf tst -d 1`

will match e.g. test, toast, tempest or tst
