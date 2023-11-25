class ApprovePhotoTask
  include SharedWorkforce::Task

  title 'Approve Photo'

  instruction 'Please classify this photo by choosing the appropriate tickboxes.'
  responses_required 3

  answer_options ['Obscenity', 'Nudity', 'Blurry', 'Upside down or sideways', 'Contains more than one person in the foreground', 'Has people in the background', 'Contains children']
  answer_type :tags
  image_url "http://www.google.com/logo.png"
  html '<strong>Custom html</strong>'

  replace true
  
  on_complete :puts_complete
  on_failure :puts_failure

  def setup(photo)
    self.callback_url = "https://example.com/callback/custom/#{photo.id}"
  end

  def puts_complete(resource, results)
    puts "Complete"
  end

  def puts_failure(resource, results)
    puts "Failure"
  end
end
