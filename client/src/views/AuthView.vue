<script setup lang="ts">
import { ref } from 'vue'
import { supabaseClient } from '../supabase'

const loading = ref(false)
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const isSignUp = ref(false)

const handleSubmit = async () => {
    try {
        loading.value = true
        if (isSignUp.value) {
            // Sign up with email and password
            if (password.value !== confirmPassword.value) {
                throw new Error('Passwords do not match')
            }
            const { error } = await supabaseClient.auth.signUp({
                email: email.value,
                password: password.value,
            })
            if (error) throw error
            alert('Sign up successful! Please check your email for the confirmation link.')
        } else {
            // Normal login with email and password
            const { error } = await supabaseClient.auth.signInWithPassword({
                email: email.value,
                password: password.value,
            })
            if (error) throw error
            alert('Login successful!')
        }
    } catch (error) {
        if (error instanceof Error) {
            alert(error.message)
        }
    } finally {
        loading.value = false
    }
}

const toggleForm = () => {
    isSignUp.value = !isSignUp.value
    email.value = ''
    password.value = ''
    confirmPassword.value = ''
}
</script>

<template>
    <div class="auth-container">
        <div class="auth-form-container">
            <h1 class="auth-header">{{isSignUp? "SignUp" : "SignIn"}}</h1>
            <form class="auth-form" @submit.prevent="handleSubmit">
                <input class="auth-input" required type="email" placeholder="Email" v-model="email" />
                <input class="auth-input" required type="password" placeholder="Password" v-model="password" />
                <input v-if="isSignUp" class="auth-input" required type="password" placeholder="Confirm Password" v-model="confirmPassword" />
                <div>
                    <input type="submit" class="auth-button" :value="loading ? 'Loading' : (isSignUp ? 'Sign Up' : 'Sign In')" :disabled="loading" />
                </div>
            </form>
            <p class="form-toggle">
                {{ isSignUp ? 'Already have an account?' : 'Don\'t have an account yet?' }}
                <a href="#" @click.prevent="toggleForm">{{ isSignUp ? 'Sign In' : 'Sign Up' }}</a>
            </p>
        </div>
    </div>
</template>

<style scoped>
.auth-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background-color: #f5f5f5;
}

.auth-form-container {
    max-width: 500px;
    width: 100%;
    padding: 2rem;
    background-color: #fff;
    border-radius: 0.5rem;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.auth-header {
    font-size: 2rem;
    margin-bottom: 1rem;
    color: #333;
    text-align: center;
}

.auth-form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    justify-content: center;
    align-items: center;
}

.auth-input {
    width: 100%;
    padding: 0.8rem;
    border: 1px solid #ccc;
    border-radius: 0.4rem;
    font-size: 1rem;
}

.auth-button {
    padding: 0.8rem 1.6rem;
    background-color: #24b47e;
    color: #fff;
    border: none;
    border-radius: 0.4rem;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.3s ease;
    align-self: center;
}

.auth-button:hover {
    background-color: #1e9a68;
}

.auth-button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}

.form-toggle {
    margin-top: 1rem;
    font-size: 0.9rem;
    color: #666;
    text-align: center;
}

.form-toggle a {
    color: #24b47e;
    text-decoration: none;
    margin-left: 0.5rem;
    cursor: pointer;
}

.form-toggle a:hover {
    text-decoration: underline;
}
</style>