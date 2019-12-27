/*eslint-env node*/

// Dependencies
const path = require("path")
const merge = require("webpack-merge")

const HtmlWebpackPlugin = require("html-webpack-plugin")
const MiniCssExtractPlugin = require("mini-css-extract-plugin")
const { CleanWebpackPlugin } = require("clean-webpack-plugin")
const DotEnv = require("dotenv-webpack")

// Paths
const srcPath = path.resolve(__dirname, "src")
const buildPath = path.resolve(__dirname, "build")
const distPath = path.resolve(__dirname, "dist")

// Mode
const isDev = process.env.NODE_ENV !== "production"

// Config
const common = {
  mode: isDev ? "development" : "production",
  entry: [path.join(srcPath, "main.js"), path.join(buildPath, "bundle.css")],
  output: {
    path: distPath,
    publicPath: "/",
    filename: isDev ? "[name].js" : "[name]-[hash].js",
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
        },
      },
      {
        test: /\.(scss|css)$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {
              hmr: isDev,
            },
          },
          "css-loader?url=false",
          "postcss-loader"
        ],
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: path.join(srcPath, "index.html"),
    }),
    new MiniCssExtractPlugin({
      filename: isDev ? "[name].css" : "[name]-[hash].css",
      chunkFilename: isDev ? "[id].css" : "[id]-[hash].css",
    }),
  ],
}

if (isDev) {
  module.exports = merge(common, {
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [
            "elm-hot-webpack-loader",
            {
              loader: "elm-webpack-loader",
              options: {
                debug: true,
                forceWatch: true,
                verbose: true,
              },
            },
          ],
        },
      ],
    },
    devServer: {
      historyApiFallback: true,
    },
    plugins: [
      new DotEnv(),
    ],
  })
} else {
  module.exports = merge(common, {
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: {
            loader: "elm-webpack-loader",
            options: {
              optimize: true,
            },
          },
        },
      ],
    },
    plugins: [
      new CleanWebpackPlugin({
        verbose: true,
        dry: false,
      }),
    ],
  })
}
