# frozen_string_literal: true


require 'net/http'

namespace :simulate do
  task traffic: :environment do
    routes = Rails.application.routes.routes.map do |route|
      path = route.path.spec.to_s
      path.split('(').first if path.match?(/api/)
    end.compact

    loop do
      url = URI("http://localhost:3000#{routes.sample}")
      puts url
      Net::HTTP.get(url)
    end
  end
end
