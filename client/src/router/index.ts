import { createRouter, createWebHistory } from "vue-router";
import AnnotationView from "@/views/AnnotationView.vue";
import AuthView from "@/views/AuthView.vue";
import Account from "@/components/Account.vue";
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "home",
      component: AnnotationView,
    },
    {
      path: "/auth",
      name: "auth",
      component: AuthView,
    },
    {
      path: "/account",
      name: "acc",
      component: Account,
    },
  ],
});

export default router;
