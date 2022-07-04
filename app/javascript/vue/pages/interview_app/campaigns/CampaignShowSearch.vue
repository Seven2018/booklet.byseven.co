<template>
  <div class=" align-items-start">
<!--    <div class=" width-100 flex-row-between-centered">-->
      <bkt-search
          v-model="searchText"
          @input="update"
          class="d-inline-block"
      ></bkt-search>
      <bkt-select
          class="mx-sm-5 my-sm-3 d-inline-block"
          v-model="status"
          :items="selectList"
          @input="update"
      ></bkt-select>

<!--      <div v-if="overview">-->
        <bkt-select
            v-if="overview"
            v-for="(category, idx) in selectCategories"
            :key="idx"
            class="mx-sm-5 my-sm-3 d-inline-block"
            v-model="category.selectedValue"
            :items="category.list"
            @input="update"
        ></bkt-select>
<!--      </div>-->

      <button class="flex-none ml-5 mt-4 font-weight-500 fs-1_6rem" @click="reset">
        Reset
      </button>
<!--    </div>-->
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
      selectCategories: []
    }
  },
  async created() {
    if (this.overview) {
      const res = await axios.get('/companies/get_tags_and_categories')

      this.selectCategories = this.buildCategoriesSelect(res.data.tag_categories)
    }
  },
  methods: {
    buildCategoriesSelect(categories) {
      return categories.map(category => {
        // const list = [{display: `All ${category.name}`, value: ''}]
        const obj = {
          selectedValue: '',
          categoryName: category.name,
          list: [{display: `All ${category.name}`, value: ''}]
        }

        category.tags.forEach(tag => obj.list.push({display: tag.tag_name, value: tag.tag_name}))
        return obj
      })
    },
    buildUserCatToSend() {
      return this.selectCategories.map(cat => {
        return {
          categoryName: cat.categoryName,
          selectedValue: cat.selectedValue,
        }
      })
    },
    update() {
      const userCatToSend = this.buildUserCatToSend()

      store.commit('genericFetchEntity/setSearch', {
        text: this.searchText,
        status: this.status,
        from: this.overview ? 'overview' : 'normal',
        userCategories: userCatToSend
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
      if (this.overview && this.selectCategories.length > 0) {
        this.selectCategories = this.selectCategories.map(item => {
          return {...item, selectedValue: ''}
        })
      }
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

