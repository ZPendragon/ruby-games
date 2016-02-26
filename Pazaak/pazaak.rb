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

    # TESTING COLOR
    #@key_id = key_id
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
    #puts image.width, image.height
    # TESTING COLOR
    #if @key_id % 2 == 0
    image.draw(@x - image.width / 2.0, @y - image.height / 2.0, 1 )
	#else
    #image.draw(@x - image.width / 2.0, @y - image.height / 2.0, 1, 1, 1, 0xff_808080 )
	#end
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
    
    image.draw(@x - image.width / 2.0, @y - image.height / 2.0, 2 )
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

class Win_Set
	#IMAGE = media_path('photos/player_one_win_set')

	def initialize(window, animation, sound)
    @window = window
    @animation = animation
    sound.play
  	end

  	def self.load_sound(window)
    Gosu::Sample.new(window, media_path('win_set.mp3'))
  end

  def self.load_animation(window, player)
  	# => (window, file, x, y)	
  	if player == 1
    	Gosu::Image.new(window, media_path('photos/player_one_win_set.png'), false)
    elsif player == 2
    	Gosu::Image.new(window, media_path('photos/player_two_win_set.png'), false)
    end
  end

  	def draw
    image = @animation
    image.draw(@window.width / 2 - image.width / 2.0, @window.height / 2 - image.height / 2.0, 1 )
  end

end

class Bust_Set
	#IMAGE = media_path('photos/player_one_win_set')

	def initialize(window, animation, sound)
    @window = window
    @animation = animation
    sound.play
  	end

  	def self.load_sound(window)
    Gosu::Sample.new(window, media_path('lost_set.mp3'))
  end

  def self.load_animation(window, player)
  	# => (window, file, x, y)	
  	if player == 1
    	Gosu::Image.new(window, media_path('photos/player_one_busts.png'), false)
    elsif player == 2
    	Gosu::Image.new(window, media_path('photos/player_two_busts.png'), false)
    end
  end

  	def draw
    image = @animation
    image.draw(@window.width / 2 - image.width / 2.0, @window.height / 2 - image.height / 2.0, 1 )
  end

end

class Bust_Match
	#IMAGE = media_path('photos/player_one_win_set')

	def initialize(window, animation, sound)
    @window = window
    @animation = animation
    sound.play
  	end

  	def self.load_sound(window)
    Gosu::Sample.new(window, media_path('lost_match.mp3'))
  end

  def self.load_animation(window, player)
  	# => (window, file, x, y)	
  	if player == 1
    	Gosu::Image.new(window, media_path('photos/player_one_busts_match.png'), false)
    elsif player == 2
    	Gosu::Image.new(window, media_path('photos/player_two_busts_match.png'), false)
    end
  end

  	def draw
    image = @animation
    image.draw(@window.width / 2 - image.width / 2.0, @window.height / 2 - image.height / 2.0, 1 )
  end

end

class Win_Match
	#IMAGE = media_path('photos/player_one_win_set')

	def initialize(window, animation, sound)
    @window = window
    @animation = animation
    sound.play
  	end

  	def self.load_sound(window)
    Gosu::Sample.new(window, media_path('win_match.mp3'))
  end

  def self.load_animation(window, player)
  	# => (window, file, x, y)	
  	if player == 1
    	Gosu::Image.new(window, media_path('photos/player_one_win_match.png'), false)
    elsif player == 2
    	Gosu::Image.new(window, media_path('photos/player_two_win_match.png'), false)
    end
  end

  	def draw
    image = @animation
    image.draw(@window.width / 2 - image.width / 2.0, @window.height / 2 - image.height / 2.0, 1 )
  end

end

class Tie_Set
	#IMAGE = media_path('photos/player_one_win_set')

	def initialize(window, animation, sound)
    @window = window
    @animation = animation
    sound.play
  	end

  	def self.load_sound(window)
    Gosu::Sample.new(window, media_path('tied_set.mp3'))
  end

  def self.load_animation(window)
  	# => (window, file, x, y)	
  	Gosu::Image.new(window, media_path('photos/tie_set.png'), false)
  end

  	def draw
    image = @animation
    image.draw(@window.width / 2 - image.width / 2.0, @window.height / 2 - image.height / 2.0, 1 )
  end

end

class Set_Icon
	IMAGE = media_path('photos/set_win_icon.png')

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
    image = @animation
    
    image.draw(@x - image.width / 2.0, @y - image.height / 2.0, 2 )
  end

