<template>
<!--  <div class="lds-ring">-->
<!--    <div></div>-->
<!--    <div></div>-->
<!--    <div></div>-->
<!--    <div></div>-->
<!--  </div>-->
  <div class="flex-row-between-centered align-items-center">
    <lottie-player v-show="color === 'blue'" src="https://assets10.lottiefiles.com/packages/lf20_hmnalrkv.json"  background="transparent"  speed="1" loop  autoplay :style="{width: width || '30px', height: height || '30px'}"></lottie-player>
    <lottie-player v-show="color === 'red'" src="https://assets2.lottiefiles.com/packages/lf20_rjfxtksx.json"  background="transparent"  speed="1" loop  autoplay :style="{width: width || '30px', height: height || '30px'}"></lottie-player>
    <lottie-player v-show="color === 'white'" src="https://assets6.lottiefiles.com/packages/lf20_0npgmmyq.json"  background="transparent"  speed="1" loop  autoplay :style="{width: width || '30px', height: height || '30px'}"></lottie-player>
    <span class="pr-2">
      <slot></slot>
    </span>
  </div>
</template>

<script>
export default {
  props: ['color', 'width', 'height']
}
</script>

<style scoped>
/*lottie-player {*/
/*  width: 30px;*/
/*  height: 30px*/
/*}*/
/*.lds-ring {*/
/*  display: inline-block;*/
/*  position: relative;*/
/*  !*width: 80px;*!*/
/*  !*height: 80px;*!*/
/*}*/

/*.lds-ring div {*/
/*  top: -20px;*/
/*  left: -15px;*/
/*  box-sizing: border-box;*/
/*  display: block;*/
/*  position: absolute;*/
/*  !*width: 64px;*!*/
/*  !*height: 64px;*!*/
/*  margin: 8px;*/
/*  border: 8px solid #fff;*/
/*  border-radius: 50%;*/
/*  animation: lds-ring 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;*/
/*  border-color: #fff transparent transparent transparent;*/
/*}*/

/*.lds-ring div:nth-child(1) {*/
/*  animation-delay: -0.45s;*/
/*}*/

/*.lds-ring div:nth-child(2) {*/
/*  animation-delay: -0.3s;*/
/*}*/

/*.lds-ring div:nth-child(3) {*/
/*  animation-delay: -0.15s;*/
/*}*/

/*@keyframes lds-ring {*/
/*  0% {*/
/*    transform: rotate(0deg);*/
/*  }*/
/*  100% {*/
/*    transform: rotate(360deg);*/
/*  }*/
/*}*/
</style>