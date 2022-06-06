<template>
  <div
      class=" wrap rounded-10px pos-rel"
      :class="value ? 'bkt-bg-objective-blue2' : 'bkt-bg-light-grey6'"
  >
      <div
          @click="toggle"
          class="rounded-circle pos-abs cursor-pointer"
          :class="[value ? 'bkt-bg-objective-blue circle' : 'bkt-bg-light-grey circle-disable']"
      ></div>
  </div>
</template>

<script>
export default {
  props: ['value'],
  methods: {
    toggle() {
      this.$emit('input', !this.value)
    }
  }
}
</script>

<style scoped>
.wrap {
  width: 35px;
  height: 15px
}

.circle {
  width: 23px;
  height: 23px;
  top: -4px;
  right: -5px;
}

.circle-disable {
  width: 23px;
  height: 23px;
  top: -4px;
  right: 20px;
}

.v-enter-active,
.v-leave-active {
  transition: all 3s ease-out;
}

.v-enter-from {
  transform: translateX(20px);
  /*right: 20px;*/
}

.v-leave-to {
  transform: translateX(20px);
  /*right: 20px;*/
}
</style>