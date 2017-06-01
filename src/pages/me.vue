<template>
    <scroller>
        <div class="container" @click="printlog">
            <text>Page1</text>
        </div>
    </scroller>
</template>

<script>
    export default{
      created: function () {
           let globalEvent = require('@weex-module/globalEvent');
           globalEvent.addEventListener("geolocation", (e) => {
                // console.log(e)
           });

           // console.log("hahahahahhahahahahahahahahahahah")
           // let config = this.$getConfig()
           // console.log(config)
        },
        

        methods: {
          printlog : function() {
            let eventModule = require('@weex-module/event')

            eventModule.jsCall("PaymentManager", "doSomething", {"a":'test.js', "b":2}, (ret) => { 
              console.log(ret)
              console.log("jsCall finish")
            });

            // eventModule.jsCall("PaymentManager", "doSomething", {}, (ret) => { 
            //   console.log(ret)
            //   console.log("jsCall finish")
            // });

            // eventModule.jsCall("PaymentManager", "doSomething", {a:1});

            // eventModule.jsCall("PaymentManager", "doSomething");
          },

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