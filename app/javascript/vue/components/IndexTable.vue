<template>
  <div>
    <table>
      <thead>
      <tr class="border-bottom-bkt-light-grey5" :class="headerClass">
        <th v-for="col in headers" class="px-2">
          <p class="font-weight-500">
            {{ col }}
          </p>
        </th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="row in tableData" class="border-bottom-bkt-light-grey5-not-last-child"
          :class="{'bkt-bg-light-grey10-hover': withoutHover === false}">
        <slot v-bind="row"></slot>
      </tr>
      </tbody>
    </table>

    <div
        v-if="pagination"
        class="flex-row-center-centered mt-5 position-relative">
      <bkt-button
          v-if="pagination.prev_page"
          type="white"
          custom-class="border-bkt-objective-blue position-absolute"
          left="0px"
      >Prev
      </bkt-button>

      <div class="d-flex">
        <a
            class="bkt-objective-blue mx-2"
            :href="`${path}?page[number]=${pagination.current_page}&page[size]=10`"
        >
          {{pagination.current_page}}</a>
        <a
            class="bkt-objective-blue3 mx-2"
            v-for="n in makeRange(pagination.current_page, pagination.total_pages)"
            :href="`${path}?page[number]=${n}&page[size]=10`"
        >{{ n }}</a>
<!--        last-->
        <span
            v-if="!makeRange(pagination.current_page, pagination.total_pages).includes(pagination.total_pages - 1)"
            class="bkt-objective-blue3 mx-2">...</span>
        <a
            class="bkt-objective-blue3 mx-2"
            :href="`${path}?page[number]=${pagination.total_pages}&page[size]=10`"
        >
          {{pagination.total_pages}}</a>
      </div>

      <bkt-button
          v-if="pagination.next_page"
          type="white"
          custom-class="border-bkt-objective-blue position-absolute"
          right="0px"
      >Next
      </bkt-button>
    </div>
  </div>
</template>

<script>
import BktButton from "./BktButton";

export default {
  components: {BktButton},
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
    path: String
  },
  methods: {
    makeRange(from, to) {
      let range = []
      let loop = 0

      for (let i = from + 1; i <= to - 1; i++) {
        range.push(i)
        loop++

        if (loop > 1) break
      }

      return range
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

</style>
