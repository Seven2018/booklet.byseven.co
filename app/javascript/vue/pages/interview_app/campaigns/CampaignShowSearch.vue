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

    <div v-if="overview">
<!--      TODO: code-->
      tag categories of company
    </div>
    <button class="flex-none ml-5 font-weight-500 fs-1_6rem" @click="reset">
      Reset
    </button>
  </div>
</template>

<script>
import BktSearch from "../../../components/bktSearch";
import store from "../../../store";
import BktSelect from "../../../components/BktSelect";
import axios from "../../../plugins/axios";

export default {
  props: ['campaign', 'overview'],
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
  async created() {
    if (this.overview) {
      const res = await axios.get('/companies/get_tags_and_categories')

      console.log(res.data)
    }
  },
  methods: {
    update() {
      store.commit('genericFetchEntity/setSearch', {
        text: this.searchText,
        status: this.status,
        from: this.overview ? 'overview' : 'normal'
      })
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'campaigns_id_data_show',
        pathKeyArgs: {id: this.campaign.id}
      })
    },
    reset() {
      store.commit('genericFetchEntity/setSearch', {
        from: this.overview ? 'overview' : 'normal'
      })
      this.searchText = null
      this.status = null
      store.commit('genericFetchEntity/setData', null)
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'campaigns_id_data_show',
        pathKeyArgs: {id: this.campaign.id}
      })
    },
  },
  components: {BktSelect, BktSearch}
}
</script>

