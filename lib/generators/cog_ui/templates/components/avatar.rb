class Avatar < Component
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

  forward_to :image

  def initialize(src:, alt: nil, loading: nil, **attributes)
    @src = src
    @alt = alt
    @loading = loading

    attributes[:tag] ||= :div
    attributes[:data] = merge_data(
      {
        data: { controller: "avatar", avatar_src_value: src },
      },
      attributes,
    )

    super(**attributes)
  end

  def call
    super { safe_join([ image, fallback ]) }
  end
end
