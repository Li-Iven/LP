with open ('three.ged', 'r', encoding="utf-8") as file:
    dict_names = {}
    dict_sex = {}
    familys = []
    for line in file:
        info = line.replace('\n','')
        
        if info.find("NAME")>0 and info.find("Herit")<0 and info.find("NAME  //")<0:
            info = info.replace("/","").rstrip()
            #Транслитерация
            info = info.replace('А', 'A').replace('Б', 'B').replace('В', 'V').replace('Г', 'G').replace('Д', 'D')
            info = info.replace('Е', 'E').replace('Ё', 'Yo').replace('Ж', 'Zh').replace('З', 'Z').replace('И', 'I')
            info = info.replace('Й', 'I').replace('К', 'K').replace('Л', 'L').replace('М', 'M').replace('Н', 'N')
            info = info.replace('О', 'O').replace('П', 'P').replace('Р', 'R').replace('С', 'S').replace('Т', 'T')
            info = info.replace('У', 'U').replace('Ф', 'F').replace('Х', 'Kh').replace('Ц', 'Ts').replace('Ч', 'Ch')
            info = info.replace('Ш', 'Sh').replace('Щ', 'Shch').replace('Ы', 'Y').replace('Ъ', 'Ie').replace('Ь', "")
            info = info.replace('Э', 'e').replace('Ю', 'Iu').replace('Я', 'Ia')
            info = info.replace('а', 'a').replace('б', 'b').replace('в', 'v').replace('г', 'g').replace('д', 'd')
            info = info.replace('е', 'e').replace('ё', 'yo').replace('ж', 'zh').replace('з', 'z').replace('и', 'i')
            info = info.replace('й', 'i').replace('к', 'k').replace('л', 'l').replace('м', 'm').replace('н', 'n')
            info = info.replace('о', 'o').replace('п', 'p').replace('р', 'r').replace('с', 's').replace('т', 't')
            info = info.replace('у', 'u').replace('ф', 'f').replace('х', 'kh').replace('ц', 'ts').replace('ч', 'ch')
            info = info.replace('ш', 'sh').replace('щ', 'shch').replace('ы', 'y').replace('ъ', 'ie').replace('ь', "")
            info = info.replace('э', 'e').replace('ю', 'iu').replace('я', 'ia')
            #
            x = info[7:]
        if info.find("SEX")>0:
            info.rstrip()
            y = info[6:]
        if info.find("RIN MH:I")>0:
            info.rstrip()
            z = info[10:]
            dict_names[z]=x
            dict_sex[z]=y
            
        if info.find("HUSB")>0:
            info.rstrip()
            hus = info[9:len(info)-1]
        if info.find("WIFE")>0:
            info.rstrip()
            wife = info[9:len(info)-1]
        if info.find("CHIL")>0:
            info.rstrip()
            child = info[9:len(info)-1]
            if (len(hus)>0):
                familys.append([dict_names[hus],dict_names[child]])
            if (len(wife)>0):
                familys.append([dict_names[wife],dict_names[child]])
        if info.find("RIN MH:F")>0:
            hus=""
            wife=""

    f = open('three.pl', 'w')
    for i in dict_sex:
        f.write("sex('"+dict_names[i]+"', '"+dict_sex[i]+"').\n")

    for i in familys:
        f.write("parent('"+i[0]+"', '"+i[1]+"').\n")   
    f.close()

file.close()
            
