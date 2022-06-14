
<template>
  <div
      class="bkt-bg-light-blue bkt-blue mr-2 rounded-10px py-2 px-2 font-weight-500" :class="[cancelable ? '' : 'cursor-pointer']"
      style="width: fit-content"
      @click="$emit('click', $event)"
  >
    <p>
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
    }
  }
}
</script>