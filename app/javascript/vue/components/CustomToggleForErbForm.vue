
<template>
  <div>
    <input ref="input" type="hidden" :name="name">
    <bkt-toggle
        v-model="toggle"
        @input="$refs.input.value = $event"
    ></bkt-toggle>
  </div>
</template>

<script>
import BktToggle from "./BktToggle";
export default {
  components: {BktToggle},
  props: ['name', 'value'],
  data() {
    return { toggle: this.value}
  },
  mounted() {
    this.$refs.input.value = this.value
  }
}
</script>