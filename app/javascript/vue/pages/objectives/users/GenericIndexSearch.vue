<template>
  <div class="flex-row-start-centered mb-5 mt-4">
    <bkt-search v-model="text" @input="update"></bkt-search>
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
  data() {
    return {
      text: ''
    }
  },
  methods: {
    update(text) {
      store.commit('genericFetchEntity/setSearch', {
          title: text
      })
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: this.pathKey,
      })
    },
    reset() {
      this.text = ''
      store.commit('genericFetchEntity/setData', null)
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