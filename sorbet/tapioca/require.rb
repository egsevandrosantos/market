# typed: true
# frozen_string_literal: true

require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "active_model/railtie"
require "active_record/railtie"
require "active_support/core_ext/integer/time"
require "bundler/setup"
require "rails"
require "rails/test_help"
require "rails/test_unit/railtie"
require "sidekiq/web"
require "sorbet-runtime"
