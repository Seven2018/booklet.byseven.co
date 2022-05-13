<template>
  <div
      v-click-outside="hide"
      class="position-relative">
    <button
        @click="toggleDisplay"
        class="bkt-bg-light-grey5-hover bkt-light-grey5 bkt-light-grey6-hover bkt-white-onclick px-1 rounded-2px">
      <span class="iconify" data-icon="ep:more-filled" data-width="25"></span>
    </button>
    <div
        v-if="display"
        class="position-absolute bkt-bg-white rounded-5px bkt-box-shadow-medium z-index-5 width-max-content"
    >
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      display: false
    }
  },
  methods: {
    toggleDisplay() {
      this.display = !this.display
    },
    hide() {
      this.display = false
    }
  }
}
</script>
