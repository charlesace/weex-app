import app from './app.vue'
import router from './router.js'


new Vue(Vue.util.extend({
        el: '#root',
        router
    },
    app
))


router.push('/me')