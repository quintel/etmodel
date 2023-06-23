const { merge } = require('webpack-merge');
const common = require('./webpack.common.js');

module.exports = merge(common, {
  mode: "development",
  devtool: "source-map",
  devServer: {
    // static: ['./app/assets/javascripts', './app/assets/stylesheets'],
    allowedHosts: 'auto',
    port: 3035,
    // watchFiles: ['app/javascripts/**/*'],
    open: false,
    client: {
      overlay: true,
    },
  },
  optimization: {
    runtimeChunk: 'single',
  },
})
