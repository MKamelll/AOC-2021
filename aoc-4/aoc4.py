def get_order(arr):
    return [int(i) for i in arr[0].strip("\n").split(",")]


def drop_order(arr):
    return arr[2:]


def split_into_boards(arr, boards=None):
    if not boards: boards = []
    if "\n" not in arr:
        index = -1
    else:
        index = arr.index("\n")

    if len(arr) < 1 or index == -1:
        boards.append(arr)
        return boards
    
    boards.append(arr[:index])
    return split_into_boards(arr[index+1:], boards)    


def get_board(board_raw):
    board = [[(int(j), False) for j in i.split()] for i in board_raw]
    return board


def mark_board(board, num):
    for i in range(len(board)):
        for j in range(len(board[i])):
            if board[i][j][0] == num:
                board[i][j] = (board[i][j][0], True)
                break
    return board


def is_row_complete(board, row_len=5):
    for i in board:
        count = len(list(filter(lambda x: x[1] == True, i)))
        if count == row_len:
            return True
    return False


def is_col_complete(board, col_len=5):
    for i in range(col_len):
        count = len(list(filter(lambda row: row[i][1] == True, board)))
        if count == col_len:
            return True
    return False


def unmarked_sum(wining_board):
    unmarked = []
    for i in wining_board:
        unmarked += list(map(lambda x: x[0], filter(lambda x: x[1] == False, i)))

    return sum(unmarked)


def score(wining_board, last_matched):
    return unmarked_sum(wining_board) * last_matched


def bingo(board):
    return is_row_complete(board) or is_col_complete(board)


def part_one(boards, order):
    for num in order:
        marked_boards = [mark_board(board, num) for board in boards]
        
        for m_board in marked_boards:
            if bingo(m_board):
                return score(m_board, num)


def part_two(boards, order):
    last_num = -1
    won_boards = []
    
    for num in order:
        
        if len(won_boards) == len(boards): break
        
        marked_boards = [mark_board(board, num) for board in boards]
        
        for m_board in marked_boards:
            if bingo(m_board) and m_board not in won_boards:
                won_boards.append(m_board)
                last_num = num    
    
    return score(won_boards[-1], last_num)


def main(filename):
    data = []
    with open(f"{filename}.txt") as f:
        for line in f:
            if len(line) > 1:
                data += [line.strip("\n").strip(" ")]
            else:
                data += [line]

    order = get_order(data)
    data = drop_order(data)
    boards_raw = split_into_boards(data)
    boards = [get_board(i) for i in boards_raw]
    
    #print(part_one(boards, order))
    print(part_two(boards, order))

if __name__ == "__main__":
    main("input")