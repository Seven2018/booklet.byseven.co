
<template>
  <div class="width-100 h-30vh flex-column-centered justify-content-center">
    <div class="fs-3_5rem">
      🤔
    </div>
    <p v-if="genericFetchEntity.search && genericFetchEntity.search.title" class="text-center">
      Oops, it seems any items can be found with the search ‘<span >{{ genericFetchEntity.search.title }}</span>’.<br>
      Please try something else.
    </p>
    <p v-if="genericFetchEntity.tags && genericFetchEntity.tags.length > 0" class="text-center">
      Oops, it seems any items can be found with the tags ‘<span >{{ genericFetchEntity.tags.map(tag => tag.title).join(', ') }}</span>’.<br>
      Please try something else.
    </p>
  </div>
</template>

<script>
import store from "../store";

export default {
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity
    }
  }
}
</script>