
<template>
  <div class="flex-row-start-centered">
    <bkt-tag
        v-for="tag in tags.slice(0, 3)" :key="tag.id"
    >
      {{tag.title}}
    </bkt-tag>
    <div class="bkt-bg-light-blue bkt-blue mr-2 rounded-10px py-3 px-3 font-weight-600" v-if="tags.slice(3).length > 0">
      +{{tags.slice(3).length}}
    </div>
  </div>
</template>

<script>
import BktTag from "./BktTag";
export default {
  components: {BktTag},
  props: ['tags']
}
</script>