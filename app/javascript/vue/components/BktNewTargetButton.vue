
<template>
  <div
      v-click-outside="hide"
      class="position-relative"
  >
    <div
        @click="toggleDisplay"
    >
      <bkt-button
          :type="display ? 'white' : 'roadmap'"
          iconify="ant-design:plus-circle-outlined"
      >
        New Target
      </bkt-button>
    </div>
    <div
        v-if="display"
        class="position-absolute bkt-bg-white rounded-5px bkt-box-shadow-medium z-index-5 width-max-content"
    >
      <a
          :href="$routes.generate('objective_templates_new_target_view')"
          class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover bkt-objective-blue width-100 p-3"
      >
        Use existing template
      </a>
      <a
          :href="$routes.generate('objective_new')"
          class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover bkt-objective-blue width-100 p-3"
      >
        Create a whole new
      </a>
    </div>
  </div>
</template>

<script>
import BktButton from "./BktButton";

export default {
  data() {
    return {
      display: false
    }
  },
  methods: {
    toggleDisplay() {
      console.log('test')
      this.display = !this.display
    },
    hide() {
      this.display = false
    }
  },
  components: {
    BktButton
  }
}
</script>