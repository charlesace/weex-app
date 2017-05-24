import Router from 'vue-router'
import home from './pages/home.vue'
import me from './pages/me.vue'


Vue.use(Router)

export default new Router({
    routes: [
        { path: '/home', component: home },
        { path: '/me', component: me },
        { path: '/', redirect: '/me' }
    ]
})