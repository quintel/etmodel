class RoundsController < ApplicationController
  layout 'pages'
  
  def index
    @rounds = Round.order(:position)

    if params[:activate]
      complete_active_round

      
      round = Round.find(params[:activate])
      activate_round(round,params[:value])

      unless params[:activate] == "4"
        # option = round.generate_policy_update_params(params[:value])
        #         Current.setting.update_input_elements(option)
      end
    end
  end
  
  
  
  def finish
    complete_active_round
    notify_trackable_users
    redirect_to :action => 'index'
  end
  
  def complete_active_round
    old_round = Round.where("active = 1").first
    if old_round
      old_round.active = false
      old_round.completed = true
      old_round.save
    end
  end
  
  def activate_round(round,value)
    round.active = true
    round.value = value
    round.save
  end
  
  
  
  def reset
    if params[:reset]
      Round.all.each do |r|
        r.active = 0
        r.completed = 0
        r.value = nil
        r.save
      end
    end
    redirect_to :action => 'index'
  end

  
  def notify_trackable_users
    User.where("trackable = 1").map{|u| u.update_attributes(:send_score => true)}
  end
end