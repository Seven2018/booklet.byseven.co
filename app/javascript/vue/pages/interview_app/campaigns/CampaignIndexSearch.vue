<template>
  <div class="row flex-row-between-centered mb-5">
    <div class="flex-column mt-4">
      <div class="flex-row-start-centered">
        <bkt-search
            v-model="searchText"
            @input="update"
        ></bkt-search>
<!--        <select-->
<!--            v-model="status"-->
<!--            @change="update"-->
<!--            class="ml-5 p-3 bkt-bg-light-grey3 rounded-5px border-bkt-dark-grey-focus"-->
<!--            name="status"-->
<!--        >-->
<!--          <option value="">All</option>-->
<!--          <option value="current">Current</option>-->
<!--          <option value="completed">Completed</option>-->
<!--        </select>-->
        <bkt-select
            class="ml-5"
            v-model="status"
            :items="selectList"
        ></bkt-select>
        <input type="submit" value="Search" class="ml-5 bkt-bg-light-grey12-important px-4 py-3 rounded-5px border-none" @click="submit">
        <button class="ml-5 font-weight-500 fs-1_6rem" @click="reset">
          Reset
        </button>
      </div>
    </div>

  </div>
</template>

<script>
import BktSearch from "../../../components/bktSearch";
import store from "../../../store";
import BktSelect from "../../../components/BktSelect";

export default {
  data() {
    return {
      searchText: null,
      status: '',
      selectList: [{display: 'All', value: ''}, {display: 'Current', value: 'current'}, {display: 'Completed', value: 'completed'}],
    }
  },
  methods: {
    update(_) {
    },
    reset() {
      store.commit('genericFetchEntity/setSearch')
      this.searchText = null
      this.status = null
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'campaigns_list',
      })
    },
    submit() {
      store.commit('genericFetchEntity/setSearch', {
        title: this.searchText,
        status: this.status,
      })
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'campaigns_list',
      })
    }
  },
  components: {BktSelect, BktSearch}
}
</script>
