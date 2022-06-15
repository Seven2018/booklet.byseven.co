
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
    <div class="flex-row-start-centered">
      tags
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

export default {
  components: {BktButton},
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
  }
}
</script>