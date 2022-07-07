
<template>
  <div class="rounded-15px bkt-bg-white p-5">
    <p class="pb-3 border-bottom-bkt-light-grey">Template tags</p>
    <p class="fs-1_4rem font-weight-500 bkt-light-grey5 mt-4">
      Add tags to your template in order to search through templates efficiently and create accurate reports
    </p>
      <div
          v-click-outside="deFocus"
          @click="preFocus"
          class="pos-rel d-flex justify-content-start align-items-center flex-wrap width-100 mt-4 bkt-bg-light-grey9 pt-1rem rounded-2px">
        <bkt-tag
            v-for="(tag, idx) in entityTags"
            :key="idx"
            :cancelable="true"
            @close="removeTag(tag.title)"
            class="d-inline-block mb-0_5rem"
        >
          {{tag.title}}
        </bkt-tag>
        <input
            ref="inputSearch"
            class="bkt-bg-light-grey9 fs-1_4rem font-weight-500 bkt-placeholder-dark-grey bkt-placeholder-fs-1_4rem border-0 d-inline-block mr-1rem my-1rem pl-1rem cursor-pointer"
            type="text"
            placeholder="Search tags"
            v-model="searchText"
            @input="search"
            @focus="preFocus"
        >
        <div
            v-if="displaySuggestion"
            class="pos-abs bkt-bg-white bkt-box-shadow-light rounded-5px width-100 height-20rem overflow-y-auto " style="top: 100%; left: 0; right: 0">
          <div
              v-if="searchText"
              @click="createTag(searchText)"
              class="flex-row-start-centered bkt-bg-light-grey9 bkt-bg-light-blue-hover cursor-pointer py-3 pl-3"
          >
            <p class="mr-3">Create +</p>
            <bkt-tag :selected="false">
              {{searchText}}
            </bkt-tag>
          </div>

          <div
              v-for="(tag, idx) in allTags"
              :key="idx"
              @click="addTag(tag)"
              class="flex-row-between-centered bkt-bg-light-blue-hover cursor-pointer py-3 pl-3"
          >
            <bkt-tag :selected="false">
              {{tag.title}}
            </bkt-tag>

            <bkt-dots-button>
              <button
                  class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                  @click.stop="openDeletePopup(tag)"
              >
                <span class="iconify mr-1" data-icon="akar-icons:trash-can" ></span>
                delete
              </button>
              <button
                  class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                  @click.stop="openRenamePopup(tag)"
              >
                rename
              </button>
            </bkt-dots-button>
          </div>
        </div>
      </div>
  </div>
</template>

<script>
import store from "../../../../store";
import HTTP from "../../../../plugins/axios";
import routes from "../../../../constants/routes";
import BktTag from "../../../../components/BktTag";
import BktDotsButton from "../../../../components/BktDotsButton";
import axios from "../../../../plugins/axios";

export default {
  components: {BktTag, BktDotsButton},
  props: ['entityId'],
  data() {
    return {
      entityTags: [],
      tagsModule: store.state.tagsModule,
      searchText: '',
      displaySuggestion: false
    }
  },
  created() {
    this.fetchEntityTag()
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
    preFocus() {
      this.$refs.inputSearch.focus()
      this.displaySuggestion = true
      store.dispatch('tagsModule/fetch', {kind: 'interview'})
    },
    deFocus() {
      this.displaySuggestion = false
    },
    search(e) {
      // this.searchText = e.target.value
      store.dispatch('tagsModule/fetch', {kind: 'interview', title: this.searchText})
          .then(() => this.$refs.inputSearch.focus())
    },
    async createTag(text) {
      this.suggestToCreate = false
      await this.addTag({title: text})
      // store.dispatch('tagsModule/fetch', {kind: 'interview'})
    },
    async fetchEntityTag() {
      try {
        const res = await HTTP.get(
            routes.generate('categories_from_template'),
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
        const res = await HTTP.post(
            routes.generate('interview_forms_toggle_tag', {id: this.entityId}) + '.json',
            {tag}
        )

        this.entityTags = this.entityTags.filter(interviewFormTag => interviewFormTag.title !== tag)
        // store.dispatch('tagsModule/fetch', {kind: 'interview'})
      } catch (e) {
        console.log('error', e)
      }
    },
    async addTag(tagObj) {
      this.searchText = ''
      try {
        const res = await HTTP.post(
            routes.generate('interview_forms_toggle_tag', {id: this.entityId}) + '.json',
            {tag: tagObj.title}
        )

        this.entityTags.push(res.data.category)
      } catch (e) {
        console.log('error', e)
      }
    },
    openDeletePopup(tag) {
      this.$modal.open({
        type: 'delete',
        title: `Are you sure you want to delete this tag ?<br> (This is a permanent action)`,
        textClose: 'No',
        textConfirm: 'Yes, delete',
        textLoading: 'Deleting ...',
        close() {},
        async confirm() {
          try {
            await axios.delete(this.$routes.generate('categories_id', {id: tag.id}))
            this.$modal.close()
          } catch (e) {
            console.log(e)
          }
        }
      })
    },
    openRenamePopup(tag) {
      this.$modal.open({
        type: 'custom',
        closable: true,
        title: `Rename tag`,
        componentName: 'pop-up-rename-tag',
        tag
      })
    }
  }
}
</script>
