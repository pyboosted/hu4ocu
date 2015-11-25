#Hu4ocu - App that makes your broadcasts more interactive than ever

##About

Hu4ocu is an application that helps you to add interactivity to yuor broadcasts. Using Hu4ocu you can make polls, organize a raffle.

Hu4ocu is built with [Electron](https://github.com/atom/electron)(ex. atom-shell), [Mithril](https://github.com/lhorie/mithril) and [Haxe](https://github.com/HaxeFoundation/haxe).

## Building from source

1. Clone the repository using git. Be sure to initialize and fetch the submodules.

    ```
    git clone --recursive git@github.com:pyboosted/hu4ocu.git
    cd hu4ocu
    ```

2. Install [Haxe](https://github.com/HaxeFoundation/haxe).

3. Install [Electron](https://github.com/atom/electron).

    ```
    npm install -g electron
    ```

4. Install npm modules.

    ```
    npm install
    ```

5. Make the application.

    ```
    make all
    ```

6. Run.

    ```
    make run
    ```