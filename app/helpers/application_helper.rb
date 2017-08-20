module ApplicationHelper
  def duration(ms)
    Time.at(ms).utc.strftime('%M:%S') unless ms == nil
  end
end
