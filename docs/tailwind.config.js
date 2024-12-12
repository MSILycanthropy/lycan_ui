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

const docs = plugin(({ addVariant }) => {
  addVariant("uses-helper", "body[data-use-helper=\"true\"] &")
  addVariant("no-helper", "body[data-use-helper=\"false\"] &")
})

module.exports = {
  content: [
    "./pages/**/*.*",
    "./models/**/*.*",
    "./helpers/**/*.*",
    "./layouts/**/*.*",
    "./partials/**/*.*",
    "./examples/**/*.*",
    "../lib/generators/lycan_ui/templates/**/*.{js,erb}",
  ],
  theme: {
    extend: {
      colors: {
        'on-surface': 'hsl(var(--color-on-surface))',
        'on-primary': 'hsl(var(--color-on-primary))',
        'on-secondary': 'hsl(var(--color-on-secondary))',
        'on-accent': 'hsl(var(--color-on-accent))',
        surface: {
          DEFAULT: 'hsl(var(--color-surface))',
          '50': 'hsl(var(--color-surface-50))',
          '100': 'hsl(var(--color-surface-100))', // light
          '200': 'hsl(var(--color-surface-200))',
          '300': 'hsl(var(--color-surface-300))',
          '400': 'hsl(var(--color-surface-400))',
          '500': 'hsl(var(--color-surface-500))',
          '600': 'hsl(var(--color-surface-600))',
          '700': 'hsl(var(--color-surface-700))',
          '800': 'hsl(var(--color-surface-800))',
          '900': 'hsl(var(--color-surface-900))',
          '950': 'hsl(var(--color-surface-950))', // dark
        },
        primary: {
          DEFAULT: 'hsl(var(--color-primary))',
          '50': 'hsl(var(--color-primary-50))',
          '100': 'hsl(var(--color-primary-100))',
          '200': 'hsl(var(--color-primary-200))',
          '300': 'hsl(var(--color-primary-300))',
          '400': 'hsl(var(--color-primary-400))', // dark
          '500': 'hsl(var(--color-primary-500))',
          '600': 'hsl(var(--color-primary-600))',
          '700': 'hsl(var(--color-primary-700))', // light
          '800': 'hsl(var(--color-primary-800))',
          '900': 'hsl(var(--color-primary-900))',
          '950': 'hsl(var(--color-primary-950))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--color-secondary))',
          '50': 'hsl(var(--color-secondary-50))',
          '100': 'hsl(var(--color-secondary-100))',
          '200': 'hsl(var(--color-secondary-200))',
          '300': 'hsl(var(--color-secondary-300))',
          '400': 'hsl(var(--color-secondary-400))',
          '500': 'hsl(var(--color-secondary-500))', // dark
          '600': 'hsl(var(--color-secondary-600))',
          '700': 'hsl(var(--color-secondary-700))', // light
          '800': 'hsl(var(--color-secondary-800))',
          '900': 'hsl(var(--color-secondary-900))',
          '950': 'hsl(var(--color-secondary-950))',
        },
        accent: {
          DEFAULT: 'hsl(var(--color-accent))',
          '50': 'hsl(var(--color-accent-50))',
          '100': 'hsl(var(--color-accent-100))',
          '200': 'hsl(var(--color-accent-200))',
          '300': 'hsl(var(--color-accent-300))', // dark
          '400': 'hsl(var(--color-accent-400))', // light
          '500': 'hsl(var(--color-accent-500))',
          '600': 'hsl(var(--color-accent-600))',
          '700': 'hsl(var(--color-accent-700))',
          '800': 'hsl(var(--color-accent-800))',
          '900': 'hsl(var(--color-accent-900))',
          '950': 'hsl(var(--color-accent-950))',
        },
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    lycanUi,
    docs
  ]
}
