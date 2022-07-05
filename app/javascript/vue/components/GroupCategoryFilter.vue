<template>
  <div>
    <div class="flex-row-start-centered mt-5">
      <h2 class="flex-row-start-centered align-items-center font-weight-600 fs-1_6rem">
        Filter by tags
        <span
            @click="openInfo"
        >
          <span
              class="iconify ml-3 cursor-pointer"
              data-icon="akar-icons:question"
          ></span>
        </span>
      </h2>
    </div>

    <div
        v-for="(item, idx) in showGroups"
        :key="item.id"
        :ref="loopCatSuggestionRef + idx"
        class="flex-row-between-centered mt-5 align-items-start pos-rel">

      <input
          v-if="item.inputRenameGroupCat"
          @blur="item.inputRenameGroupCat = false"
          v-on:keyup.enter="renameGroupCat($event, item)"
          :ref="'inputRenameGroupCat' + idx"
          class="mr-2 width-25 min-h-5rem p-3 rounded-5px border-bkt-dark-grey-focus fs-1_6rem "
          type="text">
      <bkt-button
          v-else-if="item.inputRenameGroupCat === false && showGroups.length !== 1"
              @click.stop="showGroupOptions(idx)"
              v-click-outside="hideGroupOptions"
              type="transparent"
              class="mr-2 width-25 min-h-5rem" style="display: flex; justify-content: flex-start; align-items: center;"
          >
            {{ item.name | capitalize }}
          </bkt-button>
      <ul
          v-if="item.groupOptions"
              :tabindex="idx"
              class="position-absolute left-0 bkt-bg-white bkt-box-shadow-medium width-25 rounded-5px z-index-5" style="top: 5rem">
            <li
                @click="showRenameGroupCat(idx)"
                class="flex-row-start-centered align-items-center p-2 bkt-bg-light-grey9-hover mb-0 cursor-pointer">
              <span class="iconify mr-2" data-icon="jam:write"></span>
              <p>Rename</p>
            </li>
            <li
                v-if="item.name !== 'others'"
                @click="removeGroupCat(idx)"
                class="flex-row-start-centered align-items-center p-2 bkt-bg-light-grey9-hover bkt-red mb-0 cursor-pointer">
              <span class="iconify mr-2" data-icon="akar-icons:trash-can"></span>
              <p>Delete</p>
            </li>
          </ul>

      <div
          class=" ml-2 px-3 py-2 rounded-5px width-75 min-h-5rem "
          :class="{'bkt-bg-light-grey9-hover cursor-pointer': showGroups.length > 1}"
          @click.stop="editTagField(idx)"
          @mouseover="showCatSuggestion(idx)"
          @mouseleave="hideCatSuggestion(idx)"
      >
        <bkt-tag
            v-for="(tag, tag_idx) in item.categories"
            class="mx-2 d-inline-block my-3 vertical-align-middle"
            :selected="tag.selected"
            :key="tag.id"
            @click.stop="toggleTag(idx, tag_idx)"
        >{{ tag.title | truncateN }}
        </bkt-tag>
        <p
            v-if="showGroups.length > 1 && item.showCatSuggestion && item.showInputCatSuggestion === false"
            class="fs-1_2rem bkt-light-grey6 my-3 ml-3 cursor-pointer d-inline-block vertical-align-middle"
        >
          Move an existing tag to this category
        </p>
        <div
            v-if="showGroups.length > 1 && item.showInputCatSuggestion"
            class="position-relative d-inline-block"
            v-click-outside="resetCatSuggestionV2"
        >
          <input
              @focus="presearch(item)"
              @input="searchTagFromOtherGroups($event, item)"
              type="text"
              class="fs-1_2rem border-none bg-transparent input-cat-suggestion d-inline-block my-3"
          >
          <ul class="position-absolute left-0 height-35rem width-100 bkt-bg-white bkt-box-shadow-medium z-index-5 max-h-16rem overflow-y-auto">
            <li v-if="groupTagModule.suggestionTag && groupTagModule.suggestionTag.length === 0" class="px-2 bkt-light-grey6 fs-1_2rem mt-2">This tag doesn’t exist.</li>
            <li v-else-if="groupTagModule.suggestionTag && groupTagModule.suggestionTag.length > 0" class="px-2 bkt-light-grey6 fs-1_2rem mt-2">Select existing tag</li>
            <li
                v-for="tagObj in groupTagModule.suggestionTag"
                :key="tagObj.id"
                class="px-2 bkt-bg-light-grey9-hover cursor-pointer"
                @click.stop="changeTagOfGroup(tagObj, item)"
            >
              <bkt-tag :selected="false">{{tagObj.title}}</bkt-tag>
            </li>
          </ul>
        </div>
      </div>
    </div>

    <div class="flex-row-start-centered my-4 height-4rem">
      <input
          v-if="showNewCatInput"
          @blur="showNewCatInput = false"
          v-on:keyup.enter="createNewGroupCat"
          ref="showNewCatInput"
          class="p-3 rounded-5px border-bkt-dark-grey-focus fs-1_6rem "
          type="text">
      <bkt-button
          v-else
          iconify="ant-design:plus-circle-outlined"
          type="transparent"
          @click="displayNewCatInput"
      >
        Create category
      </bkt-button>
    </div>
    <div class="w-100 bkt-bg-light-grey5" style="height: 1px"></div>
  </div>
</template>

<script>
import store from "../store";
import BktButton from "./BktButton";
import BktTag from "./BktTag";

