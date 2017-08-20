class UserAuth < ApplicationRecord
  def self.current=(user_auth)
    @current_user_auth = user_auth
  end

  def self.current
    @current_user_auth
  end

  def expired?
    if Time.now.getutc - self.created_at.getutc > 3600
      @current_user_auth = nil
      true
    else
      false
    end
  end

  def self.renew
  end
end
