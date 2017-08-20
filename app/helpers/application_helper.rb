module ApplicationHelper
  def duration(ms)
    Time.at(ms).utc.strftime('%M:%S') unless ms == nil
  end
  def print_genres(genres)
    genres.map {|g| g.split.map{|s| s.capitalize }.join(' ') }.join(", ")
  end
end
