# frozen_string_literal: true

class Table < LycanUiComponent
  renders_one :head, "Head"
  renders_one :body, "Body"
  renders_one :foot, "Foot"

  erb_template <<~ERB
    <%%= tag.div(**attributes) do %>
      <table class="w-full caption-bottom text-sm">
        <%%= head %>
        <%%= body %>
        <%%= foot %>
      </table>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:class] = class_names(
      "w-full border border-black/75 rounded-xl overflow-auto relative",
      attributes[:class],
    )

    super(**attributes)
  end
end
