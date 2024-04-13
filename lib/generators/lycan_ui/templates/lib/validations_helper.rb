# frozen_string_literal: true

module LycanUi
  module ValidationsHelper
    class ArgumentError < StandardError
      def initialize(argument, message)
        super("Invalid argument: #{argument}. #{message}")
      end
    end

    class AccessibilityError < StandardError
      def initialize(message)
        super(message)
      end
    end

    def deny_argument(argument_name, message, **arguments)
      raise ArgumentError.new(argument_name, message) if arguments[argument_name].present?
    end

    def validates_argument_type(argument, type)
      raise ArgumentError.new(
        argument,
        "Expected type: #{type}. Got type: #{argument.class}",
      ) unless argument.is_a?(type)
    end

    def validates_argument_in(argument, array)
      raise ArgumentError.new(argument, "Expected one of: #{array}. Got: #{argument}") if array.exclude?(argument)
    end

    def validates_argument_not_nil(argument)
      raise ArgumentError.new(argument, "Expected not nil. Got: nil") if argument.nil?
    end

    def validates_argument_not_empty(argument)
      raise ArgumentError.new(argument, "Expected not empty. Got: #{argument}") if argument.empty?
    end
  end
end
