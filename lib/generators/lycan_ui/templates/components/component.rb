# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  include LycanUi::ClassesHelper
  include LycanUi::AttributesHelper
  include LycanUi::ValidationsHelper

  attr_accessor :attributes

  def initialize(**attributes)
    @attributes = attributes

    super
  end

  def generate_id(base: self.class.name.demodulize.underscore.dasherize)
    "#{base}-#{SecureRandom.base64(5)}"
  end
end
