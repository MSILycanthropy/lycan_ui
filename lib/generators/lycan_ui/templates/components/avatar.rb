# frozen_string_literal: true

class Avatar < LycanUiComponent
  attr_accessor :src, :alt, :loading

  renders_one :image, ->(**attributes) {
                        loading = if fallback?
                          "lazy"
                        else
                          loading
                        end
                        Image.new(alt:, loading:, **attributes)
                      }
  renders_one :fallback, "Fallback"

  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <%%= image %>
      <%%= fallback %>
    <%% end %>
  ERB


  def before_render
    with_image(alt:, loading:) unless image?
  end

  def initialize(src:, alt: nil, loading: nil, **attributes)
    @src = src
    @alt = alt
    @loading = loading

    attributes[:data] = data_attributes(
      {
        data: { controller: "avatar", avatar_src_value: src },
      },
      attributes,
    )
    attributes[:class] =
      class_names("flex items-center justify-center rounded-full overflow-hidden", attributes[:class])

    super(**attributes)
  end
end
