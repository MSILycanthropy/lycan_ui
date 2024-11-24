# frozen_string_literal: true

module LycanUiHelper
  def use_id
    @counter ||= 0
    @counter += 1

    "_l#{@counter}_"
  end
end
