
<template>
  <div class="flex-row-start-centered">
    <input
        :placeholder="placeholder"
        :type="type || 'text'"
        class="py-2 pl-4 bkt-bg-light-grey9-important bkt-placeholder-dark-grey rounded-5px width-100 border-none form-control"
        :class="inputClass"
        @input="$emit('input', $event.target.value)"
        :value="value"
    >
  </div>
</template>

<script>
export default {
  props: ['placeholder', 'inputClass', 'type', 'value']
}
</script>
