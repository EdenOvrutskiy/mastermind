#rules
#no duplicate colors (in guess or solution)
#no blank colors

class Guess
  #gets a guess from the user
  private
  attr_reader :length
  def initialize
    @length = 4
    @guess = get_guess
  end

  def get_color
    begin
      def prompt_for_color
        puts "select a color by entering its' corresponding digit:"
        puts "1 -> blue"
        puts "2 -> red"
        puts "3 -> yellow"
        puts "4 -> orange"
        puts "5 -> green"
        puts "6 -> purple"
        puts "enter a digit: "
      end
      prompt_for_color
      input = gets
      digit = input.chomp.to_i
      color = number_to_color(digit)
      puts "you have selected: #{color}"
      color
    rescue
      puts "bad input, try again"
    end
  end

  def number_to_color(number)
    case number
    when 1 then :blue
    when 2 then :red
    when 3 then :yellow
    when 4 then :orange
    when 5 then :green
    when 6 then :purple
    else
      nil
    end
  end

  public
  attr_reader :guess
  def get_guess
    puts "Input a guess (4 inputs, 1 per color):"
    guess = []
    while guess.length < length
      color = get_color
      guess.push(color) if color
    end
    guess
  end
end



class Feedback
  #provides feedback for a user's guess
  private
  attr_reader :guess, :solution
  def initialize(guess,solution)
    @solution = solution
    @guess = guess
  end

  Color_pair = Struct.new(:guess, :solution) do
    def same?
      guess == solution
    end
  end

  
  def create_color_pair(index)
    #creates a pair of colors from a guess+solution 
    #that share the same position.
    Color_pair.new(guess[index], solution[index]) 
  end

  def color_pairs
    #returns an iterable with all color pairs
    #(trusts that guess and solution have the same length)
    Array.new(solution.length)
      .map
      .with_index {|redundant,i| create_color_pair(i)}
  end
  
  public
  def count_correct_positions
    #how many colors are correct + at the correct position?
    color_pairs
      .select{|pair| pair.same?}
      .count
  end

  def count_correct_colors
    guess.intersection(solution).count
  end
  
  def count_correct_colors_at_wrong_positions
    (count_correct_colors - count_correct_positions).abs
  end

  def display
    puts "You've guessed: #{count_correct_positions} " +
         "correct positions, " + 
         "and #{count_correct_colors_at_wrong_positions} " + 
         "colors in wrong positions"
  end

  def all_correct?
    count_correct_positions == solution.length
  end

  def view_solution
    puts solution
  end
end


class Game
  private
  attr_reader :current_turn, :feedback, :turn_limit, :solution
  attr_writer :current_turn
  def initialize(solution)
    @turn_limit = 12
    @current_turn = 0
    @solution = solution
  end

  def display_current_turn
    puts "turn #{current_turn}"
  end

  def increment_turn
    self.current_turn += 1
  end

  def process_guess
    @feedback = Feedback.new(Guess.new.guess, solution)
    feedback.display
  end

  def game_over?
    (feedback.all_correct?) || (current_turn == turn_limit)
  end

  public  
  def play
    loop do
      increment_turn
      display_current_turn
      process_guess
      break if game_over?
    end
  end
end

def random_color
  [:blue, :red, :yellow, :orange, :green, :purple].sample
end

def generate_solution
  array = Array.new
  while array.length < 4 do
    color = random_color
    unless array.include?(color) 
      array.push(color)
    end
  end
  array
end

solution = generate_solution
  
Game.new(solution).play

