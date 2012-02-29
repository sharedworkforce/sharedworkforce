module SharedWorkforce
  class Error < RuntimeError; end
  class ConfigurationError < Error; end
  class TaskNotFound < Error; end
end