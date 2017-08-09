<template>
    <div class="container">
        <test-component></test-component>
        <text class="xxx" @click="back">Page2-click</text>
    </div>
</template>

<script>
    import Component1 from '../component/compoent.test.vue'
    import AppUtil from '../util/appUtil.vue'

    export default {
      created : function() {
        console.log(AppUtil.getViewOption('debug'))
        console.log(AppUtil.getViewOptions())
        console.log(weex.config)
      },

      methods : {
        back : function(){
          AppUtil.popView(true)
        }
      },

      components: {
        testComponent : Component1
      }
    }


</script>

<style scoped>
.container{
    background-color:yellow;
    top: 50px;
    width: 700px;
    height: 700px;
    flex-direction: row;
}
.row{
    flex:1;
    flex-direction: row;
    margin-top: 10px;
    margin-bottom: 10px;
  }

.piece {
  justify-content: center;
  flex:1;
  border-width:1;
  margin-left: 20px;
  margin-right: 20px;
  vertical-align: middle;
}

.text {
    text-align: center;
    font-size: 20vw;
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