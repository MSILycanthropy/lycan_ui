# frozen_string_literal: true

class Table::Head::Cell < LycanUiComponent
  attr_reader :scope, :sort_by

  erb_template <<~ERB
    <%%= tag.th(scope:, **attributes) do %>
      <%% if sort_by.present? %>
        <%%= link_to sort_by_path, class: "flex gap-1 items-center w-fit" do %>
          <%%= content %>

          <div class="flex flex-col">
            <svg class="fill-current data-[selected]:opacity-100 opacity-50 w-3 h-3 -mb-1" xmlns="http://www.w3.org/2000/svg"
                 <%%= "data-selected" if request.query_parameters[:sort_direction] == "asc" %>
                 viewBox="0 0 320 512">
              <path d="M182.6 137.4c-12.5-12.5-32.8-12.5-45.3 0l-128 128c-9.2 9.2-11.9 22.9-6.9 34.9s16.6 19.8 29.6 19.8H288c12.9 0 24.6-7.8 29.6-19.8s2.2-25.7-6.9-34.9l-128-128z"/>
            </svg>

            <svg class="fill-current data-[selected]:opacity-100 opacity-50 w-3 h-3" xmlns="http://www.w3.org/2000/svg"
                 <%%= "data-selected" if request.query_parameters[:sort_direction] == "desc" %>
                 viewBox="0 0 320 512">
              <path d="M137.4 374.6c12.5 12.5 32.8 12.5 45.3 0l128-128c9.2-9.2 11.9-22.9 6.9-34.9s-16.6-19.8-29.6-19.8L32 192c-12.9 0-24.6 7.8-29.6 19.8s-2.2 25.7 6.9 34.9l128 128z"/>
            </svg>
          </div>
        <%% end %>
      <%% else %>
        <%%= content %>
      <%% end %>
    <%% end %>
  ERB

  def initialize(scope: :col, sort_by: nil, **attributes)
    @scope = scope
    @sort_by = sort_by&.to_s

    attributes[:class] = class_names(
      "h-12 px-4 text-left align-middle font-medium",
      attributes[:class],
    )

    super(**attributes)
  end

  private

  def sort_by_path
    params = request.query_parameters.merge({ sort_by:, sort_direction:  })

    request.path + "?" + params.to_query
  end

  def sort_direction
    return "desc" unless request.query_parameters[:sort_by] == sort_by

    request.query_parameters[:sort_direction] == "desc" ? "asc" : "desc"
  end
end
