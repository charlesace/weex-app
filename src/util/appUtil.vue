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

        getViewOption : function(key) {
            if (weex.config[key]) {
                return weex.config[key]
            }
            return this.getUrlParm(key, weex.config.bundleUrl)
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

        getUrlParm : function(key, url) {
            var reg = new RegExp('(' + key + '=)([^#,&]+)')
            var r = url.match(reg)
            if (r != null) {
                return decodeURIComponent(r[2])
            }
            return null
        },

        addUrlParm : function(key, value, url) {
            var ret = url
            var param = this.getUrlParm(key, url)
            if (param) {
                ret = this.removeUrlParm(key, url)
            }
            var posParamBegin = ret.indexOf('?')
            if (posParamBegin != -1) {
                var pre = ret.substr(0, posParamBegin + 1)
                var post = ret.substr(posParamBegin + 1)
                if (post && post != '') {
                    ret = pre + key + '=' + value + '&' + post
                }
                else {
                    ret = pre + key + '=' + value
                }
            }
            else {
                ret = ret + '?' + key + '=' + value
            }
            return ret
        },

        removeUrlParm : function(key, url) {
            var path = url
            var reg = new RegExp('(' + key + '=)([^#,&]+)')
            var r = path.match(reg)
            if (r == null) {
                return path
            }
            var str = decodeURIComponent(r[0])
            var index = r.index
            if (index + str.length < path.length && path.substr(index + str.length, 1) == '&') {
                // 后面带&
                path = path.replace(str + '&', '')
            }
            else if (index > 0 && path.substr(index - 1, 1) == '&') {
                // 前面带&
                path = path.replace('&' + str, '');
            }
            else if (index > 0 && path.substr(index - 1, 1) == '?') {
                // 前面带?
                path = path.replace('?' + str, '')
            }
            return path
        }
    }
</script>
