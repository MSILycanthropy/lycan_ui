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
    content = File.read("#{path.gsub("helper/", "helper/_")}.html.erb").strip
    formatter = Rouge::Formatters::HTML.new
    lexer = Rouge::Lexers::ERB.new

    formatter.format(lexer.lex("#{content}")).html_safe
  end

  def my_avatar(**kwargs)
    ui.avatar("https://avatars.githubusercontent.com/u/53885212?v=4", **kwargs)
  end

  def repo_url
    "https://github.com/MSILycanthropy/lycan_ui"
  end
end
