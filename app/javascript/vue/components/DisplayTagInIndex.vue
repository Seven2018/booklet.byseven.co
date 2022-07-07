
<template>
  <div class="bkt-tag-container flex-row-start-centered">
    <bkt-tag class="bkt-tag"
        v-for="tag in tags" :key="tag.id"
    >
      {{tag.title}}
    </bkt-tag>

    <bkt-tag v-if="remainingTags > 0"
             class="bkt-tag">+{{remainingTags}}</bkt-tag>
  </div>
</template>

<script>
import BktTag from "./BktTag";
export default {
  components: {BktTag},
  props: ['tags'],
  data() {
    return {remainingTags: 0}
  },
  mounted() {
    this.hideOverflowingTags();
  },
  methods: {
    hideOverflowingTags() {
      const container = this.$el
      const tags = container.querySelectorAll('.bkt-tag')
      var result = 0
      var last_index = 0
      var tooltip_content = ''

      tags.forEach((tag, index) => {
        result += tag.offsetWidth
        tooltip_content += tag.innerText + '\n'
        if (result > 220) {
          tag.remove()
        } else {
          last_index = index
        }
      })

      if (result > 220) {
        this.remainingTags = tags.length -(last_index + 1)
      }
    }

  }
}

</script>
