<template>
  <div class="position-relative">
    <input placeholder="Search" class="p-3 bkt-bg-light-grey3 rounded-5px" @input="update">
    <span class="iconify bkt-light-grey" data-icon="entypo:magnifying-glass" data-width="30" data-height="30"></span>
    {{search}}
  </div>
</template>

<script>
import store from "../store/search";

export default {
  computed: {
    search() {
      console.log('update', store.state.search)
      return store.state.search
    }
  },
  methods: {
    update(e) {
      store.commit('setSearch', e.target.value)
      console.log('setSearch', store.state.search)
    }
  }
}
</script>

<style scoped>
  svg {
    position: absolute;
    top: 8px;
    right: 10px;
  }
</style>