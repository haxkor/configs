function tfssh --description 'SSH into a Terraform machine by name or number'
    set -l key $argv[1]

    set -l tf_files *.tf *.tofu
    if test (count $tf_files) -eq 0
        echo "tfssh: no OpenTofu files (*.tf, *.tofu) in "(pwd) >&2
        return 1
    end

    set -l json (tofu output -json addresses_by_name)
    set -l keys (echo $json | jq -r 'keys[]')

    if test -z "$key"
        if test (count $keys) -eq 1
            set key $keys[1]
        else
            for i in (seq 0 (math (count $keys) - 1))
                echo "  $i " $keys[(math $i + 1)] >&2
            end
            return 1
        end
    else if string match -qr '^[0-9]+$' -- $key
        if test $key -lt 0 -o $key -ge (count $keys)
            for i in (seq 0 (math (count $keys) - 1))
                echo "  $i " $keys[(math $i + 1)] >&2
            end
            return 1
        end
        set key $keys[(math $key + 1)]
    end

    if not echo $json | jq -e --arg k "$key" 'has($k)' >/dev/null
        for i in (seq 0 (math (count $keys) - 1))
            echo "  $i " $keys[(math $i + 1)] >&2
        end
        return 1
    end

    set -l host "$key.sol.labwi.sva.de"
    echo "Connecting to $host..."
    ssh jruehl@$host
end
