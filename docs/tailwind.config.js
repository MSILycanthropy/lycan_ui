const defaultTheme = require('tailwindcss/defaultTheme')
const plugin = require('tailwindcss/plugin')

const lycanUi = require('../lib/generators/lycan_ui/templates/setup/tailwind.config')

const docs = plugin(({ addVariant }) => {
  addVariant("uses-helper", "body[data-use-helper=\"true\"] &")
  addVariant("no-helper", "body[data-use-helper=\"false\"] &")
})

module.exports = {
  ...lycanUi,
  content: [
    "./pages/**/*.*",
    "./models/**/*.*",
    "./helpers/**/*.*",
    "./layouts/**/*.*",
    "./partials/**/*.*",
    "./examples/**/*.*",
    "../lib/generators/lycan_ui/templates/**/*.{js,erb}",
  ],
  plugins: [...lycanUi.plugins, docs]
}
