
<template>
  <div>
    <div class="flex-row-start-centered mt-5">
      <h2 class="flex-row-start-centered align-items-center font-weight-600 fs-1_6rem">
        Filter by tags
        <div
            @click="openInfo"
        >
          <span
              class="iconify ml-3 cursor-pointer"
              data-icon="akar-icons:question"
          ></span>
        </div>
      </h2>
    </div>

    <div
        v-for="item in groupTagModule.groups"
        :key="item.key"
        class="flex-row-between-centered mt-5">
      <bkt-button
          type="transparent"
          class="mr-2 width-25" style="display: flex; justify-content: flex-start; align-items: center;"
      >
        Others
      </bkt-button>
      <div class=" ml-2 bkt-bg-light-grey9-hover px-3 rounded-5px width-75">
        <bkt-tag
            v-for="tag in item.categories"
            class="mx-2 d-inline-block my-3"
            :selected="false"
        >{{tag.title}}</bkt-tag>
      </div>
    </div>

    <div class="flex-row-start-centered my-4">
      <bkt-button
          iconify="ant-design:plus-circle-outlined"
          type="transparent"
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
      groupTagModule: store.state.groupsTag
    }
  },
  created() {
    store.dispatch('groupsTag/fetch', {kind: 'interview'})
  },
  methods: {
    openInfo() {
      this.$modal.open({
        type: 'custom',
        componentName: 'info-filter-category-tags',
        closable: true,
      })
    }
  },
  components: {BktTag, BktButton},
}
</script>