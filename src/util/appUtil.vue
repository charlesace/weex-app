<script>
    let eventModule = weex.requireModule('event')
    let navigator = weex.requireModule('navigator')

    export default {
        inited : false,
        isRelease : true,
        version : '',
        appPath : '',
        patchPath : '',

        isIosDevice : function() {
            return (weex.config.env.osName == "iOS")
        },

        isAndroidDevice : function() {
            return (weex.config.env.osName == "Android")
        },

        isIosPlatform : function() {
            return (weex.config.env.platform == "iOS")
        },

        isAndroidPlatform : function() {
            return (weex.config.env.platform == "Android")
        },

        isWebPlatform : function() {
            return (weex.config.env.platform == "Web")
        },

        callNative : function(module, method, params, callback) {
            if (this.isWebPlatform()) {
                if (callback) {
                    callback({})
                }
                return
            }
            eventModule.jsCall(module, method, params, callback)
        },

        initAppInfo : function(callback) {
            this.callNative('WeexUtil', 'initAppInfo', null, (ret) => {
                this.isRelease = ret.release
                this.version = ret.version
                this.appPath = ret.appPath
                this.patchPath = ret.patchPath

                if (callback) {
                    callback()
                }
            })
        },

        baseUrl : function() {
            return this.appPath + '/bundlejs/'
        },

        patchUrl : function() {
            return this.patchPath + '/bundlejs/'
        },

        pushView : function(file, animated, options, callback) {
            if (!this.inited) {
                this.initAppInfo(() => {
                    this.inited = true
                    this.pushView(file, animated, options, callback)
                })
                return
            }
            
            let url = this.patchUrl() + file + '.js'
            this.callNative('WeexUtil', 'isFileExist', {file:url}, (ret) => {
                if (!ret) {
                    url = this.baseUrl() + file + '.js'
                }
                if (options) {
                    url = this.getAbsUrl(url, options)
                }
                let anim = animated ? 'true' : 'false'
                let params = {
                    'url': 'file://' + url,
                    'animated' : anim
                }
                navigator.push(params, callback)
            })
        },

        popView : function(animated, callback) {
            let anim = animated ? 'true' : 'false'
            let params = {
                'animated' : anim
            }
            navigator.pop(params, callback)
        },

        getViewOptions : function() {
            let url = weex.config.bundleUrl
            let result = this.deepClone(weex.config)
            delete result.bundleUrl
            delete result.env
            delete result.debug
            let pos = url.indexOf('?')
            if (pos != -1) {
                var str = url.substr(pos + 1)
                var strs = str.split('&')
                for (var i = 0; i < strs.length; i++) {
                    result[strs[i].split('=')[0]] = unescape(strs[i].split('=')[1])
                }
            }
            return result
        },

        getViewOption : function(key) {
            let obj = this.getViewOptions()
            return obj[key]
        },

        getAbsUrl : function(domain, params) {
            let url = domain
            let i = 0
            for (var key in params) {
                if (i == 0) {
                    url += '?'
                }
                else {
                    url += '&'
                }

                url += key + '=' + params[key]
                i++
            }
            return encodeURI(url)
        },

        deepClone : function(source) {
            let newObject = {}
            for (var key in source) {
                newObject[key] = (typeof(source[key]) === 'object') ? this.deepClone(source[key]) : source[key]
            }
            return newObject
        }
    }
</script>
