agos
====

Assembly game OS


This is a small project of a small bootable game, written in x86 Assembly.


The goal is to make the game bootable while at the same time runnable inside a Linux kernel (and, why not, even a Windows kernel if this looks fun to do). The game should have the least OS specific code possible.


The goal of the OS part is to be as minimal as possible, which means this is not actually going to be a real OS. Even if it will switch to 32-bits protected mode (because 16bit instructions feel kind of old now), the "OS" will probably just run the whole game in ring0.

Interrupt handlers will probably be used as the equivalent of the callbacks of the guest OS mode for example.
