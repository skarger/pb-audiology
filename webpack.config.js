const path = require('path');
const glob = require('glob');

// extract CSS as separate files
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

// gzip compiled files
const CompressionPlugin = require('compression-webpack-plugin');

// remove unused CSS
const PurgecssPlugin = require('purgecss-webpack-plugin');
const PurgecssContentPaths = {
  src: path.join(__dirname, 'views'),
}
class TailwindExtractor {
  static extract(content) {
    return content.match(/[A-Za-z0-9-_:\/]+/g) || [];
  }
}

module.exports = {
  entry: path.resolve(__dirname, 'assets', 'index.js'),
  mode: process.env.NODE_ENV,
  output: {
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
            loader: MiniCssExtractPlugin.loader,
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
      },
      {
        test: /\.(png|woff|woff2|eot|ttf|svg)$/,
        loader: 'url-loader?limit=100000'
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin(),
    new CompressionPlugin(),
    new PurgecssPlugin({
      paths: glob.sync(`${PurgecssContentPaths.src}/*`),
      extractors: [
        {
          extractor: TailwindExtractor,
          extensions: ['html', 'erb'],
        }
      ],
    }),
  ],
}
