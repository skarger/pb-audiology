var tailwindcss = require('tailwindcss');

module.exports = ({ file, options, env }) => ({
  plugins: {
    'tailwindcss': tailwindcss,
    'autoprefixer': { grid: true },
    'cssnano': env === 'production'
  }
})
