<template>
  <table class="">
    <thead>
    <tr>
      <th v-for="col in headers">
        <p class="font-weight-500">
          {{ col }}
        </p>
      </th>
    </tr>
    </thead>
    <tbody>
    <tr v-for="row in tableData" class="border-bottom-bkt-light-grey5-not-last-child ">
      <slot v-bind="row"></slot>
    </tr>
    </tbody>
  </table>
</template>

<script>
export default {
  props: ['headers', 'tableData']
}
</script>

<style scoped>
table {
  width: 100%;
  border-collapse: collapse;
}
table td {
  padding-top: 17px;
  padding-bottom: 17px;
}

</style>