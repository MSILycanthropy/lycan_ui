# frozen_string_literal: true

class CogUiComponent < ViewComponent::Base
  include CogUi::ClassesHelper
  include CogUi::AttributesHelper
  include CogUi::ValidationsHelper

  attr_accessor :attributes

  def initialize(**attributes)
    @attributes = attributes

    super
  end

  def generate_id(base: self.class.name.demodulize.underscore.dasherize)
    "#{base}-#{SecureRandom.uuid}"
  end
end
