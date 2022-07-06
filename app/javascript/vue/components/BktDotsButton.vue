<template>
  <div
      v-click-outside="hide"
      class="position-relative">
    <button
        @click.stop="toggleDisplay"
        class="bkt-bg-light-grey5-hover bkt-light-grey5 bkt-light-grey6-hover bkt-white-onclick px-1 py-1 rounded-2px">
      <span class="iconify" data-icon="ep:more-filled" data-width="25"></span>
    </button>
    <transition>
      <div
          v-if="display"
          class="position-absolute bkt-bg-white rounded-5px bkt-box-shadow-medium z-index-5 width-max-content"
          style="right: 0"
      >
        <slot></slot>
      </div>
    </transition>
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

<style scoped>
.v-enter-active,
.v-leave-active {
  transition: all 0.5s ease;
}

.v-enter,
.v-leave-to {
  opacity: 0;
  transform: translate(20px);
  /*transform: scale(0)*/
}

.v-enter-to {
  /*opacity: 1;*/
  /*transform: translate(0px);*/
}


</style>