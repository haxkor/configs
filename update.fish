set files ~/.tmux.conf ~/.config/fish/ ~/.config/nvim/ ~/.config/ghostty

for f in $files:
    cp -r $f .
    echo $f
end

git add *
git commit -m "autoupdate"
git push
