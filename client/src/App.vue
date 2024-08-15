<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { supabaseClient } from './supabase'
import Authciew from "./views/AuthView.vue"
const session = ref()


onMounted(async () => {
  supabaseClient.auth.getSession().then(({ data }) => {
    session.value = data.session
  })

  supabaseClient.auth.onAuthStateChange((_, _session) => {
    session.value = _session
  })
})


</script>

<template>

  <router-view v-if="session" :session="session" />
  <Authciew v-else />

</template>