FactoryGirl.define do
  sequence(:platform_id)
  factory :game do
    email 'test@test.com'
    full_name 'test'
    platform_id { generate(:platform_id) }

    factory :game_with_deployments do
      # FactoryGirl.create(:ship)
    end


    deployments_attributes do
      ships = Ship.limit(7)

      [{:ship_id => ships[0].id, :positions=>[0],  :orientation=>"horizontal"},
      {:ship_id => ships[1].id, :positions=>[10], :orientation=>"horizontal"},
      {:ship_id => ships[2].id, :positions=>[20], :orientation=>"horizontal"},
      {:ship_id => ships[3].id, :positions=>[30], :orientation=>"horizontal"},
      {:ship_id => ships[4].id, :positions=>[40], :orientation=>"horizontal"},
      {:ship_id => ships[5].id, :positions=>[50], :orientation=>"horizontal"},
      {:ship_id => ships[6].id, :positions=>[60], :orientation=>"horizontal"}]
    end

    turns_attributes [{
      :position => 0, :attacked=>false, :status=>'hit' #first turn will hit based on deployment positioning
    }]
  end

  factory :turn do
    game
  end

  factory :deployment do
    name ''
  end

 
end