
<template>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-12 col-sm-5 pos-rel">
        <bkt-back-button
            iconify="iconoir:cancel"
            class="pos-abs" style="right: -25px"></bkt-back-button>
        <slot></slot>
      </div>
    </div>
  </div>
</template>
<script>
import BktBackButton from "./BktBackButton";
export default {
  components: {BktBackButton}
}
</script>