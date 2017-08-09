<script>
    let eventModule = weex.requireModule('event')
    let navigator = weex.requireModule('navigator')

    export default {
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

        baseUrl : function() {
            let bundleUrl = weex.config.bundleUrl
            if (this.isIosPlatform()) {
                bundleUrl = bundleUrl.substring(0, bundleUrl.lastIndexOf('/') + 1)
            }
            else if (this.isAndroidPlatform()) {
                bundleUrl = 'file://assets/'
            }
            else {
                return ''
            }
            console.log(bundleUrl)
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
