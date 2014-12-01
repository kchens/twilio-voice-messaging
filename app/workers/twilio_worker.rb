class TwilioWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options retry: false

  sidekiq_retries_exhausted do |msg|
  Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}."
  end
  recurrence { minutely }

  def perform(data)
    client = Twilio::REST::Client.new(ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"])
    p "*" * 70
    p data
    p "*" * 70
    client.account.calls.create data
  end
end