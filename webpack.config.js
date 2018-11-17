const path = require('path');

module.exports = {
  entry: path.resolve(__dirname, 'assets', 'styles.css'),
  mode: process.env.NODE_ENV,
  output: {
      filename: '[name].styles.css',
      path: path.resolve(__dirname, 'public'),
  },
  mode: process.env.NODE_ENV,
  module: {
    rules: [
      {
        test: /\.css$/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'style-loader',
          },
          {
            loader: 'css-loader',
            options: {
              importLoaders: 1,
            }
          },
          {
            loader: 'postcss-loader'
          }
        ]
      }
    ]
  },
  plugins: [
  ],
}
