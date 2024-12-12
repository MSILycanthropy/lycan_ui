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

  def external_link_to(link, &block)
    link_to(
      link,
      target: :_blank,
      class: 'inline-flex gap-1 items-center text-black hover:underline hover:text-black/90 transition-all',
    ) do
      safe_join([
        capture(&block),
        lucide_icon('external-link', class: 'size-4'),
      ])
    end
  end

  def code(stuff)
    tag.code(class: 'bg-surface-100 border border-on-surface/15 px-1 rounded shadow-lg') { stuff }
  end

  def helper_code(helper, no_helper)
    safe_join([
      tag.code(class: 'bg-surface-100 border border-on-surface/15 px-1 rounded shadow-lg uses-helper:inline', hidden: '') { helper },
      tag.code(class: 'bg-surface-100 border border-on-surface/15 px-1 rounded shadow-lg no-helper:inline', hidden: '') { no_helper },
    ])
  end

  def read_erb(path)
    content = File.read("#{path.sub(%r{/(?!.*/)}, "/_")}.html.erb").strip
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