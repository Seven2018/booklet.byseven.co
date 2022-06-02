<template>
  <div class="flex-row-between-centered mb-5">
    <div class="flex-column">
      <div class="flex-row-start-centered">
        <bkt-search
            v-model="searchText"
            @input="update"
        ></bkt-search>
        <input type="submit" value="Search" class="ml-5 btn-search" @click="submit">
        <select
            v-model="indicatorType"
            @change="update"
            class="ml-5 p-3 bkt-bg-light-grey3 rounded-5px border-bkt-dark-grey"
            name="indicatorType"
        >
          <option value="boolean">True/False</option>
          <option value="numeric_value">Numeric value</option>
          <option value="percentage">Percentage</option>
          <option value="multi_choice">Multi choice</option>
        </select>
        <select
            v-model="indicatorStatus"
            @change="update"
            class="ml-5 p-3 bkt-bg-light-grey3 rounded-5px border-bkt-dark-grey"
            name="indicatorStatus"
        >
          <option value="completed">Completed</option>
          <option value="in_progress">In progress</option>
          <option value="uncompleted">Not Completed</option>
        </select>
        <button class="ml-5 font-weight-500 fs-1_6rem" @click="reset">
          Reset
        </button>
      </div>
    </div>

    <div class="flex-column">
      <div class="flex-row-start-centered">
        <p>From </p>
        <input
            v-model="from"
            @change="update"
            class="ml-3 p-3 bkt-bg-light-grey3 rounded-5px border-bkt-dark-grey"
            type="date">
        <p class="ml-3">To </p>
        <input
            v-model="to"
            @change="update"
            class="ml-3 p-3 bkt-bg-light-grey3 rounded-5px border-bkt-dark-grey"
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
      indicatorType: null,
      indicatorStatus: null,
      from: null,
      to: null,
    }
  },
  created() {
  },
  methods: {
    update(_) {
    },
    reset() {
      store.commit('targetObjectives/setSearch')
      this.searchText = null
      this.indicatorType = null
      this.indicatorStatus = null
      this.from = null
      this.to = null
      store.dispatch('targetObjectives/fetchTargetList')
    },
    submit() {
      store.commit('targetObjectives/setSearch', {
        'search[title]': this.searchText,
        'search[indicator_type]': this.indicatorType,
        'search[indicator_status]': this.indicatorStatus,
        'search[from]': this.from,
        'search[to]': this.to,
      })
      store.dispatch('targetObjectives/fetchTargetList')
    }
  },
  components: {BktSearch}
}
</script>