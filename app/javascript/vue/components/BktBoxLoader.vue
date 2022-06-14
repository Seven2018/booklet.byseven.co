
<template>
  <div class="width-100 h-70vh flex-row-center-centered justify-content-center">
    <lottie-player v-show="type === 'roadmap'" src="https://assets4.lottiefiles.com/packages/lf20_vno5ch9h.json"  background="transparent"  speed="1" loop  autoplay :style="{width:  '100px', height:  '100px'}"></lottie-player>
    <lottie-player v-show="type === 'interview'" src="https://assets9.lottiefiles.com/packages/lf20_8qz5naxh.json"  background="transparent"  speed="1" loop  autoplay :style="{width:  '100px', height:  '100px'}"></lottie-player>
  </div>
</template>

<script>
export default {
  props: ['type']
}
</script>