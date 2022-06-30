<template>
  <div>
    <table>
      <thead>
      <tr class="border-bottom-bkt-light-grey5 bkt-light-grey6" :class="headerClass">
        <th v-for="col in headers" class="px-2">
          <p class="font-weight-600">
            {{ col }}
          </p>
        </th>
      </tr>
      </thead>
      <tbody>
      <tr
          v-for="row in tableData" class="border-bottom-bkt-light-grey5-not-last-child"
          :key="row.id"
          :class="{'bkt-bg-light-grey10-hover cursor-pointer': withoutHover === false}"
          @click="$emit('row-click', row)"
      >
        <slot v-bind="row"></slot>
      </tr>
      </tbody>
    </table>

    <div
        v-if="pagination"
        class="paginate-container paginate-container-blue">

      <previous-button
        :method="fetchPage"
        :pagination='pagination'
      > </previous-button>

      <between-number
        :method="fetchPage"
        :pagination='pagination'
      >
      </between-number>

      <next-button
        :method="fetchPage"
        :pagination='pagination'
      > </next-button>
    </div>
  </div>
</template>

<script>
import BktButton from "./BktButton";
import NextButton from "./table/pagination/NextButton";
import PreviousButton from "./table/pagination/PreviousButton";
import BetweenNumber from "./table/pagination/BetweenNumber";

export default {
  components: {BktButton, NextButton, PreviousButton, BetweenNumber},
  props: {
    headers: Array,
    tableData: Array,
    headerClass: String,
    withoutHover: {
      type: Boolean,
      default() {
        return false
      }
    },
    pagination: Object,
  },
  methods: {
    fetchPage(page) {
      this.$emit('fetch-page', page)
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

.table-borderless > tbody > tr > td,
.table-borderless > tbody > tr > th,
.table-borderless > tfoot > tr > td,
.table-borderless > tfoot > tr > th,
.table-borderless > thead > tr > td,
.table-borderless > thead > tr > th {
  border: none;
}

a.thick {
  font-weight: bold;
}
</style>
