module SongsHelper
  def length_to_time
    self.length.to_s.gsub('.',':')
  end

  def time_since_created
    time = Time.now.getutc
    created = self.created_at
    string = ""
    if time.day - created.day >= 1 && time.month - created.month < 1
      string << ( time.day - created.day ).to_s + " days ago"
    elsif time.hour - created.hour >= 1 && time.hour - created.hour <= 23
      string << ( time.hour - created.hour ).to_s + " hours ago"
    elsif time.hour - created.hour < 1 
      string << ( time.min - created.min ).to_s + " minutes ago"
    else
      string << (time.sec - created.sec).to_s + " seconds ago"
    end
    string
  end
end
