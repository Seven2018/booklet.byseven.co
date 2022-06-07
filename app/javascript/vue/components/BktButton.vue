<template>
  <a
      :class="[`${assets[type]} ${customClass}`, iconify ? 'flex-row-between-centered' : 'flex-row-center-centered']"
      :href="href"
      :style="{right: right || 'unset', left: left || 'unset' }"
      @click="$emit('click', $event)"
  >
    <div v-if="iconify" class="flex-row-between-centered justify-content-center" style="width: 25px; height: 25px">
      <span class="iconify mr-3" v-bind:data-icon="iconify" data-width="50" data-height="50"></span>
    </div>
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
    href: String,
    customClass: '',
    right: String,
    left: String
  },
  data() {
    return {
      assets: {
        roadmap: "bkt-bg-objective-blue bkt-white-important rounded-5px p-3 font-weight-600 bkt-bg-light-blue2-hover",
        white: "bkt-bg-white bkt-objective-blue-important rounded-5px p-3 font-weight-600 bkt-box-shadow-medium bkt-bg-light-blue2-hover",
        interview: "bkt-bg-blue bkt-white-important rounded-5px p-3 font-weight-600 bkt-box-shadow-medium bkt-bg-light-blue2-hover"
      }
    }
  },
}
</script>