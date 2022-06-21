require 'csv'
require 'pry-byebug'
require 'yaml'

class Player
  attr_accessor :name, :player_choices, :health, :input

  def initialize(name, health = 5, input = '')
    @alive = true
    @name = name
    @health = health
    @input = input.split('')
  end
end

class Dictionary
  attr_accessor :word

  @word = ''
  def initialize
    @contents = File.readlines('google-10000-english-no-swears.txt')
    selectoring(@contents)
  end

  def selectoring(array)
    word = ''
    until word.length >= 5 == true && word.length < 13 == true
      i = rand(0..array.length)
      word = array[i][0..-2]
    end
    @word = word
  end

end

class Game
  attr_accessor :name, :alive, :winner, :game_over, :health

  def initialize(input = '', health = 5)
    @chosen_word = ''
    @underscored_word = ''
    @player_word = []
    puts 'Hangman started!'
    load
    puts 'What is your name?'
    @name = gets.chomp
    @alive = true
    @input = input
    @health = health
    start
  end

  def start
    new = Player.new(@name.to_s)
    update_word
    puts_health
    update_underscored
    turn
  end

  def load
    puts "Do you want to load a saved file? (Y/N)"
    if gets.chomp.downcase == 'y'
      File.open("/saved_games/savefile.yaml", "r").each do |object|
        Yaml::load(object)
      end
    end
  end

  def turn
    while @alive == true
      check_health_player(@health)
      break if alive == false
      player_input
      a = last_input
      health_damage if checker(a) != true
      serialize
    end
  end

  def health_damage
    puts health
    self.health = @health - 1
    puts_health
  end

  def puts_health
    puts "you have #{health} tries remaining"
  end

  def player_input
    puts 'Select a letter'
    input = gets.chomp
    until input.length == 1
      puts 'invalid choice, try again'
      input = gets.chomp
    end
    change_input(input)
    
  end

  def change_input(arg)
    input_a = @input << arg
    input = input_a
  end

  def print_input
    puts @input
  end

  def last_input
    @input[-1]
  end

  def checker(arg)
    if @chosen_word.include?(arg)
      i = 0
      until i == @chosen_word.length
        @underscored_word[i] = arg if @chosen_word[i] == arg
        i += 1
      end
      p @underscored_word
      return true
    end
    @player_word << arg
    puts @underscored_word
    puts "incorrect letters already used: #{@player_word}"
    false
  end

  def update_word
    j = Dictionary.new
    @chosen_word = j.word
  end

  def update_underscored
    @underscored_word << '_' until @underscored_word.length == @chosen_word.length
    puts @underscored_word
  end

  def check_word
    @alive = false if @chosen_word.eql? @underscored_word
  end

  def check_health_player(arg)
    if arg.zero? == true
      puts 'you lost'
      self.alive = false
    elsif @underscored_word.eql? @chosen_word
      puts 'you won'
      self.alive = false
    end
  end

  def serialize
    puts "Do you want to save? (Y/N)"
    answer = gets.chomp
    if answer.downcase == 'y'
      Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
      save_game = "saved_games/savefile.yaml"
      File.open(save_game,'w') do |file|
        file.puts YAML.dump(self)
      end
      puts "Thank you for playing, your game is saved."
      self.alive = false
    end       
  end
end

pedro = Game.new
