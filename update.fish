set files ~/.tmux.conf ~/.config/fish ~/.config/nvim ~/.config/ghostty

for f in $files;
    rsync -a --delete $f .
    or begin
        echo "rsync failed for $f" >&2
        exit 1
    end;
end;

git add -A
if git diff --cached --quiet
    echo "nothing to commit"
else
    git commit -m "autoupdate "(date +%Y-%m-%d_%H:%M)
    git push
end
