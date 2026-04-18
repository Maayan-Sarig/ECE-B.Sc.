# Task 1
num = input()
if num == '1a':
    # write your answer for question 1a below
    
    a = int(input())
    b = int(input())
    c = int(input())
    if 0 < a <= b <= c:
        if (a**2 + b**2 == c**2):
            print("yes")
        else:
            print("no")
    else:
        print("no")
        
elif num == '1b':
    # write your answer for question 1b below
    
    top_Num = int(input())
    for i in range(1, top_Num + 1):
        for j in range(i, top_Num + 1):
            for k in range(j, top_Num + 1):
                if i**2 + j**2 == k**2:
                    print(i, j, k)
                
elif num == '1c':
    # write your answer for question 1c below

    first_num = int(input())
    second_num = int(input())
    third_num = (first_num**2 + second_num**2)**0.5
    if third_num % 1 == 0:
        print("yes")
    else:
        print("no")
        
elif num == '2a':
    # write your answer for question 2a below

    factorial = 1
    a0 = int(input())
    n = int(input())
    d = int(input())
    for i in range(a0, n + 1):
        if i % d == 0:
            factorial *= i
    print(factorial)
    
elif num == '2b':
    # write your answer for question 2b below

    factorial = 1
    n = int(input())
    m = int(input())
    for i in range(1, n+1):
        if i <= n-i+1 and (i**2 + (n-i+1)**2) % m == 0:
            factorial *= (i**2 + (n-i+1)**2)
    print(factorial)
    
elif num == '2c':
    # write your answer for question 2c below
    
    factorial = 1
    n = int(input())
    m = int(input())
    integer_factor = []
    if n == 0 or n == 1:
        print(factorial)
    else:
        for i in range(2, int(n**0.5)):
            while n % i == 0:
                integer_factor.append(i)
                n = n / i
        place_to_start = 0
        while place_to_start < len(integer_factor):
            counter = 1
            for j in range(place_to_start + 1, len(integer_factor)):
                if integer_factor[place_to_start] == integer_factor[j]:
                    counter += 1
            if counter % m == 0:
                factorial *= integer_factor[place_to_start]**counter
            else:
                factorial *= integer_factor[place_to_start]*counter
            place_to_start += counter
        print(factorial)
    
elif num == '3':
    # write your answer for question 3 below

    a = int(input())
    b = int(input())
    c = b/a
    flag = True
    for i in range(2, a):
        if a % i == 0 and c % i == 0:
            flag = False
            break
    if flag:
        print("True")
    else:
        print("False")

elif num == '4a':
    # write your answer for question 4a below
    
    original_str = input()
    d = int(input())
    new_str = ""
    for i in range(len(original_str)):
        if (i + 1) % d != 0:
            new_str += original_str[i]
    print(new_str)

elif num == '4b':
    # write your answer for question 4b below
    
    str1 = input()
    str2 = input()
    str3 = input()
    new_str1 = ""
    for i in range(len(str1)):
        if i == 0:
            if str1[i+1] not in str3 or str1[i] not in str2:
                new_str1 += str1[i]
        elif i == len(str1):
            if str1[i-1] not in str3 or str1[i] not in str2:
                new_str1 += str1[i]
        else:
            if str1[i-1] not in str3 and str1[i+1] not in str3 or str1[i] not in str2:
                new_str1 += str1[i]
    print(new_str1)
    
elif num == '4c':
    # write your answer for question 4c below
    
    st = input()
    st_after_a = ""
    list_of_wards_a = st.split(", ")
    sound_letter = "aeiouAEIOU"
    for i in range(len(list_of_wards_a)):
        ward = ""
        for j in list_of_wards_a[i]:
            if j in sound_letter:
                ward += "*" + j + "*"
            else:
                ward += j
        list_of_wards_a[i] = ward
    list_of_wards_b = []
    for ward in list_of_wards_a:
        new_ward = ""
        flag = False
        for j in ward:
            if j != '*' and j != ' ':
                if flag:
                    new_ward += j.upper()
                else:
                    new_ward += j.lower()
            elif j == "*":
                new_ward += j
            else:
                new_ward += j
                flag = not flag
        list_of_wards_b.append(new_ward)
    for i in range(len(list_of_wards_b)):
        list_of_wards_b[i] = list_of_wards_b[i].split()
    for ward in list_of_wards_b:
        ward.sort(reverse=True)
    list_of_wards_b.sort(key=len)
    st_after_d = ""
    for ward in list_of_wards_b:
        st_after_d += " ".join(ward)
        st_after_d += ", "
    st_after_d = st_after_d[:-2]
    print(st_after_d)

else:
    print('error')
