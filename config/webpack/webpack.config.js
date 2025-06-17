const { generateWebpackConfig, merge } = require('shakapacker');
const webpackConfig = generateWebpackConfig();
const customConfig = {

    resolve: {
        extensions: [
            '.ts', '.tsx', '.mjs', '.js', 'sass', 'scss', 'css', 'module.sass',
            'module.scss', 'module.css', 'png', 'svg', 'gif', 'jpeg', 'jpg'
        ],
    }

};

module.exports = merge(webpackConfig, customConfig);
