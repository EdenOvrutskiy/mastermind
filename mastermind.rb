#rules
#no duplicate colors (in guess or solution)
#no blank colors

class Guess
  #gets a guess from the user
  attr_reader :length, :guess
  private
  def initialize
    @length = 4
    @guess = get_guess
  end

  def get_color
    begin
      puts "enter a color: "
      input = gets
      color = input.chomp.to_sym
    rescue
      puts "bad input, try again"
    end
  end
  
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
  @@solution = [:green, :blue, :red, :yellow]
  def initialize(guess)
    @guess = guess
  end

  Color_pair = Struct.new(:guess, :solution) do
    def same?
      guess == solution
    end
  end
  
  def create_color_pair(index)
    #creates a pair of colors from guess,solution at
    #the same position.
    Color_pair.new(guess[index], self.solution[index]) 
  end

  def color_pairs
    #returns an iterable with all color pairs
    #(trusts that guess and self.solution have the same length)
    Array.new(self.solution.length)
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
    guess.intersection(self.solution).count
  end
  
  def count_correct_colors_at_wrong_positions
    (count_correct_colors - count_correct_positions).abs
  end  
end


p Feedback.new(Guess.new.guess)


