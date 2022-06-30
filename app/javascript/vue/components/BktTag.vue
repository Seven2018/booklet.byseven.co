
<template>
  <div
      class="mr-2 rounded-15px py-1 px-3 font-weight-500 text-nowrap" :class="[cancelable ? '' : 'cursor-pointer', selected ? 'bkt-bg-light-blue bkt-blue' : 'bkt-bg-light-grey8 bkt-light-grey6']"
      style="width: fit-content"
      @click="$emit('click', $event)"
  >
    <p class="fs-1_2rem">
      <slot></slot>
      <span v-if="cancelable" @click="$emit('close', $event)" class="p-2 cursor-pointer">x</span>
    </p>
  </div>
</template>

<script>
export default {
  props: {
    cancelable: {
      type: Boolean,
      default() {
        return false
      }
    },
    selected: {
      type: Boolean,
      default() {
        return true
      }
    }
  }
}
</script>
