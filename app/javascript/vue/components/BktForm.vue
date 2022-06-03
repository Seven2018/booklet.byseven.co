
<template>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-12 col-sm-5 pos-rel">
        <bkt-back-button
            iconify="iconoir:cancel"
            class="pos-abs" style="right: -25px"></bkt-back-button>
        <slot></slot>

        <bkt-button class="mt-5" style="height: 50px" type="blue" @click="$emit('submit')">
          <span v-if="loading === false">Save</span>
          <bkt-spinner
              v-show="loading"
              color="white"
              width="60px"
          ></bkt-spinner>
        </bkt-button>
      </div>
    </div>
  </div>
</template>

<script>
import BktBackButton from "./BktBackButton";
import BktButton from "./BktButton";
import BktSpinner from "./BktSpinner";
export default {
  props: {
    loading: {
      type: Boolean,
      default() {
        return false
      }
    }
  },
  components: {BktSpinner, BktButton, BktBackButton}
}
</script>