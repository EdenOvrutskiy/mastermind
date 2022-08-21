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
  def initialize(guess)
    @solution = [:green, :blue, :red, :yellow]
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
end


#new class/method to take lower-level responsibilities away
#from Feedback.

#compare two arrays, find out:
#unique instances of members that appear in both

array1 = [1, 2, 3]
array2 = [2, 1, 3]
#expecting: 1,2,3 in common, 3 in same spot
#

def does_number_show_up_in_array(num, array)
  array.include?(num)
end

def find_shared_members_without_duplicates(array1, array2)
  array1 & array2
end

def find_indexes_with_same_content(array1, array2)
  array1
    .each_index
    .select{|i| array1[i] == array2[i]}
end

p find_shared_members_without_duplicates(array1, array2)
p find_indexes_with_same_content(array1, array2)

#Feedback.new([:green, :blue, :yellow, :red]).count_correct_positions

