#!/bin/bash
# set -x

args=("$@")

args_size=${#args[@]}



for i in `seq 0 $args_size`
do
    if [ "${args[$i]}" = "-id" ]
    then
        id=${args[$i+1]}
    fi

    if [ "${args[$i]}" = "-f" ]
    then
        file=${args[$i+1]}
    fi

    if [ "${args[$i]}" = "-s" ]
    then
        str=${args[$i+1]}
    fi

    if [ "${args[$i]}" = "-r" ]
    then
        read=true
    fi

    if [ "${args[$i]}" = "-w" ]
    then
        write=true
    fi

    if [ "${args[$i]}" = "-a" ]
    then
        append=true
    fi

    if [ "${args[$i]}" = "-d" ]
    then
        delete=true
    fi
done

if [ -n "$id" ]
then
    if [ "$read" = true ]
    then
        html=$(curl -X GET http://dontpad.com/$id 2> /dev/null)
        html="${html%%'</textarea'*}"
        html="${html##*'<textarea id="text">'}"
        echo "$html"
    elif [ "$write" = true ]
    then
        if [ -n "$str" ]
        then
            curl -d 'text='"$str" http://dontpad.com/$id > /dev/null 2>&1
        elif [ -n "$file" ]
        then
            file_str=$(cat $file)
            curl -d 'text='"$file_str" http://dontpad.com/$id > /dev/null 2>&1
        fi
    elif [ "$append" = true ]
    then
        old=$(curl -X GET http://dontpad.com/$id 2> /dev/null)
        old="${old%%'</textarea'*}"
        old="${old##*'<textarea id="text">'}"
        if [ -n "$str" ]
        then
            curl -d 'text='"$old$str" http://dontpad.com/$id > /dev/null 2>&1
        elif [ -n "$file" ]
        then
            file_str=$(cat $file)
            curl -d 'text='"$old$file_str" http://dontpad.com/$id > /dev/null 2>&1
        fi
    elif [ "$delete" = true ]
    then
        curl -d 'text= ' http://dontpad.com/$id > /dev/null 2>&1
    fi
else
    echo "Id Missing"
fi


