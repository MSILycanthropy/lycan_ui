# frozen_string_literal: true

module LycanUi
  module Helpers
    include LycanUi::AttributesHelper
    include LycanUi::ClassesHelper

    def use_id
      @counter ||= 0
      @counter += 1

      "_l#{@counter}_"
    end
  end
end
