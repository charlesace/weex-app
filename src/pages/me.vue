<template>
      <div class="container" @click="go">
          <text>Page1</text>
      </div>
</template>

<script>
    import AppUtil from '../util/appUtil.vue'

    export default {
      created: function () {
          let globalEvent = weex.requireModule('globalEvent')
           globalEvent.addEventListener("geolocation", (e) => {
                // console.log(e)
           });

           // console.log("hahahahahhahahahahahahahahahahah")
           // let config = this.$getConfig()
           // console.log(config)
        },
        

        methods: {
          printlog : function() {
            let eventModule = weex.requireModule('event')
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
            AppUtil.pushView('pages/home', true, {pppppppppppppp:6})
          }
        }
    }
</script>

 <style scoped>
 .container{
  background-color:purple;
  top: 50px;
  width:700px;
  height: 700px;
 }
</style>