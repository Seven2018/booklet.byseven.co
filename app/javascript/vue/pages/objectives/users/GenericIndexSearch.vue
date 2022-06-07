<template>
  <div class="flex-row-start-centered mb-5 mt-4">
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
  props: ['pathKey'],
  methods: {
    update(text) {
      store.commit('genericFetchEntity/setSearch', {
          search: text
      })
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: this.pathKey,
      })
    },
    reset() {
      store.commit('genericFetchEntity/setSearch', {
          search: null
      })
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: this.pathKey,
      })
    }
  },
  components: {BktSearch}
}
</script>