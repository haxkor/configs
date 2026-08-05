set files ~/.tmux.conf ~/.config/fish ~/.config/nvim ~/.config/ghostty
set fish_trace true

for f in $files:
    cp -r $f .
    echo $f
end

git add *
git commit -m "autoupdate"
git push
