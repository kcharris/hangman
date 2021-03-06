module Hangman
  class Game
    def initialize
      @dictionary_array = []
      dictionary_file = File.open("5desk.txt", "r")
      @dictionary_array = dictionary_file.readlines
      @dictionary_size = @dictionary_array.length
      self.new_game
    end

    def new_game
      @word_to_guess = @dictionary_array[rand(@dictionary_size)]
      @word_to_guess = @word_to_guess[/[a-zA-Z]+/].downcase
      @answer_board = "_" * @word_to_guess.length
      @guessed_letters = ""
      @guesses_left = 8
      puts "Starting new game \n"
    end

    def game_prompt
      puts "Guesses left: #{@guesses_left} Guessed letters: #{@guessed_letters}"
      puts @answer_board
      puts "Enter a letter. Type save to save or load to load"
    end

    def input_processor(player_choice)
      if player_choice =~ /^[a-zA-Z]$/
        if (@word_to_guess.include? (player_choice.downcase)) && !(@answer_board.include? (player_choice.downcase))
          @word_to_guess.split("").each_with_index do |letter, index|
            if letter == player_choice.downcase
              @answer_board[index] = letter
            end
          end
          if @answer_board == @word_to_guess
            puts "You guessed #{@word_to_guess} correctly!\n"
            self.new_game
          end
        else
          if !(@guessed_letters.include? (player_choice.downcase)) && !(@answer_board.include? (player_choice.downcase))
            @guessed_letters += player_choice
            @guesses_left -= 1
            if @guesses_left == -1
              puts "You lose, the word was #{@word_to_guess}"
              self.new_game
            end
          end
        end
      elsif player_choice == "save"
        self.save
      elsif player_choice == "load"
        self.load
      end
    end

    def save
      puts "saved"
      @save_file = File.open("save_file.txt", "w")
      @save_file.write([@word_to_guess, @guesses_left, @guessed_letters, @answer_board].join("\n"))
      @save_file.close
    end

    def load
      puts "loaded"
      @save_file = File.open("save_file.txt", "r")
      save_array = @save_file.readlines
      @save_file.rewind
      @save_file.close
      if save_array.length > 0
        @word_to_guess = save_array[0].chomp
        @guesses_left = save_array[1].chomp.to_i
        @guessed_letters = save_array[2].chomp
        @answer_board = save_array[3].chomp
      end
    end
  end

  class Player
    attr_reader :choice

    def choose
      @choice = gets.chomp
      until @choice =~ /^[a-zA-Z]$|^save$|^load$/
        puts "Enter a valid input"
        @choice = gets.chomp
      end
    end
  end
end

include Hangman
game = Game.new
player = Player.new
while true
  game.game_prompt
  player.choose
  game.input_processor(player.choice)
end
