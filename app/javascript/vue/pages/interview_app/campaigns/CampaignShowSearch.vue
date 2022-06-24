<template>
  <div class="flex width-100">
    <bkt-search
        v-model="searchText"
        @input="update"
        class="flex-1"
    ></bkt-search>
    <bkt-select
        class="flex-none ml-5"
        v-model="status"
        :items="selectList"
        @input="update"
    ></bkt-select>
    <button class="flex-none ml-5 font-weight-500 fs-1_6rem" @click="reset">
      Reset
    </button>
  </div>
</template>

<script>
import BktSearch from "../../../components/bktSearch";
import store from "../../../store";
import BktSelect from "../../../components/BktSelect";

export default {
  props: ['campaign'],
  data() {
    return {
      searchText: null,
      status: '',
      selectList: [
        {display: 'All', value: ''},
        {display: 'Not started', value: 'not_started'},
        {display: 'In progress', value: 'in_progress'},
        {display: 'Submitted', value: 'submitted'}
      ],
    }
  },
  methods: {
    update() {
      store.commit('genericFetchEntity/setSearch', {
        title: this.searchText,
        status: this.status,
      })
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'campaigns_id_data_show',
        pathKeyArgs: {id: this.campaign.id}
      })
    },
    reset() {
      store.commit('genericFetchEntity/setSearch')
      this.searchText = null
      this.status = null
      store.commit('genericFetchEntity/setData', null)
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'campaigns_id_data_show',
        pathKeyArgs: {id: this.campaign.id}
      })
    },
    submit() {
      store.commit('genericFetchEntity/setSearch', {
        title: this.searchText,
        status: this.status,
      })
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'campaigns_id_data_show',
        pathKeyArgs: {id: this.campaign.id}
      })
    }
  },
  components: {BktSelect, BktSearch}
}
</script>

