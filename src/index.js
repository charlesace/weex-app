import app from './app.vue'
// import Router from 'vue-router'
// import weexNavigator from 'weex-vue-navigator'
import router from './router.js'


// Vue.use(Router)
// Vue.use(weexNavigator, {router})


// new Vue({
//     el: '#root',
//     router,
//     render : h => h(app)
// })

new Vue(Vue.util.extend({
        el: '#root',
        router
    },
    app
))


router.push('/me')