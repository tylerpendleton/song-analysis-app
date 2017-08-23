FactoryGirl.define do
  factory :song_structure do
    
  end
  factory :song_section do
    
  end
  factory :artist do
    name "The Black Keys"
    genres ['Rock']
  end
  factory :user_auth do
    
  end
  factory :song do
    title "Song Title"
    artist "The Black Keys"
    key 5
    tempo 112
    duration_ms 2.54
  end
end
