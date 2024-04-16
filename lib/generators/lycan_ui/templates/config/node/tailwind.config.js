module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/components/**/*.{rb,erb,haml,html,slim}',
  ],
  plugins: [require('tailwindcss-animate')]
}
