
<template>
  <div style="width: 50vh">
    <div class="flex-row-between-centered p-4">
      <h1 class="fs-1_8rem">Edit campaign tags</h1>
      <div @click="$emit('close')" class="cursor-pointer">
        <span  class="iconify" data-icon="akar-icons:cross" data-width="20" data-height="20"></span>
      </div>
    </div>

    <div>
      <div
          class="flex-row-start-centered p-4 bkt-bg-light-grey9"
          @click="focusInput"
      >
        <bkt-tag
            v-for="(tag, idx) in campaignTags"
            :key="idx"
            :cancelable="true"
            @close="removeTag(tag.title)"
        >
          {{tag.title}}
        </bkt-tag>
        <input ref="inputField" type="text" class="border-none bg-transparent" style="height: 20px;width: 3px;">
      </div>
      <div v-if="allTags" class="flex-column pl-4" style="height: 200px; overflow-y: auto">
        <p class="my-4 bkt-light-grey fs-1_2rem">Select a tag or create new one</p>
        <bkt-tag
            v-for="(tag, idx) in allTags"
            :key="idx"
            :cancelable="false"
            class="mb-3"
            @click="addTag(tag)"
        >
          {{tag.title}}
        </bkt-tag>
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
  props: ['campaignId'],
  data() {
    return {
      campaignTags: [],
      tagsModule: store.state.tagsModule
    }
  },
  created() {
    this.fetchCampaignTag()
    store.dispatch('tagsModule/fetch', {kind: 'interview'})
  },
  computed: {
    allTags() {
      if (!this.tagsModule.tags) return []

      return this.tagsModule.tags.filter(tag => {
        for (const tagKey in this.campaignTags) {
          if (this.campaignTags[tagKey].title === tag.title) return false
        }
        return true
      })
    }
  },
  methods: {
    focusInput() {
      this.$refs.inputField.focus()
    },
    async fetchCampaignTag() {
      try {
        const res = await HTTP.get(
            routes.generate('categories_from_campaign'),
            {
              params: {id: this.campaignId}
            }
        )

        this.campaignTags = res.data.categories
      } catch (e) {
        console.log('error', e)
      }
    },
    async removeTag(tag) {
      try {
        await HTTP.post(
            routes.generate('campaigns_toggle_tag', {id: this.campaignId}) + '.json',
            {tag}
        )

        this.campaignTags = this.campaignTags.filter(campaignTag => campaignTag.title !== tag)
      } catch (e) {
        console.log('error', e)
      }
    },
    async addTag(tagObj) {
      try {
        await HTTP.post(
            routes.generate('campaigns_toggle_tag', {id: this.campaignId}) + '.json',
            {tag: tagObj.title}
        )

        this.campaignTags.push(tagObj)
      } catch (e) {
        console.log('error', e)
      }
    }
  }
}
</script>