
<template>
  <div class="flex-row-start-centered">
    <textarea
        :placeholder="placeholder"
        class="py-2 pl-4 bkt-bg-light-grey9-important bkt-placeholder-dark-grey rounded-5px width-100 border-none resize-none form-control"
        :class="inputClass"
        @input="$emit('input', $event.target.value)"
        :value="value"
    ></textarea>
  </div>
</template>

<script>
export default {
  props: ['placeholder', 'inputClass', 'value']
}
</script>
