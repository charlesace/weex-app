# weex-app

> demo run on web & ios

## getting start

```bash
npm install
```

## file structure

* `src/*`: all source code
* `app.js`: entrance of the Weex page
* `build/*`: some build scripts
* `bundlejs/*`: where places generated code for ios & android (coming soon)
* `dist/*`: where places generated code for web
* `assets/*`: some assets for Web preview
* `index.html`: a page with Web preview and qrcode of Weex js bundle
* `weex.html`: Web render
* `.babelrc`: babel config (preset-2015 by default)
* `.eslintrc`: eslint config (standard by default)

## npm scripts

```bash
# build separated files for native (/platform/ios/habit-weex/AppDelegate.m  Line:35)
weex compile src bundlejs

# build one file for web (/dist/app.web.js) & native (/dist/app.weex.js) (/platform/ios/habit-weex/AppDelegate.m  Line:36)
npm run dev

# start a Web server at 8080 port
npm run serve

# start weex-devtool for debugging with native
npm run debug
```

## notes

You can config more babel, ESLint and PostCSS plugins in `webpack.config.js`.
