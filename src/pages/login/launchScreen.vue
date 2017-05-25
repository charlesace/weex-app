<template>
    <div>
        <image class="img" resize="cover" src='../res/image/login/launch.png'></image>
    </div>
</template>

<style scoped>
    .img {
        width: 750px;
        height: 1334px;
    }
</style>

<script>
    import loginManager from '../../models/loginManager.js'

    export default {
        created : () => {
            loginManager.onLaunch()
        }
    }
</script>