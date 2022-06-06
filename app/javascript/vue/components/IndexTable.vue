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
          :class="{'bkt-bg-light-grey10-hover': withoutHover === false}"
          @click="$emit('row-click', row)"
      >
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
          @click="$emit('fetch-page', pagination.prev_page)"
      >Prev
      </bkt-button>

      <div class="d-flex">
<!--        before-->
        <a
            class="bkt-objective-blue3-important mx-2"
            v-for="n in makeRange(0, pagination.current_page)"
            @click="$emit('fetch-page', n)"
        >{{ n }}</a>
        <span
            v-if="makeRange(0, pagination.current_page).length && !makeRange(0, pagination.current_page).includes(pagination.current_page - 1)"
            class="bkt-objective-blue3-important mx-2">...</span>
<!--        current-->
        <a
            class="bkt-objective-blue-important mx-2"
            @click="$emit('fetch-page', pagination.current_page)"
        >
          {{pagination.current_page}}</a>
        <a
            class="bkt-objective-blue3-important mx-2"
            v-for="n in makeRange(pagination.current_page, pagination.total_pages)"
            @click="$emit('fetch-page', n)"
        >{{ n }}</a>
<!--        last-->
        <span
            v-if="!makeRange(pagination.current_page, pagination.total_pages).includes(pagination.total_pages - 1)
            && pagination.current_page != pagination.total_pages - 1
            && pagination.current_page < pagination.total_pages"
            class="bkt-objective-blue3-important mx-2">...</span>
        <a
            v-if="pagination.current_page < pagination.total_pages"
            class="bkt-objective-blue3-important mx-2"
            @click="$emit('fetch-page', pagination.total_pages)"
        >
          {{pagination.total_pages}}</a>
      </div>

      <bkt-button
          v-if="pagination.next_page"
          type="white"
          custom-class="border-bkt-objective-blue position-absolute"
          right="0px"
          @click="$emit('fetch-page', pagination.next_page)"
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
