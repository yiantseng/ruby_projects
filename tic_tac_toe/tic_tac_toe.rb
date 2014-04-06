#Tic Tac Toe with unbeatable AI
#ruby 1.9.3
 
# Keep track of player moves for AI
@player_moves=[]

# Variables to keep track of stats
@player_wins=0
@computer_wins=0
@ties=0

# This function putss out the board that it was passed.
# "board" is a list of 10 strings representing the board, ignoring the index 0)
def print_board(board)   
    puts(' ' + '7' + ' | ' + '8' + ' | ' + '9')
    puts('-----------')
    puts(' ' + '4' + ' | ' + '5' + ' | ' + '6')
    puts('-----------')
    puts(' ' + '1' + ' | ' + '2' + ' | ' + '3')
    puts('')
    puts(' ' + board[7] + ' | ' + board[8] + ' | ' + board[9])
    puts('-----------')
    puts(' ' + board[4] + ' | ' + board[5] + ' | ' + board[6])
    puts('-----------')
    puts(' ' + board[1] + ' | ' + board[2] + ' | ' + board[3])

end

# Let's the player type which letter they want to be.
# Returns a list with the player's letter as the first item, and the computer's letter as the second.
def input_player_letter

    letter = ''

    while not (letter == 'X' or letter == 'O')
        puts 'Do you want to be X or O?'
        letter = gets.chomp.upcase
    # the first element in the list is the player's letter, the second is the computer's letter.
    end

    if letter == 'X'
        return ['X', 'O']
    else
        return ['O', 'X']
    end    
end        

# Randomly choose the player who goes first by picking a random number between 0 and 1.
def who_goes_first()

    if rand()>0.5
        return 'computer'
    else
        return 'player'
    end    
end

# This function returns true if the player wants to play again, otherwise it returns false.
def play_again()
    puts "Do you want to play again? (yes or no)"
    return gets.chomp.downcase.start_with?('y')
end 

# This function sets the move to the current player's letter.
def make_move(board, letter, move)
    board[move] = letter
end

# Given a board and a player's letter, this function returns true if that player has won.
# b=board and l=letter
def is_winner(b,l)   
    return ((b[7] == l and b[8] == l and b[9] == l) or # across the top
    (b[4] == l and b[5] == l and b[6] == l) or # across the middle
    (b[1] == l and b[2] == l and b[3] == l) or # across the bttom
    (b[7] == l and b[4] == l and b[1] == l) or # down the left side
    (b[8] == l and b[5] == l and b[2] == l) or # down the middle
    (b[9] == l and b[6] == l and b[3] == l) or # down the right side
    (b[7] == l and b[5] == l and b[3] == l) or # diagonal
    (b[9] == l and b[5] == l and b[1] == l)) # diagonal
end

# Make a duplicate of the board list and return it the duplicate.
def get_board_copy(board)
    dupe_board = []
    for i in board
        dupe_board.push(i)
    end    
    return dupe_board
end

# Return true if the passed move is free on the passed board.
def is_space_free(board, move) 
    return board[move] == ' '
end

# Let the player type in his move.
def get_player_move(board)
    
    move = ' '
    
    while not '1 2 3 4 5 6 7 8 9'.split.include?(move) or not is_space_free(board, move.to_i) do 
        puts 'What is your next move? (1-9)'
        move = gets.chomp
        if is_space_free(board, move.to_i)
            break
        end
        puts 'The space is already taken!'       
    end 

    @player_moves.push(move.to_i)

    return move.to_i
end

# Returns a valid move from the passed list on the passed board.
# Returns nil if there is no valid move.
def choose_random_move(board, moves_list)
        
    possible_moves = []
    
    for i in moves_list
        if is_space_free(board, i)
            possible_moves.push(i)
        end
    end

    if possible_moves.length != 0
        return possible_moves.sample
    else
        return nil
    end    
end

def get_computer_move(board, computer_letter)
    
    # Given a board and the computer's letter, determine where to move and return that move.
    if computer_letter == 'X'
        player_letter = 'O'
    else
        player_letter = 'X'
    end    

    # Algorithm for Tic Tac Toe AI:
    
    # First: Check if computer can win in the next move
    for i in 1..10
        copy = get_board_copy(board)
        if is_space_free(copy, i)
            make_move(copy, computer_letter, i)
            if is_winner(copy, computer_letter)
                return i
            end
        end
    end            

    # Second: Check if the player could win on his next move, and block them.
    for i in 1..10
        copy = get_board_copy(board)
        if is_space_free(copy, i)
            make_move(copy, player_letter, i)
            if is_winner(copy, player_letter)
                return i
            end
        end        
    end
    # Third: Take the center if it is free.
    if is_space_free(board, 5)
        return 5           
    end

    # Fourth: Check if the player is trying to fork, and block them.                
    if @player_moves.include?(5) and ( @player_moves.include?(1) or @player_moves.include?(3) and @player_moves.include?(7) or @player_moves.include?(9) )
        move=choose_random_move(board, [1, 3, 7, 9])
        if move != nil
            return move
        end
    elsif not (is_space_free(board,9) and is_space_free(board,1)) or not (is_space_free(board,7) and is_space_free(board,3))
        move=choose_random_move(board, [2, 4, 6, 8])
        if move != nil
            return move
        end
    end
   

    # Fifth: Take a corner
    move = choose_random_move(board, [1, 3, 7, 9])
    
    if move != nil
        return move
    end

    # Sixth: Take a side
    move=choose_random_move(board, [2, 4, 6, 8])
    
    return move
end

# Return true if every space on the board has been taken. Otherwise return false.
def is_board_full(board)
    for i in 1..10
        if is_space_free(board, i)
            return false
        end
    end     

    return true
end    

puts 'Welcome to Tic Tac Toe!'
player_letter,computer_letter = input_player_letter

while true
    # Reset the board
    game_board = [' '] * 10
    turn=who_goes_first
    puts 'Computer has won ' + @computer_wins.to_s + ' times'
    puts 'Player has won ' + @player_wins.to_s + ' times'
    puts 'There has been ' + @ties.to_s + ' ties' 
    puts ''
    puts 'The '+turn + ' goes first.'
    game_is_playing = true
    
    while game_is_playing
        if turn == 'player'
            # Player's turn.
            print_board(game_board)
            move = get_player_move(game_board)
            @previous_move=move
            make_move(game_board, player_letter, move)
            if is_winner(game_board, player_letter)
                print_board(game_board)
                puts 'Player wins!'
                @player_wins+=1
                game_is_playing = false
            else
                if is_board_full(game_board)
                    print_board(game_board)
                    puts 'The game is a tie!'
                    @ties+=1
                    break
                else
                    turn = 'computer' 
                end
            end                   
        else
            # Computer's turn.
            move = get_computer_move(game_board, computer_letter)
            make_move(game_board, computer_letter, move)
            if is_winner(game_board, computer_letter)
                print_board(game_board)
                puts 'Computer wins!'
                @computer_wins+=1
                game_is_playing = false
            else
                if is_board_full(game_board)
                    print_board(game_board)
                    puts 'The game is a tie!'
                    @ties+=1
                    break
                else
                    turn = 'player'
                end
            end        
        end            
    end

    if not play_again
        puts 'Thanks for playing!'
        break
    end  
end