end

class Side_Deck_Text

  def initialize(animation, x, y)
    @animation = animation
    @x, @y = x, y
  end

  def self.load_animation(window)
  	# => (window, file, x, y)	
   	Gosu::Image.from_text(self, 'Used', 'Old Republic', 20)
    #, 50, 50, 54, 57
  end

  def draw
    image = @animation
    
    image.draw(@x - image.width / 2.0, @y - image.height / 2.0, 2 )
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
   		@back_z = 0
   		@z = 1

   		@deck_animation = Deck_Card.load_animation(self)
   		@deck_sound = Deck_Card.load_sound(self)
   		@deck_second_sound = Bust_Sound.load_sound(self)
   		@deck_cards = []
   		@side_deck_animation = Play_Card.load_animation(self)
   		@side_deck_sound = Play_Card.load_sound(self)
   		@player_one_side_deck_cards = []
   		@player_two_side_deck_cards = []

   		@player_one_win_set_animation = Win_Set.load_animation(self, 1)
   		@player_two_win_set_animation = Win_Set.load_animation(self, 2)
   		@win_set_sound = Win_Set.load_sound(self)

   		@player_one_bust_set_animation = Bust_Set.load_animation(self, 1)
   		@player_two_bust_set_animation = Bust_Set.load_animation(self, 2)
   		@bust_set_sound = Bust_Set.load_sound(self)

   		@player_one_bust_match_animation = Bust_Match.load_animation(self, 1)
   		@player_two_bust_match_animation = Bust_Match.load_animation(self, 2)
   		@bust_match_sound = Bust_Match.load_sound(self)

   		@win_image = []

   		@player_one_win_match_animation = Win_Match.load_animation(self, 1)
   		@player_two_win_match_animation = Win_Match.load_animation(self, 2)
   		@win_match_sound = Win_Match.load_sound(self)

   		@set_tie_animation = Tie_Set.load_animation(self)
   		@set_tie_sound = Tie_Set.load_sound(self)

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

   		@side_text_animation = Side_Deck_Text.load_animation(self)
   		@p_one_side_text_x_y = [[89,485],[170,485],[250,486],[329,487]]
   		@p_two_side_text_x_y = [[464,490],[544,491],[623,492],[703,493]]
		@p_one_side_text = []
		@p_two_side_text = []


   		@set_icon = []
   		@set_icon_animation = Set_Icon.load_animation(self)
   		@p_one_set_icon_x_y = [[74,133],[74,165],[74,196]]
   		@p_one_win_set_num = 0
   		@p_two_set_icon_x_y = [[729,143],[729,175],[729,207]]
   		@p_two_win_set_num = 0
   		#@set_icon = Gosu::Image.new(self, media_path('photos/set_win_icon.png'), false)
   		@player_busted = false
   		@disable_buttons = false
   		@card_played_this_turn = false
	end

	def update_z
		@back_z += 2
		@z += 2
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
		#@game.reduce_turn
		# When a player ends their turn, the counter is growing by 2, we need to reduce turn by one to produce the same effect as non-end play
		if @game.ended_turn
			@game.reduce_turn
		end
		puts @game.turn, !@player_one_button_pressed[key_id]

		if !@game.turn && !@player_one_button_pressed[key_id]
    			if @game.ended_turn
    				@game.increase_turn
    			end	
    			@game.playing_side_card = true
    			@player_one_button_pressed[key_id] = true
    			
    			@game.update_pos
    			@player_one_side_deck_cards.push(Play_Card.new(@side_deck_animation, @side_deck_sound, @game.get_pos_x, @game.get_pos_y, @game, key_id))

    			# Push side text image here
    			node = key_id - 1
    			@p_one_side_text.push(Side_Deck_Text.new(@side_text_animation, @p_one_side_text_x_y[node][0],@p_one_side_text_x_y[node][1]))

    	elsif @game.turn && !@player_two_button_pressed[key_id]
    			if @game.ended_turn
    				@game.increase_turn
    			end	
    			@game.playing_side_card = true
    			@player_two_button_pressed[key_id] = true
    			
    			@game.update_pos
    			@player_two_side_deck_cards.push(Play_Card.new(@side_deck_animation, @side_deck_sound, @game.get_pos_x, @game.get_pos_y, @game, key_id))

    			# Push side text image here
    			node = key_id - 1
    			@p_two_side_text.push(Side_Deck_Text.new(@side_text_animation, @p_two_side_text_x_y[node][0],@p_two_side_text_x_y[node][1]))
    	end
	end

	def button_down id
		close if id == Gosu::KbEscape
		if id == Gosu::KbSpace
			#puts mouse_x, mouse_y
			# puts @card_played_this_turn
	      	if @disable_buttons
	    		#prevent further action while game result is displayed
	    	else
	    		@card_played_this_turn = false	
				@game.reduce_turn
				front_check_for_bust
				@game.increase_turn
				if @player_busted
				else
		      		@game.update_pos

		      		@deck_cards.push(Deck_Card.new(@deck_animation, @deck_sound, @game.get_pos_x, @game.get_pos_y, @game, @deck_second_sound))
		      		@buttons_down += @game.turn_increment
	      		end
	      	end
    	elsif id == Gosu::Kb1
    		if @disable_buttons
	    		#prevent further action while game result is displayed
	    	elsif @card_played_this_turn
	    		#prevent other cards being played on the same turn
	    	else
	    		@card_played_this_turn = true
	    		key_id = 1
	    		play_side_card(key_id)
	    		
	    	end
    	elsif id == Gosu::Kb2
    		if @disable_buttons
	    		#prevent further action while game result is displayed
	    	elsif @card_played_this_turn
	    		#prevent other cards being played on the same turn
	    	else
	    		@card_played_this_turn = true
	    		key_id = 2
	    		play_side_card(key_id)
	    	end
    	elsif id == Gosu::Kb3
    		if @disable_buttons
	    		#prevent further action while game result is displayed
	    	elsif @card_played_this_turn
	    		#prevent other cards being played on the same turn
	    	else
	    		@card_played_this_turn = true
	    		print "Player 1: #{@player_one_button_pressed}"
	    		puts
	    		print "Player 2: #{@player_two_button_pressed}"
	    		
	    		key_id = 3
	    		play_side_card(key_id)
	    	end
    	elsif id == Gosu::Kb4
    		if @disable_buttons
	    		#prevent further action while game result is displayed
	    	elsif @card_played_this_turn
	    		#prevent other cards being played on the same turn
	    	else
	    		@card_played_this_turn = true
	    		key_id = 4
	    		play_side_card(key_id)
	    	end
    	elsif id == Gosu::KbE
	    	if @disable_buttons
	    		#prevent further action while game result is displayed
	    	else
	    		@card_played_this_turn = false
	    		@game.end_turn
				front_check_for_bust    		

				if @player_busted
					# do nothing and trap the game from allowing a busted player to 'win'
				else
		    		if @game.can_determine_set
		    			@disable_buttons = true
		    			if @game.winner == 1
		    				@buttons_down += 1
		    				#player 1 wins set animation
		    				if @game.won_match
		    					@win_image.push(Win_Match.new(self, @player_one_win_match_animation, @win_match_sound))
		    					@set_icon.push(Set_Icon.new(@set_icon_animation, @p_one_set_icon_x_y[@p_one_win_set_num][0],@p_one_set_icon_x_y[@p_one_win_set_num][1]))
		    				else
		    					@win_image.push(Win_Set.new(self, @player_one_win_set_animation, @win_set_sound))
		    					@set_icon.push(Set_Icon.new(@set_icon_animation, @p_one_set_icon_x_y[@p_one_win_set_num][0],@p_one_set_icon_x_y[@p_one_win_set_num][1]))
		    					@p_one_win_set_num += 1
		    				end
		    			elsif @game.winner == 2
		    				@buttons_down += 1
		    				#player 2 wins set animation
		    				if @game.won_match
		    					@win_image.push(Win_Match.new(self, @player_two_win_match_animation, @win_match_sound))
		    					@set_icon.push(Set_Icon.new(@set_icon_animation, @p_two_set_icon_x_y[@p_two_win_set_num][0],@p_two_set_icon_x_y[@p_two_win_set_num][1]))
		    				else
		    					@win_image.push(Win_Set.new(self, @player_two_win_set_animation, @win_set_sound))
		    					@set_icon.push(Set_Icon.new(@set_icon_animation, @p_two_set_icon_x_y[@p_two_win_set_num][0],@p_two_set_icon_x_y[@p_two_win_set_num][1]))
		    					@p_two_win_set_num += 1
		    				end
		    			else
		    				#player ties animation
		    				@win_image.push(Tie_Set.new(self, @set_tie_animation, @set_tie_sound))
		    			end
		    		end
		    	end
		    end
    	elsif id == Gosu::KbReturn
    		# Pressing 'enter' should resolve the game animation and redraw the game window.
    		# Have another loop or condition to draw the win_set icon for the player.
    		if @player_busted
    			if @game.won_match
    				@game.reset_set
    				@game.reset_match
    				reset_front
    				reset_match_front
	    		else
	    			@game.reset_set
	    			reset_front
	    		end
    		end

    		if @game.can_determine_set 
    			@game.reset_set
    			reset_front
    		end
    		if @game.won_match
    			# Moved the functions below from 'e' to make the 'game reset' feel more natural
    			@game.reset_match
    			reset_match_front
    			reset_front
    		end
    	end
    	
	end
	
	def front_check_for_bust
		if @game.p_one_score_update > 20
			@disable_buttons = true
			@player_busted = true
    		@set_icon.push(Set_Icon.new(@set_icon_animation, @p_two_set_icon_x_y[@p_two_win_set_num][0],@p_two_set_icon_x_y[@p_two_win_set_num][1]))
    		@game.p_two_round_win
    		@p_two_win_set_num += 1
    		if @game.won_match
    			@win_image.push(Bust_Match.new(self, @player_one_bust_match_animation, @bust_match_sound))
    		else
    			@win_image.push(Bust_Set.new(self, @player_one_bust_set_animation, @bust_set_sound))
    		end
    	elsif @game.p_two_score_update > 20
    			@disable_buttons = true
    			@player_busted = true
    			@set_icon.push(Set_Icon.new(@set_icon_animation, @p_one_set_icon_x_y[@p_one_win_set_num][0],@p_one_set_icon_x_y[@p_one_win_set_num][1]))
    			@game.p_one_round_win
    			@p_one_win_set_num += 1
    		if @game.won_match
    			@win_image.push(Bust_Match.new(self, @player_two_bust_match_animation, @bust_match_sound))
    		else
    			@win_image.push(Bust_Set.new(self, @player_two_bust_set_animation, @bust_set_sound))
    		end
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

	def reset_front
		@card_played_this_turn = false
		@deck_cards = []
		@buttons_down = 0
		@player_one_side_deck_cards = []
   		@player_two_side_deck_cards = []
   		@win_image = []
   		@player_busted = false
   		@disable_buttons = false
	end

	def reset_match_front
		@player_one_side = @game.p_one_side_deck
		@p_one_image = []
   		@p_one_image = load_p_one_side
   		@player_two_side = @game.p_two_side_deck
   		@p_two_image = []
   		@p_two_image = load_p_two_side
   		@p_one_win_set_num = 0
   		@p_two_win_set_num = 0
   		@set_icon = []
   		@p_one_side_text = []
		@p_two_side_text = []
	end

	def draw
		@scene_ready ||= true

    	@background.draw(0, 0, 0)
    	@deck_cards.map(&:draw)

    	@player_one_side_deck_cards.map(&:draw)
    	@player_two_side_deck_cards.map(&:draw)

    	@p_one_side_text.map(&:draw)
    	@p_two_side_text.map(&:draw)
    	
    	@p_one_image.map(&:draw)
    	@p_two_image.map(&:draw)

    	@turn_icon.draw(@turn_icon_x[button_num],@turn_icon_y[button_num],1)

    	#@set_icon.draw(75,134,1)
    	@set_icon.map(&:draw)

    	#@player_one_score_text.draw(353, 52, 1)
     	#@player_one_score_text.draw(435, 53, 1)



     	@p_one_score_text = Gosu::Image.from_text(self, @game.p_one_score_update, 'Old Republic', 20)
     	@p_one_score_text.draw(351, 52, 2)
     	@p_two_score_text = Gosu::Image.from_text(self, @game.p_two_score_update, 'Old Republic', 20)
     	@p_two_score_text.draw(432, 53, 2)

     	@p_one_name_text = Gosu::Image.from_text(self, 'Han Solo', 'Old Republic', 16)
     	@p_one_name_text.draw(112, 47, 2)
     	@p_two_name_text = Gosu::Image.from_text(self, 'Lando Calrissian', 'Old Republic', 16)
     	@p_two_name_text.draw(560, 53, 2)

     	@win_image.map(&:draw)
	end
end

PazaakGame.new.show