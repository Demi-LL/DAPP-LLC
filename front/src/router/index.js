import { createRouter, createWebHistory } from "vue-router";

const routes = [
  {
    path: "/",
    name: "home",
    component: () => import("../views/Home.vue"),
  },
  {
    path: "/list",
    name: "list",
    component: () => import("../views/List.vue"),
  },
];

export default createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});
