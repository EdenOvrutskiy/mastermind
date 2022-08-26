#rules
#no duplicate colors (in guess or solution)
#no blank colors
require 'pry'

class Color_sequence
  #Guess and Solution's shared template.
  attr_reader :sequence_length, :colors
  def initialize
    @sequence_length = 4
    @colors = [:blue, :red, :yellow, :orange, :green, :purple]
  end
end

class Solution < Color_sequence
  private
  def random_color
    colors.sample
  end
  
  public
  def generate
    array = Array.new
    while array.length < sequence_length do

      unless array.include?(random_color) 
        array.push(random_color)
      end
    end
    array
  end
end

class Guess < Color_sequence
  #gets a guess from the user
  public
  def new_guess
    display_digit_to_color_mapping
    prompt_for_guess
    get_valid_input
    input_into_guess
  end
  
  private
  attr_reader :input
  def valid_input?
    chomped_input = input.chomp
    chomped_input.is_a?(String) &&
      chomped_input.length == sequence_length &&
      is_number(chomped_input)
  end
  
  def is_number(string)
    string == string.to_i.to_s
  end

  def display_digit_to_color_mapping
    puts "each digit corresponds to a color:"
    puts "1 -> blue"
    puts "2 -> red"
    puts "3 -> yellow"
    puts "4 -> orange"
    puts "5 -> green"
    puts "6 -> purple"
  end
  
  def prompt_for_guess
    puts "enter a guess (e.g '1234')"
  end
  
  def digit_to_color(digit)
    colors[digit - 1]
  end

  def strings_to_digits(strings)
    #['1', '2', '3'] -> [1, 2, 3]
    #expects array
    strings.map(&:to_i)
  end

  def digits_to_colors(digits)
    #[1, 2, 3] -> [:blue, :red, :yellow]
    digits.map{|digit| digit_to_color(digit)}
  end

  def input_into_guess
    # "1234" -> [:blue, :red, :yellow, :orange]
    chomped_input = input.chomp
    strings = chomped_input.split('')
    digits = strings_to_digits(strings)
    digits_to_colors(digits)
  end

  def get_valid_input
    #repeatedly asks for input until it's valid
    while true
      @input = gets
      break if valid_input?
      puts "bad input, try again"
    end
  end
end

class Feedback
  #provides feedback for a user's guess

  public

  def generate(guess,solution) #expects 2 arrays
    @guess = guess
    @solution = solution
    display
  end

  def all_correct?
    correct_colors_at_correct_positions.count == solution.length
  end

  private
  attr_reader :guess, :solution

  def correct?(guess_color)
    solution.include?(guess_color)
  end

  def correct_colors
    guess.select{|color| correct?(color)}
  end

  def position_correct?(correct_color)
    solution.index(correct_color) == guess.index(correct_color)
  end

  def correct_colors_at_correct_positions
    correct_colors.select{|c| position_correct?(c)}
  end

  def correct_colors_at_wrong_positions
    correct_colors.reject{|c| position_correct?(c)}
  end
  
  def display
    puts "You've guessed: " +
         "#{correct_colors_at_wrong_positions.count} " +
         "correct colors at the wrong position, " + 
         "and #{correct_colors_at_correct_positions.count} " + 
         "colors in correct positions"
  end

end

class Game
  #creates a game :
  # the users tries to guess a solution while
  # getting feedback.
  private
  attr_reader :current_turn, :feedback, :turn_limit, :solution,
              :guess_generator
  attr_writer :current_turn
  def initialize(solution, guess_generator, feedback)
    @turn_limit = 12
    @current_turn = 0
    @solution = solution
    @guess_generator = guess_generator
    @feedback = feedback
  end

  def display_current_turn
    puts "turn #{current_turn}"
  end

  def increment_turn
    self.current_turn += 1
  end

  def process_a_guess
    feedback.generate(guess_generator.new_guess, solution)
  end

  def game_over?
    feedback.all_correct? || current_turn >= turn_limit
  end

  public  
  def play
    loop do
      increment_turn
      display_current_turn
      process_a_guess
      break if game_over?
    end
  end
end

guess_generator = Guess.new
feedback = Feedback.new
Game.new([:blue, :red, :yellow, :orange], guess_generator, feedback).play

