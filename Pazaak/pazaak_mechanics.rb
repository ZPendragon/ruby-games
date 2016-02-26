module Pazaak
#
# class TestClass
# 	attr_accessor :player

# 	def self.draw_card
# 		deck = Deck.new()
# 		@current_deck = deck.cards.shuffle!
# 		new_card = @current_deck.shift
# 		puts new_card
# 		new_card
# 	end
# 	def self.play_card
# 		@player = Player.new()
# 		side_deck = Side_Deck.new()
# 		@player.side_deck = side_deck.card_array.shuffle.first(4)
# 		puts side_deck.tiles[@player.side_deck[0]]
# 		@player.side_deck.shift
# 	end

# end

class Deck
	attr_accessor :cards

	def initialize
		@cards = [1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,10,10,10,10]
	end
end

class Side_Deck
	attr_accessor :card_array, :tiles

	def initialize
		# [0,1,3,4,5,6,7,8,9,10,11]
		# [-1,-2,-3,-4,-5,-6,1,2,3,4,5,6]
		#[{neg_one: -1},{neg_two: -2},{neg_three: -3},{neg_four: -4},{neg_five: -5},{neg_six: -6},
		# {pos_one: 1},{pos_two: 2},{pos_three: 3},{pos_four: 4},{pos_five: 5},{pos_six: 6}]
		@card_array = [0,1,2,3,4,5,6,7,8,9,10,11]
		@tiles = [-1,-2,-3,-4,-5,-6,1,2,3,4,5,6]
	end

end

class Game
	# Start game, game rules, decides winner
	attr_accessor :player, :dealer, :rounds, :current_deck, :bust_result, :playing_side_card, :turn_increment, 
				  :can_determine_set, :winner

	def initialize()
		@player_one = Player.new()
		@player_two = Dealer.new()
		@rounds = 0
		@turn_increment = 1
		@game_turn = 2
		@playing_side_card = false
		@can_determine_set = false
		start_match
	end
	
	def start_match
		side_deck = Side_Deck.new()
		@player_one.side_deck = side_deck.card_array.shuffle.first(4)
		@player_two.side_deck = side_deck.card_array.shuffle.first(4)
		start_set
	end

	def start_set
		deck = Deck.new()
		@current_deck = deck.cards.shuffle!
	end


	def draw_card
		#puts @game_turn
		#puts @current_deck.count
		new_card = @current_deck.shift
		if @game_turn % 2 == 0
			@player_one.hand.push(new_card)
			p_one_score_update
			check_for_bust
		elsif @game_turn % 2 == 1
			@player_two.hand.push(new_card)
			p_two_score_update
			check_for_bust
		end
		next_turn	

		#puts "Deck Card Value: #{new_card}"
		#print "Player 1 Hand: #{@player_one.hand}\n"
		#puts @player_one.check_score
		#print "Player 2 Hand: #{@player_two.hand}\n"
		#puts @player_two.check_score
		new_card
	end

	def play_card(key_id)
		key_id -= 1
		side_deck = Side_Deck.new()
		#puts @player_one.side_deck.count
		#@game_turn -= 1
		#puts @game_turn
		#puts "Key ID: #{key_id}"
		if @game_turn % 2 == 0
			card_played = @player_one.side_deck[key_id]
			@player_one.side_deck.values_at(key_id)
			@player_one.hand.push(side_deck.tiles[card_played])
			p_one_score_update
		elsif @game_turn % 2 == 1
			card_played = @player_two.side_deck[key_id]
			@player_two.side_deck.values_at(key_id)
			@player_two.hand.push(side_deck.tiles[card_played])
			p_two_score_update
		end	
		next_turn
		# card_played = @player_one.side_deck.shift
		#puts "Side Card Value: #{side_deck.tiles[card_played]}"
		#puts "Game turn #{@game_turn}"
		card_played
	end

	def turn
		turn = @game_turn
		#puts "Running Turn", @game_turn
		if turn % 2 == 0
			#@game_turn += 1
			return true
		elsif turn % 2 == 1
			#@game_turn += 1
			return false
		end			
	end

	def next_turn
		@game_turn += @turn_increment
	end

	def reduce_turn
		@game_turn -= 1
	end

	def increase_turn
		@game_turn += 1
	end

	def end_turn
		#puts "Current Turn: #{@game_turn}"
		#puts turn
		if @player_one.end_turn || @player_two.end_turn
		else
			@game_turn -= 1
		end
	 	if turn
	 		puts "ending player 1's turn"
	 		@player_one.end_turn = true
	 		if check_for_bust
	 			puts "Player 1 Busts!"
	 			
	 			#@can_determine_set = true
	 			#@player_two.rounds_won += 1

	 		end
	 		@game_turn += 1
	 		@turn_increment = 2
	 	else
	 		puts "ending player 2's turn"
	 		@player_two.end_turn = true
	 		if check_for_bust
	 			puts "Player 2 Busts!"

	 			#@can_determine_set = true
	 			#@player_one.rounds_won += 1
	 		end
	 		@game_turn += 1
	 		@turn_increment = 2

	 	end

	 	#### CHECK FOR WINNER WHEN BOTH END TURN ARE TRUE

	 	if @player_one.end_turn && @player_two.end_turn
	 		@can_determine_set = true
	 		determine_winner
	 	end

	 end

	def update_pos
		#side_deck = Side_Deck.new()
		#puts "Player 1 Side Deck"
		#@player_one.side_deck.each { |card| puts side_deck.tiles[card] }
		# puts
		#puts "Player 2 Side Deck"
		#@player_two.side_deck.each { |card| puts side_deck.tiles[card] }
		if @playing_side_card
			if @player_one.end_turn == true || @player_two.end_turn == true
			else	
				@game_turn -= 1
			end
		end
		if turn
			@pos_x = @player_one.x_y[@player_one.pos][0]
			@pos_y = @player_one.x_y[@player_one.pos][1]
			#puts "Array node #{@player_one.pos}"
			@player_one.pos += 1
		else
			@pos_x = @player_two.x_y[@player_two.pos][0]
			@pos_y = @player_two.x_y[@player_two.pos][1]
			@player_two.pos += 1
		end
		@playing_side_card = false
	end

	def get_pos_x
		@pos_x
	end

	def get_pos_y
		@pos_y
	end

	def ended_turn
		if @player_one.end_turn == true || @player_two.end_turn == true
			return true
		end
	end

	def p_one_score_update
		@player_one.check_score
	end

	def p_two_score_update
		@player_two.check_score
	end

	def p_one_side_deck
		@player_one.side_deck
	end

	def p_two_side_deck
		@player_two.side_deck
	end

	def check_for_bust
		@bust_result = false
		if @game_turn % 2 == 0
			if @player_one.check_score > 20
				@bust_result = true
			elsif @player_one.check_score < 20
				@bust_result
			end
		elsif @game_turn % 2 == 1
			if @player_two.check_score > 20
				@bust_result = true
			elsif @player_two.check_score < 20
				@bust_result
			end
		end	
		#@bust_result
	end	

	def p_one_round_win
		@player_one.rounds_won += 1
	end

	def p_two_round_win
		@player_two.rounds_won += 1
	end

	def won_match
		if  @player_one.rounds_won == 3
			#return 1
			#puts "Player 1 wins the match!!!"
			return true
			#play_again
		elsif @player_two.rounds_won == 3
			#return 2
			#puts "Player 2 wins the match!!!"
			return true
			#play_again
		else
			#start_set
		end
	end

	

	def determine_winner
		#puts "determining...."
		if @player_one.check_score > @player_two.check_score
			#puts "Player 1 Wins!!!"
			@winner = 1
			p_one_round_win
			
		elsif @player_one.check_score < @player_two.check_score
			#puts "Player 2 Wins!!!"
			@winner = 2
			p_two_round_win
			
		elsif @player_one.check_score == @player_two.check_score
			@winner = 0
			#puts "It's a tie!!"
		
		end
		won_match
	end

	def reset_set
		puts "reseting..."
		puts "Player 1 Wins", @player_one.rounds_won
		puts "Player 2 Wins", @player_two.rounds_won
		@player_one.pos = 0
		@player_one.hand = []
		@player_one.end_turn = false

		@player_two.pos = 0
		@player_two.hand = []
		@player_two.end_turn = false

		@can_determine_set = false
		@bust_result = false
		@game_turn = 2
		@turn_increment = 1

		start_set
	end

	def reset_match
		@player_one.rounds_won = 0
		@player_two.rounds_won = 0
		start_match
	end
