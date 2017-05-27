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
            push: function(url) {
                this.$router.push(url)
            },

            pop: function() {
                this.$router.back()
            }
        }
    }
</script>