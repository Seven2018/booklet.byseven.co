
<template>
  <div class="bkt-tag-container flex-row-start-centered">
    <bkt-tag class="bkt-tag"
        v-for="tag in tags" :key="tag.id"
    >
      {{tag.title}}
    </bkt-tag>
  </div>
</template>

<script>
import BktTag from "./BktTag";
export default {
  components: {BktTag},
  props: ['tags'],
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
          if (result > 150) {
            tag.remove()
          } else {
            last_index = index
          }
        })

        if (result > 150) {
          var newDiv = document.createElement('div')
          newDiv.classList.add('mr-2', 'rounded-15px', 'py-1', 'px-3', 'font-weight-500', 'bkt-bg-light-blue', 'bkt-blue')
          newDiv.innerHTML = `<p class="fs-1_2rem">+${tags.length -(last_index + 1)}</p>`
          newDiv.setAttribute('data-toggle', 'tooltip');
          newDiv.setAttribute('title', tooltip_content)
          container.appendChild(newDiv)
        }

    }

  }
}

</script>
