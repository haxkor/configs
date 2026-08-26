function tfssh --description 'SSH into a Terraform machine by name'
    set -l key $argv[1]

    set -l json (tofu output -json addresses_by_name)
    set -l keys (echo $json | jq -r 'keys[]')

    if test -z "$key"
        if test (count $keys) -eq 1
            set key $keys[1]
        else
            echo "Multiple machines available, please specify one:" >&2
            for k in $keys
                echo "  $k" >&2
            end
            return 1
        end
    end

    if not echo $json | jq -e --arg k "$key" 'has($k)' >/dev/null
        echo "No entry '$key' in addresses_by_name. Available keys:" >&2
        for k in $keys
            echo "  $k" >&2
        end
        return 1
    end

    set -l host "$key.sol.labwi.sva.de"
    echo "Connecting to $host..."
    ssh jruehl@$host
end
