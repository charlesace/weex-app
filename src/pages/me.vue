<template>
    <scroller>
        <div class="container" @click="go">
            <text>Page1</text>
        </div>
    </scroller>
</template>

<script>
    export default{
        methods: {
        go : function() {
          this.$router.push("/home")
        }
      }
    }
</script>

 <style scoped>
 .container{
  background-color:green;
  top: 50px;
  width:700px;
  height: 7000px;
 }
</style>