<template>
  <a class="flex-row-between-centered" :class="assets[type]" :href="href">
    <span v-if="iconify" class="iconify mr-3" v-bind:data-icon="iconify"></span>
    <p class="">
      <slot></slot>
    </p>
  </a>
</template>

<script>
export default {
  props: {
    iconify: String,
    type: String,
    href: String
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