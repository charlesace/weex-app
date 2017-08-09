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

        pushView : function(file, animated, callback) {
            if (!this.inited) {
                this.initAppInfo(() => {
                    this.inited = true
                    this.pushView(file, animated, callback)
                })
                return
            }
            
            let url = this.patchUrl() + file + '.js'
            this.callNative('WeexUtil', 'isFileExist', {file:url}, (ret) => {
                if (!ret) {
                    url = this.baseUrl() + file + '.js'
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
        }
    }
</script>
