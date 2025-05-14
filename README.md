# Timesplit

Last updated for version: 0.3.30

## Introduction

A Bachlor's Thesis project which aims at analysis, design and implementation of a detective video game with a space-time travel element.

---
# Table of Contents
- [Timesplit](#timesplit)
  - [Introduction](#introduction)
- [Table of Contents](#table-of-contents)
- [Game Information](#game-information)
  - [Game's Hook](#games-hook)
  - [Genre](#genre)
  - [Platform](#platform)
  - [Style](#style)
  - [Game Project Links](#game-project-links)
- [Thesis Information](#thesis-information)
  - [Abstract](#abstract)
  - [University Information](#university-information)
  - [Thesis Links](#thesis-links)
- [Technical Information](#technical-information)
  - [Platforms](#platforms)
  - [Compilation](#compilation)
  - [Execution](#execution)
  - [Project Structure](#project-structure)
# Game Information

A 2D sidescroller detective game that enables the player to solve crimes by travelling between timelines.

## Game's Hook

Your detective agency's R&D team has created a strange device that allows users to cross between alternative timelines similar to the one you are standing in, and the best way to test it is to use it in the field. You are tasked with using and testing the device while solving cases. What will you find out with the help of this new strange device? What consequences will it bring to solving crimes, and are there any downsides to hopping through time and space? That is your objective to find out.

## Genre

A deduction-style detective game with narrative, puzzle, and platforming elements. The detective work includes interrogation of witnesses or suspects, collecting evidence on a detective board, making connections and deductions based on this evidence, coming to conclusions, and deciding how the case is going to end. The puzzle and platforming elements will include the timeline-travelling mechanic, like going around locked doors in one timeline but not the other or making a difficult jump with platforming elements scattered throughout timelines.

## Platform

The target platform for this project will be PC, more specifically the Windows operating system, but porting this game to other operating systems or consoles should not be a problem given the simple graphics and mechanics and Godot's multiplatform approach.

## Style

The visual style is highly influenced by games such as Noita, Risk of Rain, and The Final Station. A somewhat detailed and cluttered 2D world space simplified by a pixelated art style. This approach makes sure that the world feels lived in while not demanding high performance or resources. All of this combined with realistic-looking lighting and a darker tone mixes into a very dense atmosphere that can be cut through if the story demands it.

## Game Project Links

- [GitHub](https://github.com/AlfieLeFluffy/bc_project) - Full version history and releases
- [Itch.io](https://alfielefluffy.itch.io/timesplit) - Published releases

---
# Thesis Information

This project was created as part of Bachelor's Thesis in Brno University of Technology, Faculty of Information Technology.

## Abstract

The goal of this thesis is to analyse, design and implement a detective video game with space-time travel mechanics in the form of timeline shifting. The thesis starts with exploring core questions of game studies, what games are, how they work, and what detective games are, video game development practices for the design of the game. The thesis also covers the use and common implementation of game engines and the Game Engine Godot. The outcome of this thesis is a functional video game demo that has fully implemented gameplay mechanics, audiovisual elements, and additional supporting systems with minimal use of third-party software or libraries. As a result, this thesis brings a clear overview of the entire video game development process.

## University Information

- **Author**: Tomáš Vlach
- **VUT Login**: xvlach24
- **VUT e-mail**: xvlach24@stud.fit.vutbr.cz
- **Thesis Name**: Detektivní Hra s Cestováním Časoprostorem
- **Thesis Code**: 164898

## Thesis Links

- [Thesis Details](https://www.vut.cz/studenti/zav-prace/detail/164898)
- [Thesis Overleaf](https://www.overleaf.com/read/twpczcnznxhh#bc806a)
- [GDD Overleaf](https://www.overleaf.com/read/gkpbptyhcnzn#17bfb2)
- [Progress Files and Videos](https://drive.google.com/drive/folders/13PzWl_va_rGZKxa5m8iDC4oJbKnCQCTx?usp=sharing)

---
# Technical Information

## Platforms

As of now the project is only optimized for the PC platform running Windows 10 operating system. Other export options are available, but issues with performance or uncaught errors might occur. Save files and and profile saving is only available on the PC platform, and is disabled for the Web version. The game is still playable on platforms that currently do not support persistence, but the player won't be able to save their progress.

## Compilation

The project source can be compiled using the game engine Godot, version 4.4 or higher if compatibility allows. To do so a complete copy of the source code must be downloaded and the project must be opened through the Godot project selection screen. Once opened, the game can be exported by going through several steps outlined below:

1. Open the `Project` menu bar in the top left corner of the editor.
2. Select the `Export...` option.
3. Select the desired export platform, which includes preconfigured platform settings (Windows, Web, etc.).
4. Press the `Export Project...` button at the bottom of the Export menu.
5. Confirm file path selection (will export into the `build` directory inside the project files) or select and confirm another export file path.
6. Wait for the export to finish.
7. Done, an exported game executable should have appeared in the selected file path.

**If compiling for Windows** it is important to also download and setup a filepath to a program called [rcedit](https://github.com/electron/rcedit). The filepath can be setup in the Windows export preset. Without this program the compilation should still be successful but some aspects are going to be broken.

If there are any issues with exporting this project, then contact the project author with the provided information above. If you are the reviewer of this thesis and the author has not contacted you already regarding a demonstration of compilation, then contact the author as well or check your e-mail inbox in case the author has already reached out to you.

## Execution

Execeution of the game depends on the target compilation method, but for all platforms (with the exception of Web) the game should be compiled as a simple executable that the user should be able to run without any other external tools. Currently there is not signing of the executable so operation systems like Windows might warn the user that they are running a possibly dangerous program.

## Project Structure

The entire implementation side of the project is contained within the `bc_project` directory. In this directory lies the projects core file `project.godot`, which holds all necesarry information for importing and editing of the the project. If you are aiming to import this project into the editor then this is the file you are looking for. Other then that the directory also contains a file holding exporting presets.

The `bc_project` directory then contains directories that each correspond to one of the game's aspects. These are:

- `addons` - contains the Dialogue Manager addon used in this project.
- `audio` - contains all used audio files and the audio manager resource.
- `dialogs` - contains all `.dialogue` files used. Specific spelling used to avoid name conflict with Dialogue Manager.
- `fonts` - contains the custom and used fonts.
- `scenes` - contains nearly all game scenes. This includes game objects, menues, levels and some of the game systems, etc.
- `scripts` - contains mostly single use scripts and game systems such as settings controller, persistence controller, their menus and such.
- `settings` - contains all control themes and settings.
- `shaders` - contains all shaders used in the project.
- `texture` - holds all texture including tile set textures, chracter sprite sheets, light maps, etc.
- `tilesets` - contains all predefined tilesets the game uses for levels.
- `translations` - contains all translation files the game uses structured into dialogue, game and object subcategories.

A large part of the game contains comments using the documentation structure Godot implements.

