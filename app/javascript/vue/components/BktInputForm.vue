
<template>
  <div class="flex-row-start-centered">
    <input
        :placeholder="placeholder"
        :type="type || 'text'"
        class="py-2 pl-4 bkt-bg-light-grey9 bkt-placeholder-dark-grey rounded-5px width-100 border-none form-control"
        :class="inputClass"
    >
  </div>
</template>

<script>
export default {
  props: ['placeholder', 'inputClass', 'type']
}
</script>