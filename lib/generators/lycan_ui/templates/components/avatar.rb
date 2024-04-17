# frozen_string_literal: true

class Avatar < LycanUiComponent
  attr_accessor :src, :alt, :loading

  renders_one :image, ->(**attributes) {
                        if fallback?
                          loading = :lazy
                        else
                          attributes[:src] = src
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
    @src = helpers.polymorphic_url(@src) unless @src.is_a?(String)

    if fallback?
      @attributes[:data] = data_attributes(
        {
          data: { controller: "avatar", avatar_src_value: src },
        },
        @attributes,
      )
    end

    with_image(alt:, loading:) unless image?
  end

  def initialize(src:, alt: nil, loading: nil, **attributes)
    @src = src
    @alt = alt
    @loading = loading

    attributes[:class] =
      class_names(
        "grid place-items-center rounded-full overflow-hidden",
        attributes[:class],
      )

    super(**attributes)
  end
end
