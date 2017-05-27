<template>
    <div>
        <!-- <image class="img" resize="cover" src='../res/image/login/launch.png'></image> -->
        <text>{{aaa}}</text>
    </div>
</template>

<style scoped>
    .img {
        width: 750px;
        height: 1334px;
    }
</style>

<script>
    export default {
        data () {
            return {
                aaa : "xxxxx"
            }
        },

        methods : {
            ttt : function() {
                this.aaa = "111"
                console.log(this)
            }
        }
    }
</script>