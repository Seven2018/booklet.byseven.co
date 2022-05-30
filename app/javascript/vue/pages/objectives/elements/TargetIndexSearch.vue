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
          <option value="not_completed">Not Completed</option>
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
      searchText: '',
      indicatorType: null,
      indicatorStatus: null,
      from: null,
      to: null,
    }
  },
  created() {
    // store.dispatch('adminObjectives/fetch')
  },
  methods: {
    update(_) {
      // store.dispatch('adminObjectives/fetch', text)
    },
    reset() {
      // store.dispatch('adminObjectives/fetch')
    },
    submit() {
      console.log(this.searchText, this.indicatorType, this.indicatorStatus, this.from, this.to)
    }
  },
  components: {BktSearch}
}
</script>