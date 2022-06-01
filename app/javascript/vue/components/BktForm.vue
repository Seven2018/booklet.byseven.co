
<template>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-12 col-sm-5 pos-rel">
        <bkt-back-button
            iconify="iconoir:cancel"
            class="pos-abs" style="right: -25px"></bkt-back-button>
        <slot></slot>

        <bkt-button class="mt-5" type="blue" @click="$emit('submit')">
          Create
        </bkt-button>
      </div>
    </div>
  </div>
</template>
<script>
import BktBackButton from "./BktBackButton";
import BktButton from "./BktButton";
export default {
  components: {BktButton, BktBackButton}
}
</script>