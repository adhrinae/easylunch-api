Rails.application.routes.draw do

  post 'meal_meet_ups'  => 'meal_meet_up#create', defaults: { format: 'json' }
  patch 'meal_meet_ups' => 'meal_meet_up#update', defaults: { format: 'json' }

  post 'members' => 'members#add_member', defaults: { format: 'json' }
end
