const { merge } = require('webpack-merge');
const common = require('./webpack.common.js');

// Extracts CSS into .css file
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
// Removes exported JavaScript files from CSS-only entries
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');

module.exports = merge(common, {
  mode: "production",
  entry: {
    application: "./app/assets/stylesheets/application.css.sass",
    app: "./app/javascript/packs/app.ts",
    survey: "./app/javascript/packs/survey.ts"
  },
  module: {
    rules: [
      // Add CSS/SASS/SCSS rule with loaders
      {
        test: /\.(?:sa|sc|c)ss$/i,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
      },
    ],
  },
  resolve: {
    // Add additional file types
    extensions: ['.js', '.ts', '.tsx', '.sass', '.css'],
  },
  plugins: [
    // Include plugins
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin(),
  ],
  optimization: {
    moduleIds: 'deterministic',
  },
})
