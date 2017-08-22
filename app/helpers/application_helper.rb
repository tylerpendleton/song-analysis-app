module ApplicationHelper
  def duration(ms)
    return '' unless ms
    minutes, ms = ms.divmod(1000 * 60)
    seconds, ms = ms.divmod(1000)
    seconds = "0#{seconds}" if seconds < 10
    "#{minutes.to_s}:#{seconds.to_s}"
  end
  def print_genres(genres)
    genres.map {|g| g.split.map{|s| s.capitalize }.join(' ') }.join(", ")
  end
end
