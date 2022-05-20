<template>
  <div class="flex-row-start-centered mb-5">
    <div class="position-relative">
      <input placeholder="Search" class="p-3 bkt-bg-light-grey3 rounded-5px" :value="search.value" @input="update">
      <span class="iconify bkt-light-grey" data-icon="entypo:magnifying-glass" data-width="30" data-height="30"></span>
      <!--    {{search.value}}-->
    </div>
    <button class="ml-5 font-weight-500 fs-1_6rem" @click="reset">
      Reset
    </button>
  </div>
</template>

<script>
import store from "../store";

export default {
  data() {
    return {
      search: store.state.search
    }
  },
  created() {
    store.dispatch('adminObjectives/fetch')
  },
  methods: {
    update(e) {
      store.commit('search/set', e.target.value)
      store.dispatch('adminObjectives/fetch')
    },
    reset() {
      store.commit('search/set', '')
      store.dispatch('adminObjectives/fetch')
    }
  }
}
</script>

<style scoped>
input {
  padding-right: 40px !important;
}

svg {
  position: absolute;
  top: 8px;
  right: 10px;
}
</style>