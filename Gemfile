# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in lycan_ui.gemspec.
gemspec

gem "puma"

gem "sqlite3"

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"
group :development do
  gem "rubocop", require: false
  gem "rubocop-shopify", require: false
  gem "rubocop-rails-omakase", require: false
end
