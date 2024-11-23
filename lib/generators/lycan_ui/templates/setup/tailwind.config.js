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
})

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
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
