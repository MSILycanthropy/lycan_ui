# frozen_string_literal: true

class Progress < LycanUiComponent
  attr_accessor :max, :value

  erb_template <<~ERB
    <%%= tag.progress(max:, value:, **attributes) %>
  ERB

  def initialize(max: 100, value: 0, **attributes)
    @max = max
    @value = value

    attributes[:class] = class_names(
      "appearance-none h-2 rounded-full overflow-hidden " \
        "[&::-webkit-progress-value]:transition-all [&::-webkit-progress-value]:duration-300 " \
        "[&::-webkit-progress-value]:ease-in-out [&::-webkit-progress-value]:bg-black " \
        "[&::-webkit-progress-bar]:transition-colors [&::-webkit-progress-bar]:duration-200 " \
        "[&::-webkit-progress-bar]:bg-black/10",
      attributes[:class],
    )

    super(**attributes)
  end
end
