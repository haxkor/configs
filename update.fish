#!/usr/bin/env fish

function update
    set files ~/.tmux.conf ~/.config/fish ~/.config/nvim ~/.config/ghostty

    for f in $files;
        rsync -a --delete $f synced/
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
end

function deploy
    set files ~/.tmux.conf ~/.config/fish ~/.config/nvim ~/.config/ghostty

    for f in $files;
        rsync --verbose -a synced/(basename $f) (dirname $f)/
        or begin
            echo "rsync failed for $f" >&2
            exit 1
        end;
    end;
end

if contains -- --update $argv
    update
end

if contains -- --deploy $argv
    deploy
end

if test (count $argv) -eq 0
    echo "usage: update.fish [--update | --deploy]"
    echo "  --update  sync configs from home into synced/ and commit/push"
    echo "  --deploy  sync configs from synced/ back out to home (no deletions)"
end
