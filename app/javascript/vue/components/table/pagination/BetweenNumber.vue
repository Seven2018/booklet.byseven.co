<template>
  <div class="d-flex">
<!--        before-->
    <a
        class="bkt-blue-important mx-2"
        v-for="n in makeRange(0, pagination.current_page)"
        @click="method(n)"
    >{{ n }}</a>
    <span
        v-if="makeRange(0, pagination.current_page).length && !makeRange(0, pagination.current_page).includes(pagination.current_page - 1)"
        class="bkt-blue-important mx-2">...</span>
<!--        current-->
    <a
        class="bkt-blue-important mx-2 thick"
        @click="method(pagination.current_page)"
    >
      {{pagination.current_page}}</a>
    <a
        class="bkt-blue-important mx-2"
        v-for="n in makeRange(pagination.current_page, pagination.total_pages)"
        @click="method(n)"
    >{{ n }}</a>
<!--        last-->
    <span
        v-if="!makeRange(pagination.current_page, pagination.total_pages).includes(pagination.total_pages - 1)
        && pagination.current_page != pagination.total_pages - 1
        && pagination.current_page < pagination.total_pages"
        class="bkt-objective-blue3-important mx-2">...</span>
    <a
        v-if="pagination.current_page < pagination.total_pages"
        class="bkt-blue-important mx-2"
        @click="method(pagination.total_pages)"
    >
      {{pagination.total_pages}}</a>
  </div>
</template>

<script>

export default {
  props: {
    pagination: Object,
    method: { type: Function },
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
a.thick {
  font-weight: bold;
}
</style>
