# Linux wallpaper engine installer

1. Go to linux wallpaper engine github
2. Try yay, if not works, clone the repo and build from source
3. Install Steam
4. Install Wallpaper Engine
5. Install noctalia wallpaper engine plugin
6. Copy binary to bin :
```
sudo cp output/linux-wallpaperengine /usr/local/bin/
sudo chmod +x /usr/local/bin/linux-wallpaperengine
```
7. Copy wallpaper engine assets to binary of wallpaper engine :
```
sudo cp -r ~/.local/share/Steam/steamapps/common/wallpaper_engine/assets /usr/local/bin/
```

## Notes
When switching wallpapers memmory leak occurs.Simpliest solution is to use script clean.sh