export default {
  props: ['entityListKey', 'pathKeyArgs'],
  data() {
    return {
      groupTagModule: store.state.groupsTag,
      loopCatSuggestionRef: 'loopCatSuggestion',
      showNewCatInput: false,
      selectedTags: [],
    }
  },
  created() {
    store.dispatch('groupsTag/fetch', {kind: 'interview'})
  },
  computed: {
    showGroups() {
      if (!this.groupTagModule.groups || this.groupTagModule.groups.length === 0) return []

      if (!('showCatSuggestion' in this.groupTagModule.groups[0])) {
        this.groupTagModule.groups = this.groupTagModule.groups.map((item) => {
          item.categories = item.categories.map(tag => {
            return {...tag, selected: false}
          })
          return {...item, showCatSuggestion: false, showInputCatSuggestion: false, groupOptions: false, inputRenameGroupCat: false}
        })
      }
      return this.groupTagModule.groups
    }
  },
  methods: {
    openInfo() {
      this.$modal.open({
        type: 'custom',
        componentName: 'info-filter-category-tags',
        closable: true,
      })
    },
    editTagField(arrayIdx) {
      this.groupTagModule.groups = this.groupTagModule.groups.map(item => {
        return {...item, showInputCatSuggestion: false}
      })
      this.groupTagModule.groups[arrayIdx].showInputCatSuggestion = true
      this.groupTagModule.groups[arrayIdx].showCatSuggestion = false
      this.$nextTick(() => {
        const input = this.$refs[this.loopCatSuggestionRef + arrayIdx][0].querySelector('.input-cat-suggestion')
        input.focus()
      })
    },
    resetCatSuggestion(arrayIdx) {
      this.groupTagModule.groups[arrayIdx].showInputCatSuggestion = false
      this.groupTagModule.groups[arrayIdx].showCatSuggestion = false
    },
    resetCatSuggestionV2() {
      this.groupTagModule.groups = this.groupTagModule.groups.map((item) => {
        return {...item, showInputCatSuggestion: false, showCatSuggestion: false}
      })
    },
    showCatSuggestion(arrayIdx) {
      this.groupTagModule.groups[arrayIdx].showCatSuggestion = true
    },
    hideCatSuggestion(arrayIdx) {
      this.groupTagModule.groups[arrayIdx].showCatSuggestion = false
    },
    displayNewCatInput() {
      this.showNewCatInput = true;
      this.$nextTick(() => {
        this.$refs.showNewCatInput.focus()
      })
    },
    createNewGroupCat(e) {
      const groupName = e.target.value
      store.dispatch('groupsTag/newGroup', {name: groupName, kind: 'interview'})
      this.$refs.showNewCatInput.value = ''
      this.showNewCatInput = false
    },
    renameGroupCat(e, item) {
      const groupName = e.target.value

      store.dispatch('groupsTag/renameGroup', {name: groupName, group_id: item.id, kind: 'interview'})
    },
    showGroupOptions(arrayIdx) {
      this.groupTagModule.groups[arrayIdx].groupOptions = true
    },
    hideGroupOptions() {
      this.groupTagModule.groups = this.groupTagModule.groups.map(item => {
        return {...item, groupOptions: false}
      })
    },
    removeGroupCat(arrayIdx) {
      const id = this.groupTagModule.groups[arrayIdx].id

      this.$modal.open({
        type: 'delete',
        title: `Are you sure you want to delete this category ?<br/>(This is a permanent action)`,
        subtitle: 'Tags from this category won’t be delete,<br/>they will move to the category ‘Other’.',
        textClose: 'No',
        textConfirm: 'Yes, delete',
        textLoading: 'Deleting ...',
        close() {
        },
        confirm() {
          store
              .dispatch('groupsTag/delete', {id, kind: 'interview'})
              .then(() => this.$modal.close())
        }
      })
    },
    showRenameGroupCat(arrayIdx) {
      this.groupTagModule.groups[arrayIdx].inputRenameGroupCat = true
      this.$nextTick(() => {
        this.$refs[`inputRenameGroupCat${arrayIdx}`][0].focus()
        this.$refs[`inputRenameGroupCat${arrayIdx}`][0].value = this.groupTagModule.groups[arrayIdx].name
      })
    },
    presearch(item) {
      this.searchTagFromOtherGroups({target: {value: ''}}, item)
    },
    searchTagFromOtherGroups(e, item) {
      const search = e.target.value
      const except_group_category_id = item.id

      store.dispatch('groupsTag/searchTag', {search, except_group_category_id, kind: 'interview'})
    },
    changeTagOfGroup(tagObj, groupCatObj) {
      store.dispatch('groupsTag/changeCategoryGroup', {
        tag_id: tagObj.id,
        group_category_id: groupCatObj.id,
        kind: 'interview'
      })
    },
    toggleTag(group_idx, tag_idx) {
      this.groupTagModule.groups[group_idx].categories[tag_idx].selected = !this.groupTagModule.groups[group_idx].categories[tag_idx].selected

      const tagsLengthBackUp = this.selectedTags.length
      this.selectedTags = this.selectedTags.filter(item => {
        return item.id !== this.groupTagModule.groups[group_idx].categories[tag_idx].id
      })
      if (this.selectedTags.length === tagsLengthBackUp)
        this.selectedTags.push(this.groupTagModule.groups[group_idx].categories[tag_idx])

      store.commit('genericFetchEntity/setTags', this.selectedTags)
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: this.entityListKey,
        pathKeyArgs: this.pathKeyArgs
      })
    }
  },
  components: {BktTag, BktButton},
}
</script>
