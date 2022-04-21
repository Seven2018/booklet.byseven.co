module.exports = {
  plugins: [
    require('postcss-import'), // should stay in first position
    // This plugin should probably be used as the first plugin of your list. This way, other plugins will work on the AST as if there were only a single file to process, and will probably work as you can expect.
    // https://github.com/postcss/postcss-import
    require('postcss-flexbugs-fixes'),
    require('tailwindcss')('./app/javascript/tailwind.config.js'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    })
  ]
}
