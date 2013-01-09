require 'spec_helper.rb'

describe 'Test admin tools' do 

  before do
   @some_researcher = Fabricate :user
   @private_game = Fabricate :game, name: 'private_game' 
  end

  describe 'admin grants access' do
    it 'can add and remove researcher roles' do
      sign_in_admin

      click_link 'Users'

      fill_in 'player_name', :with => @some_researcher.player_name
      click_button 'search'

      click_link 'Edit'

      check 'private_game'
      

      click_button 'Update User'

      @some_researcher.role?(ResearcherRole.where(name: @private_game.name).first).should == true
    
    end
  end


end