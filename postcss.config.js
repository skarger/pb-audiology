module.exports = ({ file, options, env }) => ({
  plugins: {
    'tailwindcss': {},
    'autoprefixer': { grid: true },
    'cssnano': env === 'production'
  }
})
