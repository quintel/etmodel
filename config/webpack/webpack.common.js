const path    = require("path")
const webpack = require("webpack")

module.exports = {
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
    ],
  },
  resolve: {
    // Add additional file types
    extensions: ['.js', '.ts', '.tsx', '.sass', '.css'],
  },
  optimization: {
    moduleIds: 'deterministic',
  },
}
