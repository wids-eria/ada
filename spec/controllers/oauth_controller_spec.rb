require 'spec_helper'

describe OauthController do

  describe "guest accounts" do
    let (:json)  { JSON.parse(response.body) }
    let (:client_app) {Client.create(name: 'TestApp', app_token: 'foo', app_secret: '12345')}
    let (:group) { Fabricate :group, name: 'TestGroup' }

    it "creates guest accounts!" do
      post :guest, {'client_id' => client_app.app_token, 'client_secret' => client_app.app_secret, 'format' => 'json'}
      response.should be_success
      puts json["info"]["player_name"]
      json["info"]["guest"].should == true
    end

    it "creates guest accounts with group code!" do
      post :guest, {'client_id' => client_app.app_token, 'client_secret' => client_app.app_secret, 'format' => 'json', 'group' => group.code}
      response.should be_success
      puts "CODE: "+group.code
      puts response.body

      guest = User.find_by_player_name(json["info"]["player_name"])
      puts json["info"]["player_name"]
      guest.groups.count.should > 0
    end

  end
end