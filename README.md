# Timesplit

A Bachlor's Thesis regarding the analysis, design and implementation of a detective video game with space-time travel.

---

## Basic Thesis Information

### Game Description

A 2D sidescroller detective game that enables the player to solve crimes by traveling between timelines.

### Game's Plothook

Your detective agency's R&D team has created a strange device that allows users to cross between alternative timelines similar to the one you are standing in and the best way to test it, is to use it in the field. You are tasked with using and testing the device while solving cases. What will you find out with the help of this new strange device, what consequences will it bring to solving crimes and are there any downsides of hoping through time and space? That is your objective to find out.

### University Information

- Author: Tomáš Vlach
- VUT Login: xvlach24
- VUT e-mail: xvlach24@stud.fit.vutbr.cz
- Thesis Name: Detektivní Hra s Cestováním Časoprostorem
- Thesis Code: 164898

### Project Links

- [GitHub](https://github.com/AlfieLeFluffy/bc_project)
- [Thesis Overleaf](https://www.overleaf.com/read/twpczcnznxhh#bc806a)
- [GDD Overleaf](https://www.overleaf.com/read/gkpbptyhcnzn#17bfb2)
- [Progress Files and Videos](https://drive.google.com/drive/folders/13PzWl_va_rGZKxa5m8iDC4oJbKnCQCTx?usp=sharing)

---

## Technical Information

### Compilation

The project source can be compiled using the game engine Godot, version 4.4 or higher if compatibility allows. To do so a complete copy of the source code must be downloaded and the project must be opened through Godot project selection screen. Once opened, the game can be exported by going through several steps outlined below:

1. Open the `Project` menu bar in the top left corner of the editor.
2. Select the `Export...` option.
3. Select the desired export platform, which includes preconfigured platform settings (Windows, Web, etc.).
4. Press `Export Project...` button at the bottom of the Export menu.
5. Confirm file path selection (will export into the `build` directory inside the project files) or select and cofirm another export file path.
6. Wait for the export to finish.
7. Done, an exported game executable should have appeared in the selected file path.

**If compiling for Windows** it is important to also download and setup a filepath to a program called [rcedit](https://github.com/electron/rcedit). The filepath can be setup in the Windows export preset. Without this program the compilation should still be successful but some aspects are going to be broken.

If there are any issues with exporting of this project then contact the project author with the provided information above. If you are the reviewer of this thesis and the author has not contanted already regarding a demostration of compilation then contact the author as well or check your e-mail inbox in case the author has already reached out to you.

### Execution

Execeution of the game (program) depends on the target compilation method, but for all platforms (with the exception of Web) the game should be compiled as a simple executable that the user should be able to run without any other external tools. 