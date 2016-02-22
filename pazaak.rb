require 'gosu'
require "./pazaak_mechanics"

def media_path(file)
	# x = File.join(File.dirname(File.dirname(__FILE__)), 'media', file)
	# puts x
  File.join(File.dirname(File.dirname(__FILE__)), 'media', file)
end

class Deck_Card
	IMAGE = media_path('photos/pazaak_cards.jpg')

  def initialize(animation, sound, x, y, game, sound2)
    @animation = animation
    @x, @y = x, y
    card = game.draw_card + 17
    if game.bust_result
		sound2.play
	else
		sound.play
	end
    @current_frame = (card)
  end

  def self.load_sound(window)
    Gosu::Sample.new(window, media_path('draw_card.mp3'))
  end

  def self.load_animation(window)
  	# => (window, file, x, y)	
    Gosu::Image.load_tiles(window, IMAGE, 68, 85, false)
  end

  def draw
    return if done?
    image = current_frame
    image.draw(
      @x - image.width / 2.0,
      @y - image.height / 2.0,
      1 )
  end

  def current_frame
    @animation[@current_frame % @animation.size]
  end

  def done?
    @done ||= @current_frame == @animation.size
  end

  def sound
    @sound.play
  end

end

class Bust_Sound
	def self.load_sound(window)
    	Gosu::Sample.new(window, media_path('draw_bust_card.mp3'))
  	end
end

class Play_Card
	IMAGE = media_path('photos/pazaak_cards.jpg')

  def initialize(animation, sound, x, y, game, key_id)
    @animation = animation
    sound.play
    @x, @y = x, y
    #card = Pazaak::TestClass.play_card
    card = game.play_card(key_id)
    @current_frame = (card)
    #@current_frame = rand(0..17) 
  end

  def self.load_sound(window)
    Gosu::Sample.new(window, media_path('play_card.mp3'))
  end

  def self.load_animation(window)
  	# => (window, file, x, y)	
    Gosu::Image.load_tiles(window, IMAGE, 68, 84, false)
  end

  def draw
    return if done?
    image = current_frame
    image.draw(
      @x - image.width / 2.0,
      @y - image.height / 2.0,
      1 )
  end

  def current_frame
    @animation[@current_frame % @animation.size]
  end

  def done?
    @done ||= @current_frame == @animation.size
  end

  def sound
    @sound.play
  end

end

class Turn_Icon
	IMAGE = media_path('photos/turn_icon_copy.png')

  def initialize(animation, x, y)
    @animation = animation
    @x, @y = x, y
  end

  def self.load_animation(window)
  	# => (window, file, x, y)	
    Gosu::Image.new(window, IMAGE, false)
    #, 50, 50, 54, 57
  end

  def draw
    return if done?
    image = current_frame
    image.draw(@x - image.width / 2.0, @y - image.height / 2.0, 1 )
  end

  def current_frame
    @animation[@current_frame % @animation.size]
  end

  def done?
    @done ||= @current_frame == @animation.size
  end

end

class Load_Side_Card
	IMAGE = media_path('photos/pazaak_cards.jpg')

  def initialize(animation, card, x, y)
    @animation = animation
    @x, @y = x, y
    @current_frame = (card)
  end

   def draw
    return if done?
    image = current_frame
    image.draw(
      @x - image.width / 2.0,
      @y - image.height / 2.0,
      1 )
  end

  def current_frame
    @animation[@current_frame % @animation.size]
  end

  def done?
    @done ||= @current_frame == @animation.size
  end

end
















