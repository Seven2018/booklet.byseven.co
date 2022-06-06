<template>
  <div
      @click="back"
      class="rounded-circle bkt-box-shadow-medium p-2 cursor-pointer">
    <span class="iconify bkt-dark-grey m-0" :data-icon="iconify || 'eva:arrow-back-outline'" data-width="25" data-height="25"></span>
  </div>
</template>

<script>
export default {
  props: ['iconify'],
  methods: {
    back() {
      history.back()
    }
  }
}
</script>
