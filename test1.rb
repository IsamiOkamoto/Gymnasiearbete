$alphabet_count = [0,381,810,1606,1982,2247,2540,2771,3036,3242,3303,3364,3604,3987,4105,4247,4837,4864,5190,5998,6387,6435,6560,6759,6761,6787]
$abc_array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
def which_letter_index(letter)
    i = 0
    while i < $abc_array.length
        if letter == $abc_array[i]
            return i
        end
        i += 1
    end
end
def similar_length(word)
    a = which_letter_index(word[0])
    i1 = $alphabet_count[a]
    if a == 25
        i2 == rows()
    else
        i2 = $alphabet_count[a + 1]
    end
    output = []
    x = File.readlines("list.csv")
    while i1 < i2
        if x[i1].chomp.length == word.length or x[i1].chomp.length == word.length - 1 or x[i1].chomp.length == word.length + 1
            output.append(x[i1].chomp)
        end
        i1 += 1
    end
    return output
end
def not_in_array(word, arr)
    i = 0
    while i < arr.length
        if word == arr[i]
            return false
        end
        i += 1
    end
    return true
end
def letters_compare(arr, word_arr) #kolla så output är en float
    i = 0
    output = 0
    while i < arr.length
        if not_in_array(arr[i], word_arr) == false
            output += 1
        end
        i += 1
    end
    return output/word_arr.length
end
def find_word_v2(word, arr)
    i = 0
    correct = []
    while i < arr.length
        correct.append(0)
        j = 0
        while j < word.length
            if arr[i].length == word.length
                if j == 0
                    if arr[i][j] == word[j] or arr[i][j] == word[j + 1]
                        correct[i] += 1
                    end
                elsif j == word.length - 1
                    if arr[i][j] == word[j] or arr[i][j] == word[j - 1]
                        correct[i] += 1
                    end
                else
                    if arr[i][j] == word[j] or arr[i][j] == word[j + 1] or arr[i][j] == word[j - 1]
                        correct[i] += 1
                    end
                end
            elsif arr[i].length - 1 == word.length 
                if j == 0
                    if arr[i][j] == word[j] or arr[i][j] == word[j + 1]
                        correct[i] += 1
                    end
                elsif j == word.length - 1
                    if arr[i][j - 1] == word[j]
                        correct[i] += 1
                    end
                else
                    if arr[i][j] == word[j] or arr[i][j] == word[j + 1] or arr[i][j] == word[j - 1]
                        correct[i] += 1
                    end
                end
            elsif arr[i].length + 1 == word.length
                if j == 0
                    if arr[i][j] == word[j] or arr[i][j] == word[j + 1]
                        correct[i] += 1
                    end
                elsif j == word.length - 1
                    if arr[i][j - 1] == word[j] or arr[i][j - 1] == word[j - 1]
                        correct[i] += 1
                    end
                else
                    if arr[i][j] == word[j] or arr[i][j] == word[j + 1] or arr[i][j] == word[j - 1]
                        correct[i] += 1
                    end
                end
            end
            j += 1
        end
        i += 1
    end
    i = 0
    output = []
    while i < correct.length
        if correct[i]/word.length >= 0.75
            output.append(arr[i])
        end
        i += 1
    end
    return output
end
def find_word_v1(word, arr)
    i = 0
    correct = []
    while i < arr.length
        correct.append(0)
        j = 0
        while j < arr[i].length
            if arr[i].length == word.length
                if j == 0
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j]
                        correct[i] += 1
                    end
                elsif j == arr[i].length - 1
                    if arr[i][j] == word[j] or arr[i][j - 1] == word[j]
                        correct[i] += 1
                    end
                else
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j] or arr[i][j - 1] == word[j]
                        correct[i] += 1
                    end
                end
            elsif arr[i].length + 1 == word.length
                if j == 0
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j]
                        correct[i] += 1
                    end
                elsif j == arr[i].length - 1
                    if arr[i][j] == word[j] or arr[i][j - 1] == word[j]
                        correct[i] += 1
                    end
                else
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j] or arr[i][j - 1] == word[j]
                        correct[i] += 1
                    end
                end
            elsif arr[i].length - 1 == word.length
                if j == 0
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j]
                        correct[i] += 1
                    end
                elsif j == arr[i].length - 1
                    if arr[i][j] == word[j - 1] 
                        correct[i] += 1
                    end
                else
                    if arr[i][j] == word[j] or arr[i][j + 1] == word[j] or arr[i][j - 1] == word[j]
                        correct[i] += 1
                    end
                end
            end
            j += 1
        end
        i += 1
    end
    i = 0
    output = []
    while i < correct.length
        if correct[i]/word.length >= 0.75
            output.append(arr[i])
        end
        i += 1
    end
    return output
end
def find_word_main(word, arr)
    arr1 = find_word_v1(word, arr)
    arr2 = find_word_v2(word, arr)
    priority = []
    i = 0
    while i < arr1.length
        j = 0
        while j < arr2.length
            if arr1[i] == arr2[j]
                if not_in_array(arr1[i], priority)
                    priority.append(arr1[i])
                end
            end
            j += 1
        end
        i += 1
    end
    if arr2.length < arr1.length
        arr3 = arr2 + arr1
    else
        arr3 = arr1 + arr2
    end
    i = 0
    while i < arr3.length
        if not_in_array(arr3[i], priority)
            priority.append(arr3[i])
        end
        i += 1
    end
    return priority
end
def similar_letters(word, arr)
    i = 0
    letters = []
    while i < word.length
        if not_in_array(word[i], letters)
            letters.append(word[i])
        end
        i += 1
    end
    i = 0
    arr_letters = []
    while i < arr.length
        j = 0
        arr_letters.append([])
        while j < arr[i].length
            if not_in_array(arr[i][j], arr_letters[i])
                arr_letters[i].append(arr[i][j])
            end
            j += 1
        end
        i += 1
    end
    output = []
    correct = []
    i = 0
    while i < arr.length #Något här
        correct.append(0)
        correct[i] = letters_compare(arr_letters[i], letters)
        i += 1
    end
    i = 0
    p correct
    if word.length >= 4
        while i < correct.length
            if correct[i] >= 0.75
                output.append(arr[i])
            end
            i += 1
        end
    else
        while i < correct.length
            p correct[i] >= 0.67
            if correct[i] >= 0.66
                output.append(arr[i])
            end
            i += 1
        end
    end
    return output
end
def similar_letters_v2(word, arr)
    i = 0
    letters = []
    while i < word.length
        if not_in_array(word[i], letters)
            letters.append(word[i])
        end
        i += 1
    end
    i = 0
    arr_letters = []
    while i < arr.length
        j = 0
        arr_letters.append([])
        while j < arr[i].length
            if not_in_array(arr[i][j], arr_letters[i])
                arr_letters[i].append(arr[i][j])
            end
            j += 1
        end
        i += 1
    end
    i = 0
    output = []
    correct =[]
    while i < arr.length
        correct.append(0)
        correct[i] = letters_compare(letters, arr_letters[i])
        i += 1
    end
    i = 0
    if word.length >= 4
        while i < correct.length
            if correct[i] >= 0.75
                output.append(arr[i])
            end
            i += 1
        end
    else
        while i < correct.length
            if correct[i] > 0.67
                output.append(arr[i])
            end
            i += 1
        end
    end
    return output
end
def spelling(word)
    word = word.downcase
    i = similar_length(word)
    arr = find_word_main(word, i)
    output = similar_letters(word, arr)
    p output
    output = similar_letters_v2(word, output)
    return output
end
p spelling("yallow")