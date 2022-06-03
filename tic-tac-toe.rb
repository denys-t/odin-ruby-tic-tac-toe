class Player
  attr_reader :name, :type

  def initialize(name, type)
    @name = name
    @type = type
  end

  def move(board)
    done = false
    until done
      puts 'Enter position as {ROW,COL} without brackets and with no space after comma. Both ROW and COL are inside the interval 1-3.'
      position = gets.chomp.split(',')

      if position[0].to_i.between?(1, 3) && position[1].to_i.between?(1, 3)
        done = board.set(position, @type)
      else
        puts 'Wrong position. Try again'
      end
    end
  end
end

class Board
  attr_reader :content

  def initialize
    @content = Array.new(3){Array.new(3, 7)}
  end

  def set(position, type)
    curr_val = @content[position[0].to_i - 1][position[1].to_i - 1]
    if curr_val == 7
      @content[position[0].to_i - 1][position[1].to_i - 1] = type == 'X' ? 1 : 0
      return true
    else
      puts 'This space is already used, try another'
      return false
    end
  end

  def show
    @content.each do |row|
      puts row.map { |e|
        case e
        when 1
          ' X '
        when 0
          ' O '
        else
          '   '
        end
      }.join('|')
    end
  end
end

class Game
  def initialize
    p1 = create_player(1)
    p2 = create_player(2)
    board = Board.new

    continue(p1, p2, board)
  end

  private

  def create_player(n)
    puts "Enter name for Player #{n}"
    name = gets.chomp

    type = n == 1 ? 'X' : 'O'
    Player.new(name, type)
  end

  def continue(player1, player2, board)
    while true
      player1.move(board)
      board.show
      break if end_game?(player1, board)

      player2.move(board)
      board.show
      break if end_game?(player2, board)
    end
  end

  def end_game?(player, board)
    # checking rows
    for i in 0..2 do
      sum = board.content[i][0]

      for j in 1..2 do
        sum += board.content[i][j]
      end

      if sum == 0 || sum == 3
        victory(player)
        return true
      end
    end

    # checking cols
    for i in 0..2 do
      sum = board.content[0][i]

      for j in 1..2 do
        sum += board.content[j][i]
      end

      if sum == 0 || sum == 3
        victory(player)
        return true
      end
    end

    # checking diagonals
    sum = board.content[0][0] + board.content[1][1] + board.content[2][2]
    if sum == 0 || sum == 3
      victory(player)
      return true
    end

    sum = board.content[2][0] + board.content[1][1] + board.content[0][2]
    if sum == 0 || sum == 3
      victory(player)
      return true
    end

    return false
  end

  def victory(player)
    puts "#{player.name} won! Congrats!"
  end
end