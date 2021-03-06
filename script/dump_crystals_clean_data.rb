require 'csv'


#player_list = CSV.open("csv/tenacity/crystals_players.csv", 'r')
#players = Array.new
#player_list.each do |player_name|
#  player = User.where(player_name: player_name).first
#  if player != nil
#    players << player
#  end
#end
players = User.player_name_matches('5-0-')

types = AdaData.with_game('KrystalsOfKaydor').where(schema: 'PRODUCTION-05-29-2013').without([:_id, :created_at, :updated_at]).distinct(:key)
puts types.inspect
examples = Array.new
types.each do |type|
  ex = AdaData.with_game('KrystalsOfKaydor').without([:_id, :created_at, :updated_at]).where( key: type).first
  if ex != nil
    examples << ex
  end
end
puts examples.count
puts examples.inspect
all_attrs = Array.new
examples.each do |e|
  e.attributes.keys.each do |k|
    all_attrs << k
  end
end
puts all_attrs.inspect
csv = CSV.open("csv/tenacity/crystals_all_players_cleaned.csv", "w") 
csv << ['player_id'] + all_attrs.uniq



players.each do |play|
  data = play.data('KrystalsOfKaydor').without([:_id, :created_at, :updated_at]).asc(:timestamp)
  if data.count > 0
    
      
    prev = Hash.new 
    data.each do |entry|
      

      if prev[entry.inspect.to_s].nil?
        out = Array.new
        all_attrs.uniq.each do |attr|
          if entry.attributes.keys.include?(attr)
            out << entry.attributes[attr]
          else
            out << ""
          end
        end
        csv << [play.player_name] + out
        prev[entry.inspect.to_s] = entry
      end


    end
  end
end
