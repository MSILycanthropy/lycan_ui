# frozen_string_literal: true

class AlertDialog < LycanUiComponent
  attr_reader :description_id, :title_id

  renders_one :title, ->(**attributes) { Title.new(id: @title_id, **attributes) }
  renders_one :description, ->(**attributes) { Description.new(id: @title_id, **attributes) }

  renders_one :confirm, "Confirm"
  renders_one :deny, "Deny"

  erb_template <<~ERB
    <%%= tag.dialog(**attributes) do %>
      <div class="flex flex-col space-y-2 text-center sm:text-left">
        <%%= title %>
        <%%= description %>
      </div>
      <div class="flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2">
        <%%= deny %>
        <%%= confirm %>
      </div>
    <%% end %>
  ERB

  def initialize(**attributes)
    attributes[:data] = data_attributes(
      {
        data: {
          controller: "alert-dialog",
          action: "turbo:submit-end@document->alert-dialog#completeSubmission",
        },
      },
      attributes,
    )

    attributes[:role] = :alertdialog

    @description_id = generate_id
    @title_id = generate_id

    attributes[:aria] = aria_attributes(
      { aria: { describedby: description_id, labelledby: title_id } },
      attributes,
    )

    attributes[:class] = class_names(
      "[&::backdrop]:bg-black/80 border border-black gap-4 " \
        "p-6 shadow-lg rounded-lg max-w-lg w-full [&[open]]:flex flex-col " \
        "data-[closing]:animate-out [&[open]:not([data-closing])]:animate-in data-[closing]:fade-out-0 " \
        "[&[open]:not([data-closing])]:fade-in-0 data-[closing]:zoom-out-95 [&[open]:not([data-closing])]:zoom-in-95 " \
        "[&[data-closing]::backdrop]:hidden",
      attributes[:class],
    )

    super(**attributes)
  end
end
