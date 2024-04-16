# frozen_string_literal: true

module LycanUi
  module ClassesHelper
    def class_names(*classes)
      combined = []

      classes.each do |c|
        case c
        when Symbol
          combined << c.to_s.dasherize
        when Array
          combined << class_names(*c).presence
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
