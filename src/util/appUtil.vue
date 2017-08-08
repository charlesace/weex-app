<script>
    let eventModule = weex.requireModule('event')
    let navigator = weex.requireModule('navigator')

    export default {
        isIosDevice : function() {
            return (weex.config.env.platform == "iOS")
        },

        isAndroidDevice : function() {
            return (weex.config.env.platform == "android")
        },

        isIosNativeApp : function() {
            let bundleUrl = weex.config.bundleUrl
            return (bundleUrl.indexOf('file:///') >= 0)
        },

        isAndroidNativeApp : function() {
            let bundleUrl = weex.config.bundleUrl
            return (bundleUrl.indexOf('file://assets/') >= 0)
        },

        baseUrl : function() {
            let bundleUrl = weex.config.bundleUrl
            if (this.isIosNativeApp()) {
                bundleUrl = bundleUrl.substring(0, bundleUrl.lastIndexOf('/') + 1)
            }
            else if (this.isAndroidNativeApp()) {
                bundleUrl = 'file://assets/'
            }
            else {
                return ''
            }
            return bundleUrl
        },

        pushView : function(file, animated, callback) {
            let url = this.baseUrl() + file + '.js'
            let anim = animated ? 'true' : 'false'
            let params = {
              'url': url,
              'animated' : anim
            }
            navigator.push(params, callback)
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
