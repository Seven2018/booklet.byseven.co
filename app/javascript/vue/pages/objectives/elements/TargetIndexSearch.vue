<template>
  <div class="row flex-row-between-centered mb-5">
    <div class="flex-column mt-4">
      <div class="flex-row-start-centered">
        <bkt-search
            v-model="searchText"
            @input="update"
        ></bkt-search>
<!--        <input type="submit" value="Search" class="ml-5 bkt-bg-light-grey12-important px-4 py-3 rounded-5px border-none" @click="submit">-->
        <select
            v-model="indicatorType"
            @change="update"
            class="ml-5 p-3 bkt-bg-light-grey3 rounded-5px border-bkt-dark-grey-focus"
            name="indicatorType"
        >
          <option value="">All</option>
          <option value="boolean">True/False</option>
          <option value="numeric_value">Numeric value</option>
          <option value="percentage">Percentage</option>
          <option value="multi_choice">Multi choice</option>
        </select>
        <select
            v-model="indicatorStatus"
            @change="update"
            class="ml-5 p-3 bkt-bg-light-grey3 rounded-5px border-bkt-dark-grey-focus"
            name="indicatorStatus"
        >
          <option value="">All</option>
          <option value="completed">Completed</option>
          <option value="in_progress">In progress</option>
          <option value="uncompleted">Not Completed</option>
        </select>
        <button class="ml-5 font-weight-500 fs-1_6rem" @click="reset">
          Reset
        </button>
      </div>
    </div>

    <div class="flex-column ml-4 mt-4">
      <div class="flex-row-start-centered">
        <p>From </p>
        <input
            v-model="from"
            @change="update"
            class="ml-3 p-3 bkt-bg-light-grey3 rounded-5px border-bkt-dark-grey-focus"
            type="date">
        <p class="ml-3">To </p>
        <input
            v-model="to"
            @change="update"
            class="ml-3 p-3 bkt-bg-light-grey3 rounded-5px border-bkt-dark-grey-focus"
            type="date">
      </div>
    </div>
  </div>
</template>

<script>
import BktSearch from "../../../components/bktSearch";
import store from "../../../store";

export default {
  data() {
    return {
      searchText: null,
      indicatorType: '',
      indicatorStatus: '',
      from: null,
      to: null,
    }
  },
  created() {
  },
  methods: {
    update() {
      store.commit('genericFetchEntity/setSearch', {
        title: this.searchText,
        indicator_type: this.indicatorType,
        indicator_status: this.indicatorStatus,
        from: this.from,
        to: this.to,
      })
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'objective_target_list',
      })
    },
    reset() {
      store.commit('genericFetchEntity/setSearch')
      this.searchText = null
      this.indicatorType = null
      this.indicatorStatus = null
      this.from = null
      this.to = null
      store.commit('genericFetchEntity/setData', null)
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'objective_target_list',
      })
    },
    // submit() {
    //   store.commit('genericFetchEntity/setSearch', {
    //     title: this.searchText,
    //     indicator_type: this.indicatorType,
    //     indicator_status: this.indicatorStatus,
    //     from: this.from,
    //     to: this.to,
    //   })
    //   store.dispatch('genericFetchEntity/fetch', {
    //     pathKey: 'objective_target_list',
    //   })
    // }
  },
  components: {BktSearch}
}
</script>
