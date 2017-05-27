<template>
    <div class="container">
        <text class="xxx" @click="go">Page2-click</text>
        <text class="yyy" @click="back">Page2-back</text>
        <text v-if="xxxx">other model</text>
       <!--  <div class="row">
          <div class="piece">
            <text class="text">7</text>
          </div>
          <div class="piece">
            <text class="text">8</text>
          </div>
          <div class="piece">
            <text class="text">9</text>
          </div>
          <div class="piece">
            <text class="text">回退</text>
          </div>
        </div>
        <div class="row">
          <text class="piece">
            <text class="text">4</text>
          </text>
          <text class="piece">
            <text class="text">5</text>
          </text>
          <text class="piece">
           <text class="text">6</text> 
          </text>
          <text class="piece">
            <text class="text">-</text>
          </text>
        </div>
        <div class="row">
          <text class="piece">
            <text class="text">1</text>
          </text>
          <text class="piece">
            <text class="text">2</text>
          </text>
          <text class="piece">
            <text class="text">3</text>
          </text>
          <text class="piece">
            <text class="text">+</text>
          </text>
        </div>
        <div class="row">
          <text class="piece">
            <text class="text">0</text>
          </text>
          <text class="piece">
            <text class="text">.</text>
          </text>
          <text class="piece">
            <text class="text">清空</text>
          </text>
          <text class="piece">
            <text class="text">=</text>
          </text>
        </div> -->
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
          this.$root.pop()
        }
      }
    }


</script>

<style scoped>
.container{
    background-color:red;
    top: 50px;
    width: 700px;
    height: 700px;
    flex-direction: row;
}
.row{
    flex:1;
    /*justify-content: center;*/
    /*align-items:center;*/
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