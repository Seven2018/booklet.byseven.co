<template>
  <div class="flex-row-between-centered mb-5">
    <div class="flex-column">
      <div class="flex-row-start-centered">
        <bkt-search
            v-model="searchText"
            @input="update"
        ></bkt-search>
        <select
            v-model="indicatorType"
            class="ml-5 p-3 bkt-bg-light-grey3 rounded-5px border-bkt-dark-grey"
            name="indicatorType"
        >
          <option value="boolean">True/False</option>
          <option value="numeric_value">Numeric value</option>
          <option value="percentage">Percentage</option>
          <option value="multi_choice">Multi choice</option>
        </select>
        <button class="ml-5 font-weight-500 fs-1_6rem" @click="reset">
          Reset
        </button>
      </div>
    </div>

  </div>
</template>

<script>
import BktSearch from "../../../../components/bktSearch";
import store from "../../../../store";

export default {
  data() {
    return {
      searchText: null,
      indicatorType: null,
      indicatorStatus: null,
      from: null,
      to: null,
    }
  },
  methods: {
    reset() {
      // TODO: rethink search
      // store.commit('genericFetchEntity/setSearch')
      // this.searchText = null
      // this.indicatorType = null
      // store.dispatch('genericFetchEntity/fetch', {
      //   pathKey: 'objective_templates_list',
      // })
    },
    update() {
      store.commit('genericFetchEntity/setSearch', {
        search: this.searchText,
        // 'search[indicator_type]': this.indicatorType,
      })
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'objective_templates_list',
      })
    }
  },
  components: {BktSearch}
}
</script>
