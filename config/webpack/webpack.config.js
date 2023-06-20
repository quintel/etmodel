const path    = require("path")
const webpack = require("webpack")


// // Extracts CSS into .css file
// // TODO: only do this in production
// const MiniCssExtractPlugin = require('mini-css-extract-plugin');
// // Removes exported JavaScript files from CSS-only entries
// // in this example, entry.custom will create a corresponding empty custom.js file
// const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');


module.exports = {
  mode: "production",
  devtool: "source-map",
  entry: {
    app: "./app/javascript/packs/app.ts",
    survey: "./app/javascript/packs/survey.ts"
  },
  output: {
    filename: "[name].js",
    sourceMapFilename: "[file].map",
    path: path.resolve(__dirname, '..', '..', 'app/assets/builds'),
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    })
  ],
  module: {
    rules: [
      {
        test: /\.(js|ts|tsx|)$/,
        exclude: /node_modules/,
        use: ['babel-loader'],
      },
      {
        test: /\.(png|jpe?g|gif|eot|woff2|woff|ttf|svg)$/i,
        type: 'asset/resource',
        use: 'file-loader',
      },
      // // Add CSS/SASS/SCSS rule with loaders
      // {
      //   test: /\.(?:sa|sc|c)ss$/i,
      //   use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
      // },
    ],
  },
  resolve: {
    // Add additional file types
    extensions: ['.js', '.ts', '.tsx',],//'.sass', '.css'],
  },
  // plugins: [
  //   // Include plugins
  //   new RemoveEmptyScriptsPlugin(),
  //   new MiniCssExtractPlugin(),
  // ],
}
