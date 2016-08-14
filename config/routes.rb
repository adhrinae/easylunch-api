Rails.application.routes.draw do

  post 'meal_meet_ups'  => 'meal_meet_up#create', defaults: { format: 'json' }
  patch 'meal_meet_ups' => 'meal_meet_up#update', defaults: { format: 'json' }

  post 'members' => 'members#add_member', defaults: { format: 'json' }

  put 'meal_meet_up_tasks/menu'   => 'meet_up_tasks#menu',   defaults: { format: 'json' }
  patch 'meal_meet_up_tasks/update' => 'meet_up_tasks#update', defaults: { format: 'json' }
end
