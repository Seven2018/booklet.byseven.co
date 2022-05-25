<template>
  <div class="flex-row-start-centered mb-5">
    <bkt-search @searching="update"></bkt-search>
    <button class="ml-5 font-weight-500 fs-1_6rem" @click="reset">
      Reset
    </button>
  </div>
</template>

<script>
import BktSearch from "../../../components/bktSearch";
import store from "../../../store";
export default {
  created() {
    store.dispatch('adminObjectives/fetch')
  },
  methods: {
    update(text) {
      store.dispatch('adminObjectives/fetch', text)
    },
    reset() {
      store.dispatch('adminObjectives/fetch')
    }
  },
  components: {BktSearch}
}
</script>