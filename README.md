# CogUi
The name of this is tentative. Not really too sure what to call it yet.

## What is this?

Rails is in _dire_ need of UI frameworks. The JS ecosystem has all these _awesome_ UI frameworks that make building beautiful
UIs a breeze. But, Rails is missing that, and it's a pain. CogUI serves to fill that gap.

CogUI is a collection of UI components that can be easily added to your Rails app, either by copy and pasting the code, or by using a generator.

## Copy and Paste? What?

Yep, copy and paste. Inspired by [shadcn/ui](https://ui.shadcn.com/docs), CogUI just gives you the code.

The worst part about interacting with any UI framework is when you need to customize their designs or funcitonality.
If you need to do something that is outside what the component was originally designed for, you normally.. just can't.
Not to mention overriding their provided CSS is normally hellish.

CogUI provides sensible defaults for styles and functionality, that way you get something that works and follows accessibility guidelines. 

Start with the default functionality and styling, and then when you need to expand or change anything, you can.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "cog_ui", group: :development
```

And then execute:
```bash
$ bundle
```

## Usage
Say you want to install the `Button` component. You can do so by running the following command:

```bash
$ rails generate cog_ui:add button
```

You'll now see some things in `components/button.rb`, you can now use that component in _any_ view or helper like so

```erb
<%= render Button.new %>
```

## Contributing
#### TODO: Add contributing guidelines

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
