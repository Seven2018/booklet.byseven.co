<template>
  <a
      :class="[`${assets[type]} ${customClass}`, iconify ? 'flex-row-between-centered' : 'flex-row-center-centered']"
      :style="{opacity: disable ? 0.5 : 1}"
      @click="click"
  >
    <div v-if="iconify && left" class="flex-row-between-centered justify-content-center" style="width: 25px; height: 25px">
      <span class="iconify mr-3" v-bind:data-icon="iconify" data-width="50" data-height="50"></span>
    </div>
    <p class="">
      <slot></slot>
    </p>
    <div v-if="iconify && !left" class="flex-row-between-centered justify-content-center" style="width: 25px; height: 25px">
      <span class="iconify ml-3" v-bind:data-icon="iconify" data-width="50" data-height="50"></span>
    </div>
  </a>
</template>

<script>
export default {
  props: {
    iconify: String,
    type: {
      type: String,
      default() {
        return 'transparent'
      }
    },
    href: String,
    customClass: {
      type: String,
      default() {
        return ''
      }
    },
    right: String,
    left: {
      type: Boolean,
      default() {
        return true
      }
    },
    disable: {
      type: Boolean,
      default() {
        return false
      }
    }
  },
  data() {
    return {
      assets: {
        transparent: ' bkt-dark-grey rounded-5px p-3 font-weight-500 bkt-bg-light-grey9-hover',
        roadmap: "bkt-bg-objective-blue bkt-white-important rounded-5px p-3 font-weight-600 bkt-box-shadow-medium bkt-bg-light-blue2-hover",
        white: "bkt-bg-white bkt-objective-blue-important rounded-5px p-3 font-weight-600 bkt-box-shadow-medium bkt-bg-light-blue2-hover",
        'white-interview': "bkt-bg-white bkt-blue-important rounded-5px p-3 font-weight-600 bkt-box-shadow-medium bkt-bg-light-blue-hover border-bkt-blue ",
        interview: "bkt-bg-blue bkt-white-important rounded-5px p-3 font-weight-600 bkt-box-shadow-medium bkt-bg-light-blue2-hover",
        'white-grey': 'bkt-light-grey6-important rounded-5px p-3 font-weight-600 bkt-box-shadow-medium',
        none: ''
      }
    }
  },
  methods: {
    click(e) {
      if (!this.disable) this.$emit('click', e)
      if (!this.disable && this.href) window.location = this.href
    }
  }
}
</script>
