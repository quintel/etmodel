const { generateWebpackConfig, merge } = require('shakapacker');

const customConfig = {
    resolve: {
        extensions: [
            '.ts', '.tsx', '.mjs', '.js', 'sass', 'scss', 'css', 'module.sass',
            'module.scss', 'module.css', 'png', 'svg', 'gif', 'jpeg', 'jpg'
        ],
    },
};

if (process.env.SENTRY_AUTH_TOKEN) {
    const { sentryWebpackPlugin } = require('@sentry/webpack-plugin');

    customConfig.devtool = 'hidden-source-map';
    customConfig.plugins = [
        sentryWebpackPlugin({
            org: 'quintel',
            project: 'etmodel',
            authToken: process.env.SENTRY_AUTH_TOKEN,
            sourcemaps: {
                filesToDeleteAfterUpload: ['./**/*.map'],
            },
        }),
    ];
}

module.exports = merge(generateWebpackConfig(), customConfig);
