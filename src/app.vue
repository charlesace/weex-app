<template>
    <div>
        <router-view></router-view>
    </div>
</template>

<style>
</style>

<script>
    export default {
        methods: {
            push: (url) => {
                this.$router.push(url)
            },

            pop: () => {
                this.$router.back()
            }
        }
    }
</script>