Hci::Client.load_path = Rails.root + Hci::Client.load_path
Rails.configuration.after_initialize do
  Hci::Client.load!
end