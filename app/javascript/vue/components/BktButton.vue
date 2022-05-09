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
        blue: "bkt-bg-blue bkt-white rounded-5px p-3 font-weight-600",
        white: "bkt-bg-white bkt-blue rounded-5px p-3 font-weight-600"
      }
    }
  },
}
</script>