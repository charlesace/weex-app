<template>
    <div class="container">
        <text class="xxx" @click="go">Page2-click</text>
        <text class="yyy" @click="back">Page2-back</text>
        <text v-if="xxxx">other model</text>
    </div>
</template>

<script>
    import model from '../model.js'
    export default {
      computed: {
        xxxx: function () {
          return model.aaa
        }
      },

      methods: {
        go : function() {
          model.aaa = !model.aaa
        },

        back : function(){
          this.$root.back()
        }
      }
    }


</script>

<style scoped>
.container{
  background-color:red;
  top: 50px;
  width:700px;
  height: 700px;
  flex-direction:row;
}

.xxx {
  background-color:blue;
  flex:1;
  font-size: 30px;
  text-align: center;
  height: 50px;
}
.yyy {
  background-color:purple;
  flex:1;
  font-size: 30px;
  text-align: center;
  height: 50px;
}
</style>