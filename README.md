# [cs50-pong](https://cs50.harvard.edu/games/2018/projects/0/pong/)
Pong from the [CS50 course on game development.](https://cs50.harvard.edu/games/2018/)

I took up this course as it interested me and I wanted to work on creating a game. It was a very enjoyable experience working on this course and the game after watching the initial content on [YouTube.](https://youtu.be/GfwpRU0cT10?list=PLhQjrBD2T383Vx9-4vJYFsJbvZ_D17Qzh) It also felt very comfortable working in Lua, even though it was a newer language, though granted I did not use many of the advanced features of the language.

Most of the code is based off of the code explained during the course. However, I added quite a few changes of my own while working on it, and I believe I made changes which would make for better maintainable code.

## Some of my main changes
- A game mechanic where the paddle heights increase / decrease in size based on who won in that round
- Game audio for game load, game won (made using [bfxr](https://www.bfxr.net/))
- A win screen
- Some UI changes which I preferred to the one done in the course
- Replayability

## Want to play it?
### You will need to: 
- Download [LÖVE](https://love2d.org/) (I used LÖVE 11.4 to make this) 
- Clone the repository
- Open a terminal while inside the root folder of the repository ("path-to-repository/pong-cs50/")
- Once inside the `pong-cs50` folder, in the terminal, just run, `love .`
- Or if you have the path to your cloned repository copied and available, just open a terminal from anywhere and run `love path-to-your-cloned-repo` (ex: `love "C:/Cloned Repos/pong-cs50"`)
- If `love` does not run, make sure you add the location of the `love.exe` application (the place where LÖVE's installed files are located) into your machine's `PATH` variable. 
- If you don't want do that, then in the terminal, enter the path to your LÖVE executable and then the path to the cloned repository. Press Enter. 
`"C:/Program Files/LOVE2D/love.exe" "C:/Cloned Repos/pong-cs50"`.
