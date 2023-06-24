class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  before_action :set_host

  private

  def set_host
    default_url_options[:host] = ENV["host_#{Rails.env}"]
  end
end

