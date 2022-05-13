<template>
  <table class="">
    <thead>
    <tr class="border-bottom-bkt-light-grey5" :class="headerClass">
      <th v-for="col in headers">
        <p class="font-weight-500">
          {{ col }}
        </p>
      </th>
    </tr>
    </thead>
    <tbody>
    <tr v-for="row in tableData" class="border-bottom-bkt-light-grey5-not-last-child" :class="{'bkt-bg-light-grey10-hover': withoutHover === false}">
      <slot v-bind="row"></slot>
    </tr>
    </tbody>
  </table>
</template>

<script>
export default {
  props: {
    headers: Array,
    tableData: Array,
    headerClass: String,
    withoutHover: {
      type: Boolean,
      default() {
        return false
      }
    }
  }
}
</script>

<style scoped>
table {
  width: 100%;
  border-collapse: collapse;
}
table td, table th {
  padding-top: 17px;
  padding-bottom: 17px;
  vertical-align: middle;
}

</style>