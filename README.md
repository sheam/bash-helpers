# Bash Helpers
- A set of scripts which make bash better to use
- Source init.sh from your ~/.bashrc

## Helpers
- create a .sh script in this directory, and then add the name of it to the `HELPERS` variable in init.sh
- if there are parts of the script that can only be run on linux
  then create a script ending with `.linux.sh`
- if there are parts of the script that can only be run on window
  then create a script ending with `.windows.sh`

## git
script to make bash prompt useful when working with git

## ssh.windows
- start ssh agent when first interactive bashs shell opens
- generally only needed on windows as KDE handles this

## bm
Bookmarks for directories when use the Bash CLI.
```
To set a bookmark, cd to the directory you want to bookmark and then:
    bm -s <NAME>
To delete a bookmark:
    bm -d <NAME>
To CD to a directory by bookmark name:
    bm <NAME>
To print a list of bookmarks:
    bm -l
```
