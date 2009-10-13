@echo off

title Matrixy - Copyright (C) 2009 Blair Sutton and Andrew Whitworth.
set PARROT=..\..\parrot.exe
if "%OS%" == "Windows_NT" goto WinNT
%PARROT% matrixy.pbc %1 %2 %3 %4 %5 %6 %7 %8 %9
goto EndOfScript

:WinNT
%PARROT% matrixy.pbc %*

:EndOfScript