<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { supabaseClient } from './supabase'
import AuthView from "./views/AuthView.vue"
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()
const session = ref()

onMounted(async () => {
  supabaseClient.auth.getSession().then(({ data }) => {
    session.value = data.session
  })

  supabaseClient.auth.onAuthStateChange((_, _session) => {
    session.value = _session
  })
})

const handleLogout = async () => {
  try {
    await supabaseClient.auth.signOut()
    router.push('/') // Redirect to home page after logout
  } catch (error) {
    console.error('Error logging out:', error)
  }
}
</script>

<template>
  <div class="app-container">
    <nav class="navbar" v-if="session">
      <div class="navbar-brand">
        <router-link to="/" class="navbar-item">Annotation Tool</router-link>
      </div>
      <div class="navbar-menu">
        <div class="navbar-start">
          <router-link to="/dashboard" class="navbar-item"
            :class="{ 'is-active': route.path === '/dashboard' }">Dashboard</router-link>
          <router-link to="/annotate" class="navbar-item"
            :class="{ 'is-active': route.path === '/annotate' }">Annotate</router-link>
        </div>
        <div class="navbar-end">
          <a class="navbar-item" @click="handleLogout">Logout</a>
        </div>
      </div>
    </nav>
    <div class="content-container">
      <router-view v-if="session" :session="session" />
      <AuthView v-else />
    </div>
  </div>
</template>

<style scoped>
.app-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f8f8f8;
}

.navbar {
  background-color: #3f51b5;
  color: #fff;
  display: flex;
  justify-content: space-between;
  padding: 1rem;
}

.navbar-brand .navbar-item {
  font-weight: bold;
  color: #fff;
  text-decoration: none;
}

.navbar-menu {
  display: flex;
  align-items: center;
}

.navbar-start,
.navbar-end {
  display: flex;
  gap: 1rem;
}

.navbar-item {
  color: #fff;
  text-decoration: none;
  padding: 0.5rem;
}

.navbar-item:hover,
.navbar-item.is-active {
  background-color: #5c6bc0;
}

.content-container {
  flex-grow: 1;
  padding: 1rem;
}

.annotation-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: calc(100vh - 80px);
  /* Subtract the height of the navbar */
}

.annotation-card {
  max-width: 800px;
  width: 100%;
  padding: 2rem;
  background-color: #fff;
  border-radius: 0.5rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.annotation-header {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: #333;
  text-align: center;
}

.annotation-images {
  display: flex;
  justify-content: center;
  gap: 1rem;
  margin-bottom: 1rem;
}

.annotation-image {
  max-width: 200px;
  max-height: 200px;
}

.annotation-form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.form-group {
  display: flex;
  flex-direction: column;
}

.form-textarea {
  width: 100%;
  padding: 0.8rem;
  border: 1px solid #ccc;
  border-radius: 0.4rem;
  font-size: 1rem;
  resize: vertical;
}

.form-checkboxes {
  display: flex;
  gap: 1rem;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.9rem;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
}

.button {
  padding: 0.8rem 1.6rem;
  border-radius: 0.4rem;
  font-size: 1rem;
  cursor: pointer;
}

.button.is-light {
  background-color: #f8f8f8;
  color: #333;
  border: 1px solid #ccc;
}

.button.is-primary {
  background-color: #3f51b5;
  color: #fff;
  border: none;
}
</style>