# Hangman Game
class BlankLines
  attr_accessor :lines

  def initialize(word)
    @lines = '_' * word.length
  end

  def to_s
    @lines
  end

  def []=(num, other)
    @lines[num] = other
  end

  def update_lines(index, word)
    index.each { |num| @lines[num] = word }
  end
end
# Host writes the secret word tracks available letters
class Host
  attr_accessor :secret_word, :alphabets, :blank_lines, :hangman

  def initialize(secret_word)
    @secret_word = secret_word
    @alphabets = ('a'..'z').to_a
    @hangman = Hangman.new
  end

  def draw_blank_lines
    puts @blank_lines = BlankLines.new(secret_word)
  end

  def fill_in_blanks(letter)
    index = secret_word.chars.each_index.select { |i| secret_word[i] == letter }
    blank_lines.update_lines(index, letter)
  end

  def draw_hangman(counter)
    answer = case counter
             when 1 then hangman.head = ' O'

             when 2 then hangman.neck = ' ^'

             when 3 then hangman.left_arm = '/ '

             when 4 then hangman.right_arm = '\\'

             when 5 then hangman.body = ' |'

             when 6 then hangman.left_leg = '/ '

             else
               hangman.right_leg = '\\'
             end
    answer
  end

  def display_alphabets
    puts " REMAINING LETTERS #{alphabets} "
    puts ''
  end
end

# Player class for person making guesses
class Player
  attr_reader :guess

  def guess
    @guess = gets.chomp.to_s.downcase
  end
end

# Class to build and display the hangman
class Hangman
  attr_accessor :display_hangman, :head, :neck, :left_arm,
                :right_arm, :body, :left_leg, :right_leg

  def initialize
    @head = ''
    @neck = ''
    @left_arm = ''
    @right_arm = ''
    @body = ''
    @left_leg = ''
    @right_leg = ''
  end

  def display_hangman
    puts '--------- \n'
    puts ' |'
    puts  head
    puts  neck
    print left_arm
    puts  right_arm
    puts  body
    print left_leg
    puts  right_leg
    puts ''
  end
end

# Hangman game engine
class Game
  attr_reader :host, :player

  def display_welcome_message
    puts " 'Welcome to Tooties Hangman' "
    puts '______________________________'
    puts ''
    puts " 'Host please choose a secret word' "
  end

  def host_choose_secret_word
    secret_word = gets.chomp.to_s.downcase
    @host = Host.new(secret_word)
  end

  def player
    @player = Player.new
  end

  def player_guesses
    guess_counter = 0

    loop do
      puts "Player please guess a #{host.secret_word.size} letter word"
      guess = player.guess
      host.alphabets.delete(guess)

      if host.secret_word.include?(guess)
        host.fill_in_blanks(guess)
        system 'clear'
        host.display_alphabets
        host.hangman.display_hangman
      else
        guess_counter += 1
        host.draw_hangman(guess_counter)
        system 'clear'
        host.display_alphabets
        host.hangman.display_hangman
      end
      puts host.blank_lines

      puts 'You Win!' if host.blank_lines.lines == host.secret_word
      puts 'You Lose!' if guess_counter == 7

      break if host.blank_lines.lines == host.secret_word
      break if guess_counter == 7
    end
  end

  def play
    loop do
      display_welcome_message
      host_choose_secret_word
      system 'clear'
      host.display_alphabets
      host.draw_blank_lines
      player_guesses
      puts "The secret word was '#{host.secret_word}'"

      answer = nil
      loop do
        puts 'Would you like to play again? (y/n)'
        answer = gets.chomp.downcase
        break if %w(y n).include? answer
        puts 'Sorry, must be y or n'
      end

      break unless answer == 'y'
    end
    puts 'Thanks for playing!'
  end
end

Game.new.play