end





class Player
	# 
	attr_accessor :name, :total_money, :hand, :player_score, :side_deck, :end_turn, :rounds_won, :original_side, :x_y, :side_x_y, :pos, :score_x_y

	def initialize
		@hand = []
		@side_deck = []
		#@original_side = @side_deck
		@player_score = 0
		@end_turn = false
		@rounds_won = 0

		# 3x3 Card x y coordinates & position
		@x_y = [[164,126],[243,128],[322,129],[162,217],[241,219],[320,220],[160,308],[239,310],[320,311]]
		@side_x_y = [[89,425],[168,425],[249,427],[328,428]]
   		@pos = 0

		
   		# score x y 
   		@score_x_y = [353, 52]


	end

	def check_score
		@player_score = 0
		@hand.each { |card| @player_score += card }
		@player_score
	end
end



class Dealer
	attr_accessor :balance, :hand, :dealer_score, :side_deck, :end_turn, :rounds_won, :original_side, :x_y, :side_x_y, :pos


	def initialize
		@hand = []
		@side_deck = []
		#@original_side = @side_deck
		@dealer_score = 0
		@end_turn = false
		@rounds_won = 0


		@x_y = [[478,133],[559,134],[641,135],[479,223],[558,223],[637,225],[477,312],[557,314],[637,316]]
		@side_x_y = [[465,430],[544,432],[624,433],[705,434]]
		@pos = 0

		# score x y 
   		@score_x_y = [432, 53]

	end

	def check_score
		@dealer_score = 0
		@hand.each { |card| @dealer_score += card }
		@dealer_score
	end

end

end
