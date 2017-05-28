<template>
    <scroller>
        <div class="container" @click="go">
            <text>Page1</text>
        </div>
    </scroller>
</template>

<script>
    export default{
      created: function () {
          var self = this;
           var globalEvent = require('@weex-module/globalEvent');
           globalEvent.addEventListener("geolocation",function(e){
                console.log(e)
           });
        },
        

        methods: {

          go : function() {
            // this.$router.push("/home")

            var self = this
            var eventModule = require('@weex-module/event')
            eventModule.testEvent({"a":'test.js', "b":2}, function(ret) { 
              console.log(ret)
              console.log("test finish")
            });
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