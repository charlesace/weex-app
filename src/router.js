import Router from 'vue-router'
import launchScreen from './pages/launchScreen.vue'

import home from './pages/home.vue'
import me from './pages/me.vue'


Vue.use(Router)

export default new Router({
    routes: [
        { path: '/', component: launchScreen },
        { path: '/home', component: home },
        { path: '/me', component: me }
    ]
})