redis_url = ENV.fetch('REDIS_URL')
redis_db = ENV.fetch('REDIS_DB', '0')

Sidekiq.configure_client do |config|
  config.redis = { url: "#{redis_url}/#{redis_db}", size: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { url: "#{redis_url}/#{redis_db}", size: 10 }

  schedule_file = Rails.root.join("config", "sidekiq_schedule.yml")
  if File.exist?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_file))
  end
end
