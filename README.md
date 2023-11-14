# Assembly Course Development Guide

Welcome to this assembly course.

## Setup

In order to be able to build and test your programs, you need to install some tools.

You'll require the _assembler_ tool **nasm**, you can download it from this [link](https://www.nasm.us/). Download the
**_.zip_** file and unpack it inside the **nasm/** directory.

You also need to install **DOSBox**. It'll be your runtime environment. You can download it following this [link](https://www.dosbox.com/download.php?main=1)

Some legacy tools maybe useful, particularly **Turbo Debugger**, you can find in within the **tools/8086.zip** archive. Simply copy the **_TD.EXE_** file
to the **bin/** directory.

To edit your programs, I recommend you to use **VSCode**, as it's free, have a lot of features and customizable. But ultimately you can use the editor of your choice.

## Overview

We need some presentation of the file system layout.

 * **bin/** will be mounted as _"C:"_ within the **DOSBox** environment. The _Windows_ command file **launch-dosbox.cmd** do this. You can tweak it to your needs.
 * **nasm/** is where the assembler will be located.
 * **ref-data/** holds some reference data. Those will be used for some tests and examples. The data file will have to be copied to **bin/** in order to be available within the **DOSBox** environment.
 * **srcs/** is the root of your sources files. There will be a couple of sub-directories, for course exercises and your project.
   * **course/** will hold the exercise sources.
 * **tools/** holds some legacy (_DOS_) tools. The only important one is **Turbo Debugger** (**_TD.EXE_**).

## Sources files

Each program will have its own set of source below the **srcs/** directory.

Your program will be written from a base __.asm__ file and optional __.inc__ files. Technically the extensions are not mandatory, you can use whatever you want, it's just a good practice to use the
_de facto_ standards.

Next to your source files, there should be a Windows command file '__build-*.cmd' which will call **nasm** to generate your program binary into the **bin/** directory.

Here is an extract for the first example "Hello World":

    @echo off
    set "SCRIPT_DIR=%~dp0"
    set "ROOT_DIR=%SCRIPT_DIR%..\..\.."
    set "NASM=%ROOT_DIR%\nasm\nasm"
    set "BIN_DIR=%ROOT_DIR%\bin"

    "%NASM%" HelloWorld.asm -f bin -o "%BIN_DIR%\hello.com"

    pause

The script first keeps its holding directory into a _SCRIPT\_DIR_ environment variable. Then the root directory is reached, and serves as basis to acces **NASM** binary and the target **bin/** directory.

Then **NASM** is invoked to build the target binary from the specified sources.

Finally a _pause_ command waits for some key, because by default the terminal window opened while launching the _Windows_ command will close immediately. This allows you to read error messages.

You can, of course, customize your own tools if you want to integrate the build/test. **VSCode** can be customized and configured to be able to do this. If it helps you to have a seamless development pipeline, go for it.
Just keep in mind not to lose too much time doing it.

## Final words

What else ? Enjoy the ride.

