function tfssh --description 'SSH into a Terraform machine by name or number'
    argparse ip -- $argv; or return
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
        else if set -q _flag_ip
            set -l ips (echo $json | jq -r 'keys[] as $k | .[$k] | if type == "array" then .[0] else . end')
            set -l names (string pad -r -w (string length -- $keys | sort -n | tail -1) -- $keys)
            for i in (seq 0 (math (count $keys) - 1))
                echo "  $i " $names[(math $i + 1)] " " $ips[(math $i + 1)] >&2
            end
            return 1
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
    set -l ssh_status $status

    # 255 means ssh itself failed (DNS, connection, auth); anything else is the remote session's exit code
    if test $ssh_status -ne 255
        return $ssh_status
    end

    set -l ip (echo $json | jq -r --arg k "$key" '.[$k] | if type == "array" then .[0] else . end')
    if test -z "$ip" -o "$ip" = null
        echo "tfssh: no IP for $key in tofu output" >&2
        return $ssh_status
    end

    echo "Retrying via ip..."
    ssh jruehl@$ip
end
