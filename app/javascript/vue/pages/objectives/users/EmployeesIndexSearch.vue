<template>
  <div class="flex-row-start-centered mb-5">
    <bkt-search @input="update"></bkt-search>
    <button class="ml-5 font-weight-500 fs-1_6rem" @click="reset">
      Reset
    </button>
  </div>
</template>

<script>
import BktSearch from "../../../components/bktSearch";
import store from "../../../store";
export default {
  methods: {
    update(text) {
      store.commit('adminObjectives/setSearch', {
        search: text
      })
      store.dispatch('adminObjectives/fetch')
    },
    reset() {
      store.commit('adminObjectives/setSearch', {
        search: null
      })
      store.dispatch('adminObjectives/fetch')
    }
  },
  components: {BktSearch}
}
</script>