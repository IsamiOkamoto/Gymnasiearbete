require 'sqlite3'
#separera orden som användaren skrev in och de som datorn gav
def sqlite_to_arr()
    db = SQLite3::Database.new("C:/Users/isami.okamotogustaf/Documents/GitHub/Gymnasiearbete/db/data.db")
    result = db.execute("SELECT * FROM rounds")
    return result
end
def arr_to_txt()
    arr = sqlite_to_arr()
    x = File.open("arr.txt", "w")
    arr.each do |arr|
        i = 0
        stri = ""
        while i < arr[0].length

            #p arr[0][i]
            if arr[0][i] != ","
                
                stri += arr[0][i]
            else
                stri += " "
                
            end
            #p stri
            i += 1
        end
        x.write("#{stri}\n")
    end
end
def arr_to_txt_2()
    arr = sqlite_to_arr()
    x = File.open("arr2.txt", "w")
    arr.each do |arr|
        i = 0
        j = 0
        stri = ""
        while i < arr[0].length

            #p arr[0][i]
            if arr[0][i] != ","
                if j%2==0
                    stri += arr[0][i]
                end
            else
                stri += " "
                j += 1
            end
            #p stri
            i += 1
        end
        x.write("#{stri}\n")
    end
end
def testing()
    arr = sqlite_to_arr()
    arr.each do |arr|
        p arr[0]
    end
end
def how_end()
    arr = sqlite_to_arr()
    x = File.open("end.txt", "w")
    arr.each do |arr|
        x.write("#{arr[2]}\n")
    end
end
def spelling()
    arr = sqlite_to_arr()
    x = File.open("spelling.txt", "w")
    arr.each do |arr|
        i = 0
        stri = ""
        while i < arr[1].length
            if arr[1][i] != ","
                stri += arr[1][i]
            elsif arr[1][i] == "," and arr[1][i - 1] != ","
                stri += " "
            end
            i += 1
        end
        x.write("#{stri}\n")
    end
end
def players()
    arr = sqlite_to_arr()
    x = File.open("players.txt", "w")
    arr.each do |arr|
        x.write("#{arr[3]}\n")
    end
end
def count_words()
    arr = sqlite_to_arr()
    n = 0
    arr.each do |arr|
        i = 0
        while i < arr[0].length
            if arr[0][i] == ","
                n += 1
            end
            i += 1
        end
    end
    return n + arr.length
end
def in_array(word, arr)
    i = 0
    while i < arr.length
        if word == arr[i][0]
            return true
        end

        i += 1
    end
    return false
end
def in_array2(word, arr)
    i = 0
    while i < arr.length
        if word == arr[i]
            return true
        end

        i += 1
    end
    return false
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
def precentage()
    arr = sqlite_to_arr()
    db = SQLite3::Database.new("C:/Users/isami.okamotogustaf/Documents/GitHub/Gymnasiearbete/db/data.db")
    arr2 = db.execute("SELECT word FROM words")
    neww = []
    arr.each do |arr|
        i = 0
        j = 0
        stri = ""
        while i < arr[0].length
            if arr[0][i] != ","
                if j%2==0
                    stri += arr[0][i]
                end
            else
                if stri != ""
                    neww.append(stri)
                end
                stri = ""
                j += 1
            end
            #p stri
            i += 1
        end
    end
    n = 0
    neww.each do |word|
        #p not_in_array(word, arr2)
        if in_array(word, arr2)
            n += 1
        end
    end
    return n/neww.length.to_f
end
def count_in_array(word, arr)
    i = 0
    n = 0
    while i < arr.length
        if word == arr[i]
            n += 1
        end
        i += 1
    end
    return n
end
def most_common_word()
    arr = sqlite_to_arr()
    neww = []
    arr.each do |arr|
        i = 0
        j = 0
        stri = ""
        while i < arr[0].length
            if arr[0][i] != ","
                if j%2==0
                    stri += arr[0][i]
                end
            else
                if stri != ""
                    neww.append(stri)
                end
                stri = ""
                j += 1
            end
            #p stri
            i += 1
        end
    end
    out = []
    neww.each do |word|

        out.append(count_in_array(word, neww))
    end
    j = 7
    output = []
    x = File.open("table.txt", "w")
    while j > 0
        i = 0
        while i < out.length
            if out[i] == j and not_in_array([neww[i], out[i]], output)
                output.append([neww[i], out[i]])
                x.write("#{neww[i]}, #{out[i]}\n")
            end
            i += 1
        end
        j -= 1
    end
    return output
end
def user_word_count()
    arr = most_common_word()
    n = 0
    i = 0
    while i < arr.length
        n += arr[i][1].to_i
        i += 1
    end
    return n
