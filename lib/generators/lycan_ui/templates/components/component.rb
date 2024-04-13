# frozen_string_literal: true

class LycanUiComponent < ViewComponent::Base
  include LycanUi::ClassesHelper
  include LycanUi::AttributesHelper
  include LycanUi::ValidationsHelper

  attr_accessor :attributes

  def initialize(**attributes)
    @attributes = attributes

    super
  end

  def generate_id(base: self.class.name.demodulize.underscore.dasherize)
    "#{base}-#{SecureRandom.uuid}"
  end
end
