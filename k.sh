k() {
    if [ -z "$1" ]; then
        echo "Usage: k <char-id>"
        return 1
    fi
    
    # Convert char ID to number using Python script with full path
    num_id=$(python3 -c "import sys; sys.path.append('/home/tom/git/scripts'); from task_id_mapper import char_id_to_number; print(char_id_to_number('$1'))")
    
    if [ $? -eq 0 ]; then
        s "$num_id"
    else
        echo "Invalid character ID. Use only these keys: asdfghjk"
        return 1
    fi
}
