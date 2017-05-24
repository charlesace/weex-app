export default new Vue({
    data(){
        return {
            aaa:true
        }
    },

    watch:{
        aaa() {
          console.log("change")
        }
      }
})