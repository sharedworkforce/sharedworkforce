SharedWorkforce::Hit.define "Approve photo" do |h|
  
  h.directions = "Please classify this photo by choosing the appropriate tickboxes."
  h.image_url = "http://www.google.com/logo.png"
  h.answer_options = ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children']
  h.responses_required = 3

  h.on_completion do |result|
    puts "Complete"
  end

  h.on_failure do |result|
    puts "Failed"
  end

end