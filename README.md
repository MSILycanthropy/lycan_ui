# CogUi
The name of this is tentative. Not really too sure what to call it yet.

## What is this?

Rails is in _dire_ need of UI frameworks. The JS ecosystem has all these _awesome_ UI frameworks that make building beautiful
UIs a breeze. But, Rails is missing that, and it's a pain. CogUI serves to fill that gap.

CogUI is a collection of UI components that can be easily added to your Rails app, either by copy and pasting the code, or by using a generator.

## Copy and Paste? What?

Yep, copy and paste. Inspired by [shadcn/ui](https://ui.shadcn.com/docs), CogUI just gives you the code.

The worst part about interacting with any UI framework is when you need to customize their designs or funcitonality. If you're designs change outside
the scope of what they were initially designed with it can become _impossible_ to do what your app needs.

But, with CogUI, you have all the code, so you can just modify it to your hearts content.

CogUI provides sensible defaults for styles and functionality. But go crazy with it, it's _your_ code.

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

## Contributing
# TODO: Add contributing guidelines

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
