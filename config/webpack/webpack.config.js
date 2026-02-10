const { generateWebpackConfig, merge } = require('shakapacker');

const customConfig = {

    resolve: {
        extensions: [
            '.ts', '.tsx', '.mjs', '.js', 'sass', 'scss', 'css', 'module.sass',
            'module.scss', 'module.css', 'png', 'svg', 'gif', 'jpeg', 'jpg'
        ],
    }

};

module.exports = merge(generateWebpackConfig(), customConfig);