class PazaakGame < Gosu::Window
	BACKGROUND = media_path('/photos/empty_board.png')

	def initialize width=800, height=600, fullscreen=false
		super
		self.caption = "Star Wars -- Pazaak"
		@background = Gosu::Image.new(self, BACKGROUND, false)
		@music = Gosu::Song.new(self, media_path('cantina_background.mp3'))
		@music.play
		@music.volume = 0.3
   		@music.play(true)
   		@deck_animation = Deck_Card.load_animation(self)
   		@deck_sound = Deck_Card.load_sound(self)
   		@deck_second_sound = Bust_Sound.load_sound(self)
   		@deck_cards = []
   		@side_deck_animation = Play_Card.load_animation(self)
   		@side_deck_sound = Play_Card.load_sound(self)
   		@player_one_side_deck_cards = []
   		@player_two_side_deck_cards = []

   		@game = Pazaak::Game.new


   		@turn_icon = Gosu::Image.new(self, media_path('photos/turn_icon_copy.png'), false)
   		#@turn_icon_animation = Turn_Icon.load_animation(self)

   		# 2 / 19
   		# X & Y for player_one & two -- should move to Player classes 
   		@turn_icon_x = [61,702]
   		@turn_icon_y = [40,50]
   		@buttons_down = 0
   		
   		@player_one_button_pressed = [false,false,false,false]
   		@player_two_button_pressed = [false,false,false,false]
   		# X & Y for player_one & two -- should move to Player classes 
   		#@player_one_score_text = Gosu::Image.from_text(self, "10", 'Old Republic', 20)

   		@player_one_side = @game.p_one_side_deck
   		@p_one_side_x_y = [[89,425],[168,425],[249,427],[328,428]]
   		@p_one_image = []
   		@p_one_images = load_p_one_side

   		@player_two_side = @game.p_two_side_deck
   		@p_two_side_x_y = [[465,430],[544,432],[624,433],[705,434]]
   		@p_two_image = []
   		@p_two_images = load_p_two_side
	end

	def load_p_one_side
		num = 0
    	@player_one_side.each do |card| 
    		@p_one_image.push(Load_Side_Card.new(@side_deck_animation, card, @p_one_side_x_y[num][0], @p_one_side_x_y[num][1]))
    		num += 1
    	end
    	#puts @image
    	@p_one_image
	end

	def load_p_two_side
		num = 0
    	@player_two_side.each do |card| 
    		@p_two_image.push(Load_Side_Card.new(@side_deck_animation, card, @p_two_side_x_y[num][0], @p_two_side_x_y[num][1]))
    		num += 1
    	end
    	#puts @image
    	@p_two_image
	end

	def play_side_card(key_id)
		if @game.turn && !@player_one_button_pressed[key_id]
    			@game.playing_side_card = true
    			@player_one_button_pressed[key_id] = true
    			@game.update_pos
    			@player_one_side_deck_cards.push(Play_Card.new(@side_deck_animation, @side_deck_sound, @game.get_pos_x, @game.get_pos_y, @game, key_id))
    	elsif !@game.turn && !@player_two_button_pressed[key_id]
    			@game.playing_side_card = true
    			@player_two_button_pressed[key_id] = true
    			@game.update_pos
    			@player_two_side_deck_cards.push(Play_Card.new(@side_deck_animation, @side_deck_sound, @game.get_pos_x, @game.get_pos_y, @game, key_id))
    	end
	end

	def button_down id
		close if id == Gosu::KbEscape
		if id == Gosu::KbSpace
      		#@deck_sound.play
      		@game.update_pos

      		@deck_cards.push(Deck_Card.new(@deck_animation, @deck_sound, @game.get_pos_x, @game.get_pos_y, @game, @deck_second_sound))
      		@buttons_down += 1
      		
    	elsif id == Gosu::Kb1
    		#@side_deck_sound.play
    		#puts mouse_x, mouse_y

    		#Turn_Icon.new(@turn_icon_animation,50,50)
    		key_id = 1
    		play_side_card(key_id)
    		puts @images
    	elsif id == Gosu::Kb2
    		
    		key_id = 2
    		play_side_card(key_id)

    	elsif id == Gosu::Kb3
    	
    		key_id = 3
    		play_side_card(key_id)

    	elsif id == Gosu::Kb4
    		
    		key_id = 4
    		play_side_card(key_id)
    	end
    	
	end
	
	def button_num
		@buttons_down % 2
	end

	def needs_cursor?
    	true
  	end

	def update
		#@buttons_down += 1	if button_down?(Gosu::KbSpace)
	end

	def draw
		@scene_ready ||= true
    	@background.draw(0, 0, 0)
    	@deck_cards.map(&:draw)
    	@player_one_side_deck_cards.map(&:draw)
    	@player_two_side_deck_cards.map(&:draw)
    	
    	@p_one_image.map(&:draw)
    	@p_two_image.map(&:draw)

    	# =>  			(  x, y,z)
    	#@turn_icon.draw(61,40,1)
    	#puts @buttons_down

    	# Working !!!
    	# Need to update the icon when a card is played instead of drawn or before it is...
    	@turn_icon.draw(@turn_icon_x[button_num],@turn_icon_y[button_num],1)


    	#@player_one_score_text.draw(353, 52, 1)
     	#@player_one_score_text.draw(435, 53, 1)

     	@p_one_score_text = Gosu::Image.from_text(self, @game.p_one_score_update, 'Old Republic', 20)
     	@p_one_score_text.draw(351, 52, 1)
     	@p_two_score_text = Gosu::Image.from_text(self, @game.p_two_score_update, 'Old Republic', 20)
     	@p_two_score_text.draw(432, 53, 1)

	end
end

PazaakGame.new.show