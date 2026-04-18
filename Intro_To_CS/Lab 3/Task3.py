def linear_sum(x, result):
    """
    recursive function that returns True if there is a linear combination with x=[-1,0,1] to span the result
    else it returns False
    :param x:
    :param result:
    :return:
    """
    if len(x) == 0:
        return False
    if result == 0:
        return True
    if result != 0:
        return linear_sum(x[1:], result) | linear_sum(x[1:], result - x[0]) | linear_sum(x[1:], result + x[0])


def ordered_subset(str1, str2):
    """
    recursive function that returns True if all str2 letters are in str1 by there original order
    (str2 ordered sub set of str1) and if there is not two linked letters in both of the strings, else returns False.
    :param str1:
    :param str2:
    :return: True or False
    """
    if len(str1) == 0:
        return False
    if len(str2) == 0:
        return True
    # Mission 2
    if len(str1) >= 2 and len(str2) >= 2:
        if (str1[0]+str1[1]) == (str2[0]+str2[1]):
            return False

    if str1[0] == str2[0]:
        return ordered_subset(str1[1:], str2[1:])
    if str1[0] != str2[0]:
        return ordered_subset(str1[1:], str2)


def k_size_rec_subsets(n, k, number_str, i):
    """
    recursive function that add the wanted strings to the list.
    :param n:
    :param k:
    :param number_str:
    :param i:
    :return: list of strings
    """
    if k > n or n < 1 or n > 9 or k < 0:
        raise TypeError("One or more of the inputs are illegal")
    if k == 0:
        return [number_str]
    if i == n+1:
        return []
    if i == n:
        return k_size_rec_subsets(n, k-1, number_str + str(i), i + 1)
    if i <= n:
        return k_size_rec_subsets(n, k, number_str, i + 1) + k_size_rec_subsets(n, k-1, number_str + str(i), i+1)


def k_size_subsets(n, k):
    """
    Function that get number n (1<=n<=9) and number k (1<=k<=n) and return a list of strings like so that each string is
    in size (length) of k and instructed by numbers from 1 to n include, each number appears once in a string. At the
    same string the numbers are by size. to build the list the function uses the recursive function k_size_rec_subsets.
    :param n:
    :param k:
    :return:list of strings according to instructions
    """
    return k_size_rec_subsets(n, k, '', 1)


def dict_rec_depth(d):
    """
    Function that get a dictionary and returns the max depth of nested dictionary. It works by creating a list of all
    the values in the current dictionary and then go over this list with  a "for" loop and check by recursion
    if there is a values inside the list that is dictionary type. Each time we want to check if the current depth
    is grater then the last one, for that we use an integer called max depth. lastly we return that max depth after we
    finished go over the original dictionary.
    :param d:
    :return: max depth of nested dictionary
    """
    max_depth = 0
    value_list = list(d.values())
    for i in range(len(value_list)):
        if type(value_list[i]) is dict:
            dict_depth = dict_rec_depth(value_list[i]) + 1
            if dict_depth > max_depth:
                max_depth = dict_depth
    return max_depth


def dict_depth(d):
    """
    function that get an input and check if it's dictionary, if it isn't it returns TypeError and print message
    otherwise the function calls a recursive function called dict_rec_depth that return the nested depth of the
    dictionary.
    :param d:
    :return: number of nested dictionary or an TypeError with a message.
    """
    if type(d) is not dict:
        raise TypeError("d is not a dictionary type")
    return dict_rec_depth(d)


def nested_rec_get(d, key, values_of_this_key):
    """
    Function that get a dictionary, key and empty list( at the beginning), if any value of this dictionary is a value
    of the key (and not a dictionary himself) it adds hi, to the list.
    :param d:
    :param key:
    :param values_of_this_key:
    :return: list of all values for the specif key that are not dictionary themselves.
    """
    value_list = list(d.values())
    key_list = list(d.keys())
    for i in range(len(value_list)):
        if key_list[i] == key and type(value_list[i]) is not dict:
            values_of_this_key.append(value_list[i])
        if type(value_list[i]) is dict:
            nested_rec_get(value_list[i], key, values_of_this_key)
    return values_of_this_key


def nested_get(d, key):
    """
    Function that get a dictionary and a key' if the dictionary is not dict type it returns a proper message,
    else it creates an empty list and call the recursive function nested_rec_get.
    :param d:
    :param key:
    :return: list of all values for the specif key that are not dictionary themselves.
    """
    if type(d) is not dict:
        raise TypeError("d is not a dictionary type")
    values_of_this_key = []
    return nested_rec_get(d, key, values_of_this_key)


def distance(row1, col1, row2, col2):
    """
    Function that get 2 squares on the board and calculate the distance between the two bo steps of 1 square.
    :param row1:
    :param col1:
    :param row2:
    :param col2:
    :return: distance between two squares
    """
    dist_x = 0
    dist_y = 0
    if row1 - row2 > 0:
        dist_y = row1 - row2
    else:
        dist_y = row2 - row1
    if col1 - col2 >= 0:
        dist_x = col1 - col2
    else:
        dist_x = col2 - col1
    return dist_x + dist_y


# print(distance(5, 5, 4, 2))


def add_tower(board, d, row, col):
    """
    Function that get a board, square on the board to build on and the minimum distance required to the other towers
    in rows above. If possible the function update the board with the new tower and returns True, otherwise return False
    :param board:
    :param d:
    :param row:
    :param col:
    :return:If possible the function update the board with the new tower and returns True, otherwise return False
    """
    for i in range(row):
        if d >= distance(row, col, i, board[i]):
            return False
    board[row] = col
    return True


# board = [0, 3, 5, 1, 0, 0]
# print(add_tower(board, 2, 3, 1))


def n_rec_towers(board, n, d, row, col):
    """
    Function that get n*n board and place towers, it runs recursively on the rows, if it's possible it adds a tower
    to the current place, otherwise it promote the column index until it is possible to build the tower.
    If there is no more columns in the board the function returns an empty board. After placing the tower
    (if it possible) go to the next row and equate to zero the column index.
    :param board:
    :param n:
    :param d:
    :param row:
    :param col:
    :return: board
    """
    if row == n:
        return board
    if col == n:
        return []
    if add_tower(board, d, row, col) and n_rec_towers(board, n, d, row+1, 0):
        return board
    return n_rec_towers(board, n, d, row, col + 1)


def n_towers(n, d):
    """
    Function that set initial board by build_initial_board, the function change the towers positions by using
    isit_possible_to_build function.
    :param n:
    :param d:
    :return: built board by instructions
    """
    empty_board = build_initial_board([], n, 0)
    return isit_possible_to_build(empty_board, n, d, 0)
    # Do not touch: return n_rec_towers(empty_board, n, d, 0, 0)


def build_initial_board(board, n, index):
    """
    Function that build recursively initial board, all towers placed in each row in 0 column
    :param board:
    :param n:
    :param index:
    :return: initial board
    """
    if index == n:
        return board
    board.append(0)
    return build_initial_board(board, n, index+1)


def isit_possible_to_build(board, n, d, col_index):
    """
    Recursive function that checks if it is possible to build a board by using n_rec_towers function.
    If there is a board exist the function will return it, otherwise it returns an empty board: []
    :param board:
    :param n:
    :param d:
    :param col_index:
    :return: If there is a board it returns the board otherwise it returns an empty board: []
    """
    if col_index == n:
        return []
    built_board = n_rec_towers(board, n, d, 0, col_index)
    if built_board:
        return built_board
    return isit_possible_to_build(board, n, d, col_index+1)

