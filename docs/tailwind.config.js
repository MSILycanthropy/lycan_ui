const defaultTheme = require('tailwindcss/defaultTheme')
const plugin = require('tailwindcss/plugin')

const lycanUi = plugin(({ addUtilities, addVariant }) => {
  addUtilities({
    ".transition-discrete": {
      transitionBehavior: "allow-discrete"
    },
    ".interpolate-keywords": {
      interpolateSize: "allow-keywords"
    }
  })

  addVariant("starting", "@starting-style")
  addVariant("hidden", "&[hidden]")
  addVariant("details", "&::details-content")
  addVariant("details-open", "&[open]::details-content")
})

module.exports = {
  content: [
    "./pages/**/*.*",
    "./models/**/*.*",
    "./helpers/**/*.*",
    "./layouts/**/*.*",
    "../lib/generators/lycan_ui/templates/**/*.{js,erb}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    lycanUi
  ]
}
