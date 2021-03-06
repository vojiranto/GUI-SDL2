# [GUI-SDL2][]

**GUI-SDL2** is **SDL2**,**SDL2_image** and **SDL2_ttf** based desktop GUI that is completely written in Haskell.

This GUI is in the design process now. 
 
# Building

-   Install **SDL2**, **SDL2_image** and **SDL2_ttf** C packages (not Haskell packages). 
    Look **Building** section in https://github.com/haskell-game/sdl2 about install **SDL2**.
    **SDL2_image** and **SDL2_ttf** are installed similarly.
    
    -- Install C packages on **Ubuntu 16.04**
    
``` sh
sudo apt install libsdl2-image-dev
sudo apt install libsdl2-ttf-dev
```

    -- For install C packages on **Windows 64** you can use stack's embedded MSYS2.
    
``` bat
stack exec -- pacman -Syu
stack exec -- pacman -S mingw-w64-x86_64-pkg-config mingw-w64-x86_64-SDL2
stack exec -- pacman -S mingw-w64-x86_64-SDL2_image mingw-w64-x86_64-SDL2_ttf
```

-   For all OS.  Build and run the GUIDemo from GUI-SDL2 directory.
``` sh
stack build --flag GUI-SDL2:examples --exec GUIDemo
```

# See other examples

Change **EXAMPLE_NUM** in `src\Main.hs` to other numbers **0,1,2...** by selecting different examples to view and repeat `stack build --flag GUI-SDL2:examples --exec GUIDemo`. 

[GUI-SDL2]: https://github.com/KolodeznyDiver/GUI-SDL2
