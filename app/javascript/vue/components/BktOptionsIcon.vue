
<template>
  <div class="bkt-light-grey5 bkt-light-grey6-hover">
    <span v-if="horizontal" class="iconify" data-icon="mi:options-horizontal" data-width="25" data-height="25"></span>
    <span v-else class="iconify" data-icon="mi:options-vertical"></span>
  </div>
</template>

<script>
export default {
  props: ['horizontal']
}
</script>