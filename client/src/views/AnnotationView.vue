<template>
    <main>
        <div class="container">
            <div class="content">
                <div class="image-container">
                    <img v-if="imageUrl" class="meme" :src="imageUrl" alt="Meme to annotate">
                </div>
                <div class="text-sections">
                    <div class="text-section">
                        <h3>Edit transcribed text:</h3>
                        <textarea v-model="transcribedText" dir="rtl" class="editable-text"></textarea>
                    </div>
                    <div class="harmful-section">
                        <div class="checkbox-group">
                            <div class="checkbox-label">
                                <input type="checkbox" id="isMeme" v-model="isMeme" class="checkbox-input">
                                <label for="isMeme">Is a Meme</label>
                            </div>
                            <div class="checkbox-label">
                                <input type="checkbox" id="harmful" v-model="isHarmful" class="checkbox-input">
                                <label for="harmful">Is Harmful</label>
                            </div>
                        </div>
                    </div>
                    <div class="button-group">
                        <button @click="handleSkip" class="skip">SKIP</button>
                        <button @click="handleSubmit" class="submit">SUBMIT</button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { supabaseClient } from "../supabase"

const isHarmful = ref(false);
const isMeme = ref(true);

const imageId = ref("")
const imageUrl = ref("")
const transcribedText = ref("")
const userId = ref("")
const maxAnnotatorsPerImage = 3

// const harmfulCategories = [
//     'Discrimination',
//     'Promoting Violence',
//     'Offensive Content',
//     'Self-Inflicted Harm',
//     'Exploitation',
//     'Sexual Content',
//     'Illicit Behavior',
//     "False Information"
// ];

const handleSubmit = async () => {

    const { data } = await supabaseClient.from("annotations").insert({
        image_id: imageId.value,
        is_meme: isMeme.value,
        is_harmful: isHarmful.value,
        transcribed_text: transcribedText.value,
        created_by: userId.value
    })

    const { data: data2 } = await supabaseClient.from("meme_images").update({
        corrected_transcribed_text: transcribedText.value,
    }).eq('id', imageId.value)

    resetInput()
    fetchImageToAnnotate()


};

const resetInput = () => {
    isHarmful.value = false;
    isMeme.value = true;
    imageId.value = ''
    imageUrl.value = ''
    transcribedText.value = ''
}

const handleSkip = async () => {
    console.log('Skipped');
    const { data } = await supabaseClient.from("annotations").insert({
        image_id: imageId.value,
        is_skipped: true,
        created_by: userId.value

    })
    resetInput()
    fetchImageToAnnotate()
};

const fetchImageToAnnotate = async () => {
    try {

        const { data, error } = await supabaseClient.rpc("get_one_meme_image", {
            "p_user_id": userId.value,
            "p_max_annotations": maxAnnotatorsPerImage,
        });
        console.log(data)
        if (error) throw error;

        if (data && data.length > 0) {
            imageUrl.value = data[0]['image_url'];
            transcribedText.value = data[0]['corrected_transcribed_text'];
            imageId.value = data[0]['id'] || ''
        }
    } catch (error) {
        console.error('Error fetching image:', error);
    }
};

onMounted(async () => {
    const session = await supabaseClient.auth.getSession();
    userId.value = session?.data?.session?.user.id ?? '';

    fetchImageToAnnotate();
});
</script>

<style scoped>
.checkbox-group {
    display: flex;
    gap: 10px;
    align-items: center;
}

.checkbox-label {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 14px;
    color: black;
}

.checkbox-input {
    appearance: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    width: 16px;
    height: 16px;
    border: 1px solid #ccc;
    border-radius: 3px;
    outline: none;
    transition: background-color 0.2s ease-in-out, border-color 0.2s ease-in-out;
}

.checkbox-input:checked {
    background-color: #2196F3;
    border-color: #2196F3;
}

.checkbox-input:checked:after {
    content: "\2714";
    font-size: 12px;
    color: white;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
}

select option {
    color: black;
}

.harmful-section {
    display: flex;
    flex-direction: row;
    gap: 15px;
    color: black;
}

.toggle-switch {
    display: flex;
    align-items: center;
    gap: 10px;
}

.toggle-input {
    display: none;
}

.toggle-label {
    position: relative;
    display: inline-block;
    width: 60px;
    height: 34px;
    background-color: #ccc;
    border-radius: 34px;
    transition: background-color 0.3s;
}

.toggle-label::after {
    content: '';
    position: absolute;
    width: 26px;
    height: 26px;
    border-radius: 50%;
    background-color: white;
    top: 4px;
    left: 4px;
    transition: 0.3s;
}

.toggle-input:checked+.toggle-label {
    background-color: #2196F3;
}

.toggle-input:checked+.toggle-label::after {
    transform: translateX(26px);
}

.toggle-text {
    font-size: 14px;
    font-weight: bold;
    color: black;
}

main {
    background-color: #f0f2f5;
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    font-family: Arial, sans-serif;
    color: black;
}

.container {
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    max-width: 800px;
    width: 100%;
    padding: 30px;
    margin: 20px;
}

.progress-bar {
    /* Add styles for progress bar */
    height: 5px;
    background-color: #e0e0e0;
    margin-bottom: 20px;
}

.content {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.image-container {
    display: flex;
    justify-content: center;
    margin-bottom: 20px;
}

.meme {
    max-width: 100%;
    max-height: 500px;
    object-fit: contain;
    cursor: pointer;
    transition: transform 0.3s ease;
}

.meme:hover {
    transform: scale(1.05);
}

.text-sections {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.text-section {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

h3 {
    margin: 0;
    font-size: 16px;
    font-weight: bold;
    color: black;
}

textarea {
    width: 100%;
    min-height: 80px;
    padding: 12px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
    resize: vertical;
    transition: border-color 0.3s ease;
    color: black;
}

textarea:focus {
    border-color: #4caf50;
    outline: none;
}

.extracted-text {
    background-color: #f9f9f9;
    color: black;
}

.harmful-section {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.checkbox-label {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 14px;
    color: black;
}

select {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
    appearance: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath d='M10.293 3.293L6 7.586 1.707 3.293A1 1 0 00.293 4.707l5 5a1 1 0 001.414 0l5-5a1 1 0 10-1.414-1.414z' fill='%23333'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 10px center;
    color: black;
}

.button-group {
    display: flex;
    gap: 15px;
    justify-content: flex-end;
    margin-top: 20px;
}

button {
    padding: 12px 24px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: bold;
    text-transform: uppercase;
    transition: background-color 0.3s ease;
    color: black;
}

.skip {
    background-color: #f0f0f0;
    color: black;
}

.skip:hover {
    background-color: #e0e0e0;
}

.submit {
    background-color: #4caf50;
    color: white;
}

.submit:hover {
    background-color: #45a049;
}

@media (max-width: 600px) {
    .container {
        padding: 20px;
    }

    .button-group {
        flex-direction: column;
    }

    button {
        width: 100%;
    }
}
</style>