
<template>
  <div class="width-100 height-40rem black-gradient">
    <img class="width-100 h-inherit object-fit-cover" :src="url" alt="">
    <div class="width-100 height-100 d-flex flex-column justify-content-center align-items-center pos-abs bkt-white z-index-5" style="top: 0; left: 0; right: 0;">
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  props: ['url']
}
</script>
