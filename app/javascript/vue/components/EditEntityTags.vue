
<template>
  <div style="width: 50vh">
    <div class="flex-row-between-centered p-4">
      <h1 class="fs-1_8rem">{{title}}</h1>
      <div @click="$emit('close')" class="cursor-pointer">
        <span  class="iconify" data-icon="akar-icons:cross" data-width="20" data-height="20"></span>
      </div>
    </div>

    <div>
      <div
          class="flex-row-start-centered p-4 bkt-bg-light-grey9 overflow-x-auto"
          @click="focusInput"
      >
        <bkt-tag
            v-for="(tag, idx) in entityTags"
            :key="idx"
            :cancelable="true"
            @close="removeTag(tag.title)"
        >
          {{tag.title}}
        </bkt-tag>
        <p>
          {{searchText}}
        </p>
        <input ref="inputField" v-model="searchText" @input="search" type="text" class="border-none bg-transparent" style="height: 20px;width: 1px;padding-left: 0px;">
      </div>

      <div v-if="allTags" class="flex-column pl-4" style="height: 200px; overflow-y: auto">
        <p class="my-4 bkt-light-grey fs-1_2rem">Select a tag or create new one</p>
        <div
            v-if="searchText"
            @click="createTag(searchText)"
            class="flex-row-start-centered bkt-bg-light-grey9 bkt-bg-light-blue-hover mb-3 cursor-pointer"
        >
          <p class="mr-3">Create +</p>
          <bkt-tag>
            {{searchText}}
          </bkt-tag>
        </div>

        <div
            v-for="(tag, idx) in allTags"
            :key="idx"
            @click="addTag(tag)"
            class="bkt-bg-light-blue-hover mb-3 cursor-pointer"
        >
          <bkt-tag>
            {{tag.title}}
          </bkt-tag>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import BktTag from "./BktTag";
import store from "../store";
import HTTP from "../plugins/axios";
import routes from "../constants/routes";

export default {
  components: {BktTag},
  props: ['title', 'entityId', 'fetchTagsFromEntityPath', 'toggleTagFromEntityPath', 'refreshEntityListPath'],
  data() {
    return {
      entityTags: [],
      tagsModule: store.state.tagsModule,
      searchText: '',
      suggestToCreate: false
    }
  },
  created() {
    this.fetchEntityTag()
    store.dispatch('tagsModule/fetch', {kind: 'interview'})
  },
  computed: {
    allTags() {
      if (!this.tagsModule.tags) return []

      const res = this.tagsModule.tags.filter(tag => {
        for (const tagKey in this.entityTags) {
          if (this.entityTags[tagKey].title === tag.title) return false
        }
        return true
      })
      if (res.length === 0)
        this.suggestToCreate = true
      else
        this.suggestToCreate = false
      return res
    }
  },
  methods: {
    search(e) {
      // this.searchText = e.target.value
      store.dispatch('tagsModule/fetch', {kind: 'interview', title: this.searchText})
          .then(() => this.$refs.inputField.focus())
    },
    async createTag(text) {
      await this.addTag({id: Math.floor(Math.random() * 100), title: text})
      this.searchText = ''
      this.suggestToCreate = false
      store.dispatch('tagsModule/fetch', {kind: 'interview'})
      store.dispatch('groupsTag/fetch', {kind: 'interview'})

    },
    focusInput() {
      this.$refs.inputField.focus()
    },
    async fetchEntityTag() {
      try {
        const res = await HTTP.get(
            routes.generate(this.fetchTagsFromEntityPath),
            {
              params: {id: this.entityId}
            }
        )

        this.entityTags = res.data.categories
      } catch (e) {
        console.log('error', e)
      }
    },
    async removeTag(tag) {
      try {
        await HTTP.post(
            routes.generate(this.toggleTagFromEntityPath, {id: this.entityId}) + '.json',
            {tag}
        )

        this.entityTags = this.entityTags.filter(campaignTag => campaignTag.title !== tag)
        store.dispatch('tagsModule/fetch', {kind: 'interview'})
        store.dispatch('genericFetchEntity/fetch',
            {
              pathKey: this.refreshEntityListPath
            }
        )
      } catch (e) {
        console.log('error', e)
      }
    },
    async addTag(tagObj) {
      this.searchText = ''
      try {
        await HTTP.post(
            routes.generate(this.toggleTagFromEntityPath, {id: this.entityId}) + '.json',
            {tag: tagObj.title}
        )

        this.entityTags.push(tagObj)
        store.dispatch('genericFetchEntity/fetch',
            {
              pathKey: this.refreshEntityListPath
            }
        )
      } catch (e) {
        console.log('error', e)
      }
    }
  }
}
</script>