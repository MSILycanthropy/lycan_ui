# frozen_string_literal: true

module CogUi
  module ClassesHelper
    def merge_classes(*classes)
      combined = []

      classes.each do |c|
        case c
        when Symbol
          combined << c.to_s.dasherize
        when Array
          combined << merge_classes(*c).presence
        when Hash
          c.each do |key, value|
            combined << key.to_s.dasherize if value
          end
        else
          combined << c
        end
      end

      combined.reject(&:blank?).compact.uniq.join(" ")
    end
  end
end
