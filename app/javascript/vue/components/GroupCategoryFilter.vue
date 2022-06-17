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
          <bkt-button
              v-if="showGroups.length !== 1"
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
            <li class="flex-row-start-centered align-items-center p-2 bkt-bg-light-grey9-hover mb-0 cursor-pointer">
              <span class="iconify mr-2" data-icon="jam:write"></span>
              <p>Rename</p>
            </li>
            <li
                @click="removeGroupCat(idx)"
                class="flex-row-start-centered align-items-center p-2 bkt-bg-light-grey9-hover bkt-red mb-0 cursor-pointer">
              <span class="iconify mr-2" data-icon="akar-icons:trash-can"></span>
              <p>Delete</p>
            </li>
          </ul>

      <div
          class=" ml-2 bkt-bg-light-grey9-hover px-3 py-2 rounded-5px width-75 min-h-5rem"
          @click="editTagField(idx)"
          @mouseover="showCatSuggestion(idx)"
          @mouseleave="hideCatSuggestion(idx)"
      >
        <bkt-tag
            v-for="tag in item.categories"
            class="mx-2 d-inline-block my-3 vertical-align-middle"
            :selected="false"
            @click.stop="() => {}"
        >{{ tag.title }}
        </bkt-tag>
        <p
            v-if="item.showCatSuggestion && item.showInputCatSuggestion === false"
            class="fs-1_2rem bkt-light-grey6 my-3 ml-3 cursor-pointer d-inline-block vertical-align-middle"
        >
          Move an existing tag to this category
        </p>
        <input
            v-if="item.showInputCatSuggestion"
            @blur="resetCatSuggestion(idx)"
            type="text"
            class="fs-1_2rem border-none bg-transparent input-cat-suggestion d-inline-block my-3"
        >
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
  data() {
    return {
      groupTagModule: store.state.groupsTag,
      loopCatSuggestionRef: 'loopCatSuggestion',
      showNewCatInput: false
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
          return {...item, showCatSuggestion: false, showInputCatSuggestion: false, groupOptions: false}
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
    }
  },
  components: {BktTag, BktButton},
}
</script>