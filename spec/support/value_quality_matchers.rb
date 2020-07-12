# frozen_string_literal: true

require "rspec/expectations"

module ValueQualityMatchers
  extend RSpec::Matchers::DSL

  matcher :be_good do
    match(&:good?)
  end

  matcher :be_bad do |description = nil|
    define_method :matches_description? do |quality|
      description.nil? || quality.to_s == description
    end

    match do |quality|
      !quality.good? && matches_description?(quality)
    end
  end
end
