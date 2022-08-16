#rules
#no duplicate colors (in guess or solution)
#no blank colors


#get user's guess
def get_user_guess
  guess = []
  4.times do
    #one color at a time
    color = gets
    #process user input
    color = color.chomp.to_sym
    #store each color
    guess.push(color)
    guess
  end
end
#compare guess to solution
#is it correct?
# if solution == guess
#   puts "you win"
# end

class Indexed_colors
  attr_reader :guess, :solution, :colors_per
  def initialize
    @guess = [:green, :blue, :yellow, :red]
    @solution = [:green, :blue, :red, :yellow]
    @colors_per = 4
  end

  def is_position_correct?(position)
    solution[position] == guess[position] ? true : false
  end
  
  def count_correct_positions
    #trusts that solution and index have @colors_per items.

    #check how many indexes have the same color in them
    correct_positions = 0
    for position in colors_per.times
      if is_position_correct?(position)
        correct_positions += 1
      end
    end
    correct_positions
  end

    


  def count_wrong_positions
    correct_colors = guess.intersection(solution).count
    correct_positions = self.count_correct_positions
    if correct_colors > correct_positions
      correct_colors - correct_positions
    else
      correct_positions - correct_colors
    end
  end  
end

pair = Indexed_colors.new
p pair.count_wrong_positions
p pair.count_correct_positions


