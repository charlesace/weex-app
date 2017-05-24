import app from './src/app.vue'
import router from './src/router.js'


new Vue(Vue.util.extend({
        el: '#root',
        router
    },
    app
))

router.push('/')