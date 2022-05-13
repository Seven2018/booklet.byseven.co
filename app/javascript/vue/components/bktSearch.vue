<template>
  <div class="position-relative">
    <input placeholder="Search" class="p-3 bkt-bg-light-grey3 rounded-5px" @input="update">
    <span class="iconify bkt-light-grey" data-icon="entypo:magnifying-glass" data-width="30" data-height="30"></span>
<!--    {{search.value}}-->
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
  methods: {
    update(e) {
      store.commit('search/set', e.target.value)
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