end
def most_common_word_all()
    arr = sqlite_to_arr()
    neww = []
    arr.each do |arr|
        i = 0
        j = 0
        stri = ""
        while i < arr[0].length
            if arr[0][i] != ","
                stri += arr[0][i]
            else
                if stri != ""
                    neww.append(stri)
                end
                stri = ""
                j += 1
            end
            #p stri
            i += 1
        end
    end
    out = []
    neww.each do |word|
        out.append(count_in_array(word, neww))
    end
    j = 7
    output = []
    x = File.open("table2.txt", "w")
    while j > 0
        i = 0
        while i < out.length
            if out[i] == j and not_in_array([neww[i], out[i]], output)
                output.append([neww[i], out[i]])
                x.write("#{neww[i]}, #{out[i]}\n")
            end
            i += 1
        end
        j -= 1
    end
    return output
end
def all_valied_words()
    db = SQLite3::Database.new("C:/Users/isami.okamotogustaf/Documents/GitHub/Gymnasiearbete/db/data.db")
    arr = db.execute("SELECT word FROM words")
    arr2 = []
    arr.each do |words|
        arr2.append(words[0])
    end
    arr3 = db.execute("SELECT Used_words FROM rounds")
    arr4 = []
    arr3.each do |arrray|
        i = 0
        j = 0
        str = ""
        while i < arrray[0].length
            if arrray[0][i] != ","
                if j%2 == 0
                    str += arrray[0][i]
                end
            else
                if str != ""
                    arr4.append(str)
                end
                str = ""
                j += 1
            end
            i += 1
        end
    end
    out = []

    arr4.each do |word|
        if in_array2(word, arr2)
            out.append(word)
        end
    end
    return out

end
def count_words_valied()
    arr = all_valied_words()
    x = File.open("table3.txt","w")
    out = []
    arr.each do |word|
        out.append(count_in_array(word, arr))
    end
    j = 7
    output = []
    while j > 0
        i = 0
        while i < out.length
            if out[i] == j and not_in_array([arr[i], out[i]], output)
                output.append([arr[i], out[i]])
                x.write("#{arr[i]}, #{out[i]}\n")
            end
            i += 1
        end
        j -= 1
    end
    return output
end
def medelvarde_all()
    db = SQLite3::Database.new("C:/Users/isami.okamotogustaf/Documents/GitHub/Gymnasiearbete/db/data.db")
    arr = db.execute("SELECT word FROM words")
    arr2 = []
    arr.each do |words|
        arr2.append(words[0])
    end
    n = 0
    arr2.each do |word|
        n += word.length
    end
    return n/arr2.length.to_f
end
def word_list()
    db = SQLite3::Database.new("C:/Users/isami.okamotogustaf/Documents/GitHub/Gymnasiearbete/db/data.db")
    arr = db.execute("SELECT word FROM words")
    arr2 = []
    arr.each do |words|
        arr2.append(words[0])
    end
    return arr2
end
def medelvarde_all_used()
    db = SQLite3::Database.new("C:/Users/isami.okamotogustaf/Documents/GitHub/Gymnasiearbete/db/data.db")
    arr = db.execute("SELECT Used_words FROM rounds")
    arr2 = []
    arr.each do |arrray|
        i = 0
        str = ""
        while i < arrray[0].length
            if arrray[0][i] != ","
                str += arrray[0][i]
            else
                if str != ""
                    arr2.append(str)
                end
                str = ""
            end
            i += 1
        end
    end
    arr2.append("ephyra")
    n = 0
    arr2.each do |word|
        n += word.length
    end
    return n/arr2.length.to_f
end
def medelvarde_all_used_valied()
    arr = all_valied_words()
    n = 0
    arr.each do |word|
        n += word.length
    end
    return n/arr.length.to_f
end
def sql_to_arr_2()
    arr = sqlite_to_arr()
    arr2 = []
    arr.each do |arr1|
        arr2.append(arr1[0])
    end
    return arr2
end
def arr_to_txt_3()
    valied = word_list()
    arr = sql_to_arr_2()
    x = File.open("arr3.txt", "w")
    arr.each do |strr|
        out = ""
        str = ""
        i = 0
        while i < strr.length
            if strr[i] != ","
                str += strr[i]
            else
                if in_array2(str, valied)
                    out += "#{str}  "
                else
                    out += "(ogiltigt ord)  "
                end
                str = ""
            end
            i += 1
        end
        x.write("#{out}\n")
    end
end
def arr_to_txt_4()
    valied = word_list()
    arr = sql_to_arr_2()
    x = File.open("arr4.txt", "w")
    arr.each do |strr|
        out = ""
        str = ""
        i = 0
        j = 0
        while i < strr.length
            if strr[i] != ","
                str += strr[i]
            else
                if j%2 == 0
                    if in_array2(str, valied)
                        out += "#{str}  "
                    else
                        out += "(ogiltigt ord)  "
                    end
                end
                str = ""
                j += 1
            end
            i += 1
        end
        x.write("#{out}\n")
    end
end
#arr_to_txt_4()
#arr_to_txt_3()
#medelvarde_all_used_valied()
#medelvarde_all_used()
#medelvarde_all()
#count_words_valied()
#all_valied_words()
#players()
#arr_to_txt()
#arr_to_txt_2()
#testing()
#how_end()
#spelling()
#count_words()
#precentage()
#most_common_word() # 7 is the highest
#most_common_word_all()
#user_word_count()
#favor towrads shorter words