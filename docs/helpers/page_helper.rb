# frozen_string_literal: true

module PageHelper
  def link_to_page(page)
    link_to(page.data.fetch("title", page.request_path), page.request_path)
  end

  def link_to_if_current(text, page, active_class: "active")
    if page == current_page
      link_to(text, page.request_path, class: active_class)
    else
      link_to(text, page.request_path)
    end
  end

  def read_erb(path)
    File.new("#{path.gsub("/helper/", "/helper/_")}.html.erb").read
  end

  def read_js(component)
    File.new("../lib/generators/lycan_ui/templates/javascript/#{component}_controller.js").read
  end

  def my_avatar(**kwargs)
    ui.avatar("https://avatars.githubusercontent.com/u/53885212?v=4", **kwargs)
  end

  def repo_url
    "https://github.com/MSILycanthropy/lycan_ui"
  end
end
