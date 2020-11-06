export RESPONSE=$(curl -sb -H "Accept: application/json" "https://api.github.com/repos/platformio/platformio-core/releases/latest")
export FULL_VERSION="`echo $RESPONSE | grep -oP '"tag_name":\s"v\K(\d\.\d\.\d)'`"

VERSIONS=$(echo $FULL_VERSION | tr "." "\n")

COUNTER=0
for sub in $VERSIONS
do
    case $COUNTER  in
        0)
            export MAJOR=$sub
            ;;

        1)
            export MINOR=$sub
            ;;

        2)
            export PATCH=$sub
            ;;

        *)
            echo -n "unknown"
            ;;
    esac

    ((COUNTER=COUNTER+1))
done