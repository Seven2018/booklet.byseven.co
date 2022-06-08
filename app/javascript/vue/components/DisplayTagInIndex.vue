
<template>
  <div class="flex-row-start-centered">
    <div
        class="bkt-bg-light-blue bkt-blue mr-2 rounded-10px py-2 px-2 font-weight-600"
        v-for="tag in tags.slice(0, 3)" :key="tag.id">
      <p>{{tag.title}}</p>
    </div>
    <div class="bkt-bg-light-blue bkt-blue mr-2 rounded-10px py-3 px-3 font-weight-600" v-if="tags.slice(3).length > 0">
      +{{tags.slice(3).length}}
    </div>
  </div>
</template>

<script>
export default {
  props: ['tags']
}
</script>