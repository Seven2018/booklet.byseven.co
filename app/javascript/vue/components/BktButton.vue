<template>
  <button class="flex-row-between-centered" :class="assets[type]">
    <span class="iconify" v-bind:data-icon="iconify"></span>
    <p class="ml-3">
      <slot></slot>
    </p>
  </button>
</template>

<script>
export default {
  props: {
    iconify: String,
    type: String,
  },
  data() {
    return {
      assets: {
        blue: "bkt-bg-objective-blue bkt-white rounded-5px p-3 font-weight-600 bkt-bg-light-blue2-hover",
        white: "bkt-bg-white bkt-objective-blue rounded-5px p-3 font-weight-600 bkt-box-shadow-medium bkt-bg-light-blue2-hover"
      }
    }
  },
}
</script>