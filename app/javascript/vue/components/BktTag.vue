
<template>
  <div
      class="bkt-bg-light-blue bkt-blue mr-2 rounded-10px py-2 px-2 font-weight-500"
      style="width: fit-content"
  >
    <p>
      <slot></slot>
      <span v-if="cancelable" class="p-2">x</span>
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
    }
  }
}
</script>