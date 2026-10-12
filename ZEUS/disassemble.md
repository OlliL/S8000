# Guide: Disassembling Z8000 `s.out` Object Files with `adb` (WEGA 3.1)

This guide describes how to inspect and fully disassemble a Z8000 `s.out` object file (or executable program file) under the **WEGA 3.1** operating system using the **`adb`** debugger.

## 1. Starting `adb`

Invoke the debugger passing your target object file as an argument:

```bash
adb s.out
```

> **Note:** If no filename is specified, `adb` defaults to looking for `a.out`.

## 2. Core Command for Disassembly (`?i`)

In `adb`, machine code disassembly is controlled via the format specifier **`i`** (U8000 instruction/command).

- The prefix **`?`** instructs `adb` to read data from the **object file** (`objfil`) rather than a core file.

### Specifying Start Address and Count

The general command syntax in `adb` is:

```text
[address] [,count] [command]
```

- **Start at address 0:**

  ```text
  0?i
  ```

- **Start at the Entry Point:**
  The entry point is automatically stored in the variable `e`. You can begin directly there:

  ```text
  e?i
  ```

- **Specify a fixed number of instructions (e.g., 100 instructions starting at address 0):**

  ```text
  0,100?i
  ```


## 3. Interactive Stepping

When you enter `0?i` (or `e?i`), the first instruction is disassembled and `dot` (the current address pointer) is automatically advanced to the next instruction.

- Simply pressing **Enter (Newline)** repeats the last command with `count=1`, stepping further down through the code line by line.

## 4. Redirecting Full Disassembly to a File

Since a complete disassembly can be very long, you can redirect the output directly to a file using the **`$> `** modifier or shell redirection.

### Method A: Directly within the `adb` Session

```text
$> disass.txt
0,1000?i
$q
```

*(Use `$q` to exit `adb`).*

### Method B: Via Shell Redirection (Here-Document)

Alternatively, pass commands via a here-document from the shell and redirect standard output:

```bash
adb s.out << 'EOF' > disass.txt
0,t?i
$q
EOF
```

> **Explanation:** The variable **`t`** holds the size of the text segment in bytes according to the `adb` variables table, allowing you to cover the entire code range automatically.