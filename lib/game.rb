require 'csv'
require 'pry-byebug'

class Player
    attr_accessor :name, :player_choices, :health, :input
    def initialize (name, health = 5, input = '')
        @alive = true
        @name = name
        @health = health
        @input = input.split('')
    end

    def alive
        @alive = true
    end


    def name
        @name
    end

    def get_name
        puts @name
    end

    def input
        @input
    end

    def player_input
        input = ""
        puts "Select a letter"        
        input = gets.chomp
        until input.length == 1
            puts "invalid choice, try again"
            input = gets.chomp
        end
        change_input(input)
        print_input       
    end

    def change_input(arg)
        input = @input << arg
        self.input = input
    end

    def print_input
        p @input
    end

    def choices 
        @variable
    end 

    def health
        @health       
    end

    def puts_health
        puts "you have #{self.health} tries remaining"
    end

    def health_damage
        self.health = @health - 1
        self.puts_health
    end
    
    def check_health
        if self.health == 0
            self.alive = false
            game_over
        end
    end

         



end

class Dictionary
    attr_accessor :word
    @word = ''
    def initialize
        @contents = File.readlines('google-10000-english-no-swears.txt')
        selectoring(@contents)
    end

    def selectoring (array)
        word = ''        
        until word.length >= 5 == true && word.length < 13 == true
            i = rand(0..array.length)
            word = array[i][0..-2]
        end
        @word = word
        
    end

    def word
        @word
    end
 
end



class Game
    attr_accessor :name, :alive, :winner, :game_over
    @@chosen_word = ''
    @@underscored_word = ''
    @@player_word = []

    def initialize 
        puts "Hangman started!"
        puts 'What is your name?'
        @name = gets.chomp
        @alive = true
        @winner = false
        @game_over = false
        new = Player.new(@name.to_s)
        update_word
        new.puts_health
        update_underscored
        while @alive == true
            jk = new.health
            check_health_player(jk)
            break if alive == false
            new.print_input
            new.player_input
            a = new.input[-1]
            if checker(a) != true
                new.health_damage
            end
                  
        end      
    end

    def checker(arg)
        if @@chosen_word.include?(arg)
            i = 0
            until i == @@chosen_word.length
                if @@chosen_word[i] == arg
                    @@underscored_word[i] = arg                    
                end
                i += 1
            end
            p @@underscored_word
            return true
        end
        @@player_word << arg
        p "incorrect letters already used: #{@@player_word}"
        false
    end


    

    def update_word
        j = Dictionary.new
        @@chosen_word = j.word
    end

    def update_underscored
        until @@underscored_word.length  == @@chosen_word.length
                @@underscored_word << '_'        
        end
            puts @@underscored_word
       
    end

    
    

    def check_word
       if @@chosen_word.eql? @@underscored_word
        @alive = false
       end

                
    end


    def check_health_player(arg)
        if arg.zero? == true
            puts "you lost"
            self.alive = false
        elsif @@underscored_word.eql? @@chosen_word
            puts "you won"
            self.alive = false
        end
    end

    def alive
        @alive
    end

    def winner
        @winner
    end
    




    
end

pedro = Game.new



