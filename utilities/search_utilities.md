# Unix Search Commands & VS Code Navigation Guide

## Table of Contents

1. [grep - Text Search](#grep---text-search)
2. [find - File Search](#find---file-search)
3. [locate - Fast File Search](#locate---fast-file-search)
4. [which - Find Command Location](#which---find-command-location)
5. [whereis - Locate Binary, Source, Manual](#whereis---locate-binary-source-manual)
6. [ack/ag - Advanced Text Search](#ackag---advanced-text-search)
7. [ripgrep (rg) - Fast Text Search](#ripgrep-rg---fast-text-search)
8. [VS Code Navigation Shortcuts](#vs-code-navigation-shortcuts)

---

## grep - Text Search

`grep` (Global Regular Expression Print) searches for patterns in files.

### Basic Syntax

```bash
grep [options] pattern [file...]
```

### Common Flags

| Flag            | Description                            | Example                                           |
| --------------- | -------------------------------------- | ------------------------------------------------- | ----------------- |
| `-i`            | Case-insensitive search                | `grep -i "error" log.txt`                         |
| `-r` or `-R`    | Recursive search in directories        | `grep -r "function" src/`                         |
| `-n`            | Show line numbers                      | `grep -n "TODO" file.rb`                          |
| `-v`            | Invert match (show non-matching lines) | `grep -v "debug" log.txt`                         |
| `-l`            | Show only filenames with matches       | `grep -l "error" *.log`                           |
| `-L`            | Show only filenames without matches    | `grep -L "error" *.log`                           |
| `-c`            | Count matching lines                   | `grep -c "warning" log.txt`                       |
| `-h`            | Suppress filename prefix               | `grep -h "pattern" file1 file2`                   |
| `-H`            | Always show filename prefix            | `grep -H "pattern" file1`                         |
| `-w`            | Match whole words only                 | `grep -w "class" *.rb`                            |
| `-x`            | Match whole lines only                 | `grep -x "exact_line" file.txt`                   |
| `-A n`          | Show n lines after match               | `grep -A 3 "error" log.txt`                       |
| `-B n`          | Show n lines before match              | `grep -B 3 "error" log.txt`                       |
| `-C n`          | Show n lines before and after          | `grep -C 3 "error" log.txt`                       |
| `-E`            | Extended regex (or use `egrep`)        | `grep -E "error                                   | warning" log.txt` |
| `-F`            | Fixed string (no regex)                | `grep -F "*.rb" file.txt`                         |
| `--color`       | Highlight matches                      | `grep --color "pattern" file.txt`                 |
| `-m n`          | Stop after n matches                   | `grep -m 5 "error" log.txt`                       |
| `-q`            | Quiet mode (no output, exit code only) | `grep -q "pattern" file.txt`                      |
| `-s`            | Suppress error messages                | `grep -s "pattern" file.txt`                      |
| `-f file`       | Read patterns from file                | `grep -f patterns.txt file.txt`                   |
| `--include`     | Include only matching files            | `grep -r --include="*.rb" "class" .`              |
| `--exclude`     | Exclude matching files                 | `grep -r --exclude="*.log" "error" .`             |
| `--exclude-dir` | Exclude directories                    | `grep -r --exclude-dir="node_modules" "import" .` |

### Practical Examples

#### 1. Search in a single file

```bash
grep "function" script.js
```

#### 2. Case-insensitive search

```bash
grep -i "error" application.log
```

#### 3. Recursive search with line numbers

```bash
grep -rn "TODO" src/
```

#### 4. Find files containing a pattern

```bash
grep -l "deprecated" *.rb
```

#### 5. Count occurrences

```bash
grep -c "warning" log.txt
```

#### 6. Show context (lines before/after)

```bash
grep -C 5 "exception" error.log
```

#### 7. Search multiple patterns

```bash
grep -E "error|warning|critical" log.txt
```

#### 8. Search whole words only

```bash
grep -w "class" *.rb
```

#### 9. Exclude certain files/directories

```bash
grep -r --exclude="*.log" --exclude-dir="node_modules" "import" .
```

#### 10. Search in specific file types only

```bash
grep -r --include="*.{rb,js}" "function" .
```

#### 11. Invert match (find lines NOT containing pattern)

```bash
grep -v "debug" log.txt
```

#### 12. Search with regex

```bash
grep -E "^[0-9]{3}-[0-9]{3}-[0-9]{4}$" contacts.txt
```

#### 13. Pipe with other commands

```bash
ps aux | grep "python"
ls -la | grep "\.rb$"
```

#### 14. Search in compressed files

```bash
zgrep "error" log.txt.gz
```

---

## find - File Search

`find` searches for files and directories based on various criteria.

### Basic Syntax

```bash
find [path...] [expression]
```

### Common Options

| Option        | Description                       | Example                               |
| ------------- | --------------------------------- | ------------------------------------- |
| `-name`       | Match filename (case-sensitive)   | `find . -name "*.rb"`                 |
| `-iname`      | Match filename (case-insensitive) | `find . -iname "*.rb"`                |
| `-type f`     | Find files only                   | `find . -type f`                      |
| `-type d`     | Find directories only             | `find . -type d`                      |
| `-type l`     | Find symbolic links               | `find . -type l`                      |
| `-size`       | Find by size                      | `find . -size +100M`                  |
| `-mtime`      | Modified time (days)              | `find . -mtime -7`                    |
| `-atime`      | Accessed time (days)              | `find . -atime +30`                   |
| `-ctime`      | Changed time (days)               | `find . -ctime -1`                    |
| `-mmin`       | Modified time (minutes)           | `find . -mmin -60`                    |
| `-user`       | Find files owned by user          | `find . -user ravi`                   |
| `-group`      | Find files owned by group         | `find . -group staff`                 |
| `-perm`       | Find by permissions               | `find . -perm 644`                    |
| `-maxdepth n` | Limit search depth                | `find . -maxdepth 2 -name "*.rb"`     |
| `-mindepth n` | Minimum depth                     | `find . -mindepth 2 -name "*.rb"`     |
| `-empty`      | Find empty files/dirs             | `find . -empty`                       |
| `-exec`       | Execute command on results        | `find . -name "*.tmp" -exec rm {} \;` |
| `-delete`     | Delete matching files             | `find . -name "*.tmp" -delete`        |
| `-print`      | Print results (default)           | `find . -print`                       |
| `-print0`     | Print with null separator         | `find . -print0`                      |
| `-ls`         | List in long format               | `find . -name "*.rb" -ls`             |
| `-prune`      | Don't descend into directory      | `find . -name "node_modules" -prune`  |
| `-o`          | OR operator                       | `find . -name "*.rb" -o -name "*.js"` |
| `-a`          | AND operator (default)            | `find . -name "*.rb" -a -type f`      |
| `-not` or `!` | NOT operator                      | `find . -not -name "*.log"`           |

### Size Modifiers

- `c` - bytes
- `k` - kilobytes
- `M` - megabytes
- `G` - gigabytes
- `+` - greater than
- `-` - less than
- (no prefix) - exactly

### Time Modifiers

- `+n` - more than n days/minutes ago
- `-n` - less than n days/minutes ago
- `n` - exactly n days/minutes ago

### Practical Examples

#### 1. Find files by name

```bash
find . -name "*.rb"
find /home -name "config.txt"
```

#### 2. Case-insensitive name search

```bash
find . -iname "*.RB"
```

#### 3. Find files modified in last 7 days

```bash
find . -type f -mtime -7
```

#### 4. Find files larger than 100MB

```bash
find . -type f -size +100M
```

#### 5. Find empty files

```bash
find . -type f -empty
```

#### 6. Find and delete temporary files

```bash
find . -name "*.tmp" -delete
find . -name "*.log" -mtime +30 -delete
```

#### 7. Find and execute command

```bash
find . -name "*.rb" -exec chmod 644 {} \;
find . -name "*.txt" -exec grep -l "pattern" {} \;
```

#### 8. Limit search depth

```bash
find . -maxdepth 2 -name "*.rb"
find . -mindepth 3 -name "*.js"
```

#### 9. Exclude directories

```bash
find . -name "node_modules" -prune -o -name "*.js" -print
find . -type d -name ".git" -prune -o -type f -print
```

#### 10. Find files by multiple criteria

```bash
find . -name "*.rb" -type f -size +1k -mtime -30
```

#### 11. Find files by permissions

```bash
find . -type f -perm 644
find . -type f -perm -u+x  # executable by user
```

#### 12. Find files owned by user

```bash
find . -user ravi
find /var/log -user root
```

#### 13. Combine with grep

```bash
find . -name "*.rb" -exec grep -l "class" {} \;
```

#### 14. Find and list with details

```bash
find . -name "*.rb" -ls
```

#### 15. Find files modified in last hour

```bash
find . -type f -mmin -60
```

#### 16. Find and copy files

```bash
find . -name "*.rb" -exec cp {} /backup/ \;
```

#### 17. Find files by extension (multiple)

```bash
find . -type f \( -name "*.rb" -o -name "*.js" -o -name "*.py" \)
```

---

## locate - Fast File Search

`locate` uses a database to quickly find files. Faster than `find` but requires updated database.

### Basic Syntax

```bash
locate [options] pattern
```

### Common Options

| Option | Description         | Example               |
| ------ | ------------------- | --------------------- |
| `-i`   | Case-insensitive    | `locate -i "config"`  |
| `-c`   | Count matches       | `locate -c "*.rb"`    |
| `-l n` | Limit results       | `locate -l 10 "*.rb"` |
| `-r`   | Use regex           | `locate -r "\.rb$"`   |
| `-b`   | Match only basename | `locate -b "config"`  |

### Update Database

```bash
# On macOS (using locate)
sudo /usr/libexec/locate.updatedb

# On Linux
sudo updatedb
```

### Practical Examples

#### 1. Find file quickly

```bash
locate config.txt
```

#### 2. Case-insensitive search

```bash
locate -i "readme"
```

#### 3. Limit results

```bash
locate -l 20 "*.rb"
```

#### 4. Count matches

```bash
locate -c "*.js"
```

#### 5. Regex search

```bash
locate -r "\.rb$"
```

---

## which - Find Command Location

Shows the full path of shell commands.

### Basic Syntax

```bash
which [command...]
```

### Options

| Option | Description      | Example           |
| ------ | ---------------- | ----------------- |
| `-a`   | Show all matches | `which -a python` |

### Practical Examples

#### 1. Find command location

```bash
which python
which ruby
which git
```

#### 2. Find all instances

```bash
which -a python
```

---

## whereis - Locate Binary, Source, Manual

Finds binary, source, and manual page files for a command.

### Basic Syntax

```bash
whereis [options] command...
```

### Options

| Option | Description              | Example             |
| ------ | ------------------------ | ------------------- |
| `-b`   | Search only binaries     | `whereis -b python` |
| `-m`   | Search only manual pages | `whereis -m python` |
| `-s`   | Search only sources      | `whereis -s python` |

### Practical Examples

#### 1. Find all locations

```bash
whereis python
```

#### 2. Find only binary

```bash
whereis -b git
```

---

## ack/ag - Advanced Text Search

`ack` (or `ag` - The Silver Searcher) are faster alternatives to grep with better defaults.

### Installation

```bash
# macOS
brew install ack
brew install the_silver_searcher

# Linux
sudo apt-get install ack-grep
sudo apt-get install silversearcher-ag
```

### Common Options

| Option         | Description            | Example                                  |
| -------------- | ---------------------- | ---------------------------------------- |
| `-i`           | Case-insensitive       | `ack -i "error"`                         |
| `-w`           | Whole word             | `ack -w "class"`                         |
| `-l`           | Show filenames only    | `ack -l "TODO"`                          |
| `-c`           | Count matches          | `ack -c "function"`                      |
| `-A n`         | Show n lines after     | `ack -A 3 "error"`                       |
| `-B n`         | Show n lines before    | `ack -B 3 "error"`                       |
| `-C n`         | Show n lines context   | `ack -C 3 "error"`                       |
| `--type=ruby`  | Search only Ruby files | `ack --type=ruby "class"`                |
| `--ignore-dir` | Ignore directory       | `ack --ignore-dir=node_modules "import"` |

### Practical Examples

#### 1. Basic search

```bash
ack "function"
ag "error"
```

#### 2. Search in specific file types

```bash
ack --ruby "class"
ag -G "\.rb$" "def"
```

#### 3. Ignore directories

```bash
ack --ignore-dir=node_modules "import"
ag --ignore node_modules "import"
```

---

## ripgrep (rg) - Fast Text Search

`ripgrep` (rg) is an extremely fast text search tool, faster than grep, ack, and ag.

### Installation

```bash
# macOS
brew install ripgrep

# Linux
sudo apt-get install ripgrep
```

### Common Options

| Option        | Description                       | Example                           |
| ------------- | --------------------------------- | --------------------------------- |
| `-i`          | Case-insensitive                  | `rg -i "error"`                   |
| `-w`          | Whole word                        | `rg -w "class"`                   |
| `-l`          | Show filenames only               | `rg -l "TODO"`                    |
| `-c`          | Count matches                     | `rg -c "function"`                |
| `-A n`        | Show n lines after                | `rg -A 3 "error"`                 |
| `-B n`        | Show n lines before               | `rg -B 3 "error"`                 |
| `-C n`        | Show n lines context              | `rg -C 3 "error"`                 |
| `-t type`     | Search only file type             | `rg -t ruby "class"`              |
| `-g pattern`  | Glob pattern                      | `rg -g "*.rb" "def"`              |
| `--type-list` | List supported types              | `rg --type-list`                  |
| `-u`          | Unrestricted search               | `rg -u "pattern"`                 |
| `--files`     | List files that would be searched | `rg --files`                      |
| `--type-add`  | Add custom type                   | `rg --type-add 'custom:*.custom'` |

### Practical Examples

#### 1. Basic search

```bash
rg "function"
```

#### 2. Case-insensitive

```bash
rg -i "error"
```

#### 3. Search in specific file types

```bash
rg -t ruby "class"
rg -g "*.{rb,js}" "function"
```

#### 4. Show context

```bash
rg -C 5 "exception"
```

#### 5. List files only

```bash
rg -l "TODO"
```

#### 6. Count matches

```bash
rg -c "warning"
```

---

## VS Code Navigation Shortcuts

### File Navigation

| Shortcut                  | Action               | Description                                |
| ------------------------- | -------------------- | ------------------------------------------ |
| `Cmd+P`                   | Quick Open           | Open file by name                          |
| `Cmd+Shift+P`             | Command Palette      | Open command palette                       |
| `Cmd+E`                   | Go to Editor         | Focus on editor / Show recently used files |
| `Cmd+O`                   | Open File            | Open file dialog                           |
| `Cmd+N`                   | New File             | Create new file                            |
| `Cmd+W`                   | Close Tab            | Close current tab                          |
| `Cmd+Shift+T`             | Reopen Closed Editor | Reopen last closed editor tab              |
| `Cmd+K W`                 | Close All Tabs       | Close all editor tabs                      |
| `Cmd+K U`                 | Close Unmodified     | Close unmodified tabs                      |
| `Cmd+\`                   | Split Editor         | Split editor                               |
| `Cmd+K Cmd+\`             | Join Editor          | Join editor group                          |
| `Cmd+1`, `Cmd+2`, `Cmd+3` | Focus Editor Group   | Focus editor group 1, 2, 3                 |

### Quick Open Features

| Shortcut         | Action                    | Description                         |
| ---------------- | ------------------------- | ----------------------------------- |
| `Cmd+P` then `@` | Go to Symbol              | Navigate to symbol in file          |
| `Cmd+P` then `#` | Go to Symbol in Workspace | Navigate to symbol across workspace |
| `Cmd+P` then `:` | Go to Line                | Jump to line number                 |
| `Cmd+P` then `>` | Run Command               | Run command from quick open         |

### Symbol Navigation

| Shortcut           | Action                    | Description                         |
| ------------------ | ------------------------- | ----------------------------------- |
| `Cmd+Shift+O`      | Go to Symbol in File      | Navigate to symbol in current file  |
| `Cmd+T`            | Go to Symbol in Workspace | Navigate to symbol across workspace |
| `F12`              | Go to Definition          | Go to definition                    |
| `Cmd+Click`        | Go to Definition          | Go to definition (mouse)            |
| `Option+F12`       | Peek Definition           | Peek definition                     |
| `Shift+F12`        | Find All References       | Find all references                 |
| `Cmd+F12`          | Go to Implementation      | Go to implementation                |
| `Option+Shift+F12` | Peek Implementation       | Peek implementation                 |

### Breadcrumb Navigation

| Shortcut         | Action               | Description                 |
| ---------------- | -------------------- | --------------------------- |
| `Cmd+Shift+.`    | Focus Breadcrumbs    | Focus breadcrumb navigation |
| `Cmd+Left/Right` | Navigate Breadcrumbs | Navigate breadcrumbs        |

### Editor Navigation

| Shortcut       | Action                                 | Description                  |
| -------------- | -------------------------------------- | ---------------------------- |
| `Ctrl+G`       | Go to Line                             | Jump to specific line number |
| `Cmd+G`        | Find Next                              | Find next occurrence         |
| `Shift+Cmd+G`  | Find Previous                          | Find previous occurrence     |
| `Option+Enter` | Select All Matches                     | Select all occurrences       |
| `Cmd+D`        | Add Selection to Next Find Match       | Add next match to selection  |
| `Cmd+K Cmd+D`  | Move Last Selection to Next Find Match | Move selection to next match |
| `Cmd+U`        | Undo Last Cursor Operation             | Undo last cursor operation   |

### File Explorer

| Shortcut      | Action         | Description         |
| ------------- | -------------- | ------------------- |
| `Cmd+Shift+E` | Focus Explorer | Focus file explorer |

### Search & Replace

| Shortcut       | Action           | Description          |
| -------------- | ---------------- | -------------------- |
| `Cmd+F`        | Find             | Find in file         |
| `Option+Cmd+F` | Replace          | Replace in file      |
| `Cmd+Shift+F`  | Find in Files    | Search across files  |
| `Cmd+Shift+H`  | Replace in Files | Replace across files |

### Navigation History

| Shortcut           | Action     | Description                 |
| ------------------ | ---------- | --------------------------- |
| `Ctrl+-`           | Go Back    | Navigate back in history    |
| `Ctrl+Shift+-`     | Go Forward | Navigate forward in history |
| `Cmd+Option+Left`  | Go Back    | Navigate back               |
| `Cmd+Option+Right` | Go Forward | Navigate forward            |

### Advanced Navigation

| Shortcut              | Action             | Description                    |
| --------------------- | ------------------ | ------------------------------ |
| `Cmd+P` then type `?` | Show Help          | Show quick open help           |
| `Cmd+K Cmd+S`         | Keyboard Shortcuts | Open keyboard shortcuts editor |
| `Cmd+K Cmd+T`         | Select Color Theme | Change color theme             |
| `Cmd+,`               | Open Settings      | Open settings                  |

### Tips for Efficient Navigation

1. **Quick Open (`Cmd+P`)**: Start typing filename - VS Code uses fuzzy matching
2. **Go to Editor (`Cmd+E`)**: Quickly switch between recently used files - shows list of open/recent files
3. **Go to Symbol (`Cmd+Shift+O`)**: Quickly jump to functions, classes, etc. in current file
4. **Go to Symbol in Workspace (`Cmd+T`)**: Find symbols across entire workspace
5. **Cmd+Click**: Click on any symbol while holding Cmd to jump to its definition (most intuitive way!)
6. **Reopen Closed Editor (`Cmd+Shift+T`)**: Accidentally closed a file? Reopen it instantly!
7. **Find in Files (`Cmd+Shift+F`)**: Search across all files in workspace with powerful filters
8. **Peek Definition (`Option+F12`)**: View definition without leaving current file
9. **Breadcrumbs**: Use breadcrumbs to navigate file structure
10. **Multi-cursor**: Use `Cmd+D` to select multiple occurrences
11. **Command Palette**: `Cmd+Shift+P` for any command by name

---

## Quick Reference Cheat Sheet

### Most Used grep Commands

```bash
grep -rn "pattern" .                    # Recursive with line numbers
grep -i "pattern" file                  # Case-insensitive
grep -l "pattern" *.rb                  # List files with matches
grep -C 3 "pattern" file                # Context (3 lines before/after)
grep -v "pattern" file                  # Invert match
grep -E "pattern1|pattern2" file        # Multiple patterns
```

### Most Used find Commands

```bash
find . -name "*.rb"                     # Find by name
find . -type f -mtime -7                # Files modified in last 7 days
find . -size +100M                      # Files larger than 100MB
find . -name "*.tmp" -delete            # Find and delete
find . -name "*.rb" -exec grep -l "class" {} \;  # Find and grep
```

### Most Used VS Code Shortcuts

```
Cmd+P          Quick Open (open file by name)
Cmd+E          Go to Editor (recently used files)
Cmd+T          Go to Symbol in Workspace
Cmd+Click      Go to Definition (mouse)
Cmd+Shift+T    Reopen Closed Editor
Cmd+Shift+F    Find in Files (search across workspace)
Cmd+Shift+O    Go to Symbol in File
F12            Go to Definition (keyboard)
Cmd+F          Find in File
Ctrl+-         Go Back
Ctrl+Shift+-   Go Forward
```

---

## Additional Resources

- **grep manual**: `man grep`
- **find manual**: `man find`
- **VS Code Keyboard Shortcuts**: `Cmd+K Cmd+S`
- **VS Code Documentation**: https://code.visualstudio.com/docs

---

_Last Updated: 2024_
