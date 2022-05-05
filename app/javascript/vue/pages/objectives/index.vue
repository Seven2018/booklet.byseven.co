<template>
  <div class="width-80 mt-5 mx-auto">
    <div class="flex-row-between-centered ">
      <div class="flex-column">
        <h1 class="font-weight-700 fs-2_4rem">Employees objectives</h1>
      </div>
      <div class="flex-column">
        <bkt-button type="blue" iconify="ant-design:plus-circle-outlined">
          New objective
        </bkt-button>
      </div>
    </div>
  </div>
</template>

<script>
import BktButton from '../../components/BktButton.vue'

export default {
  components: {
    BktButton,
  }
}
</script>