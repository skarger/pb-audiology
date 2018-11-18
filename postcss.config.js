var tailwindcss = require('tailwindcss');

module.exports = ({ file, options, env }) => ({
  plugins: {
    'tailwindcss': './tailwind.js',
    'autoprefixer': {},
    'cssnano': env === 'production'
  }
})
