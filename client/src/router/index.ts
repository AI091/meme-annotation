import { createRouter, createWebHistory } from 'vue-router'
import AnnotationView from '@/views/AnnotationView.vue'
import AuthView from '@/views/AuthView.vue'
import DashboardView from '@/views/DashboardView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: '/annotate'
    },
    {
      path: '/annotate',
      name: 'annotate',
      component: AnnotationView
    },
    {
      path: '/dashboard',
      name: 'home',
      component: DashboardView
    },

    {
      path: '/auth',
      name: 'auth',
      component: AuthView
    }
  ]
})

export default router
