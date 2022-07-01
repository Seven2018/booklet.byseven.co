
<template>
  <div class="width-100 h-30vh flex-column-centered justify-content-center">
    <div class="fs-3_5rem">
      🤔
    </div>
    <p v-if="genericFetchEntity.search && genericFetchEntity.search.title" class="text-center">
      Oops, it seems no item can be found with the search ‘<span >{{ genericFetchEntity.search.title }}</span>’.<br>
    </p>
    <p v-if="genericFetchEntity.tags && genericFetchEntity.tags.length > 0" class="text-center">
      Oops, it seems no item can be found with the tags ‘<span >{{ genericFetchEntity.tags.map(tag => tag.title).join(', ') }}</span>’.<br>
    </p>
    <p v-if="genericFetchEntity.search && genericFetchEntity.search.status" class="text-center">
      Oops, it seems no item can be found with the status ‘<span >{{ genericFetchEntity.search.status }}</span>’.<br>
    </p>
    <p v-if="genericFetchEntity.search && checkUserCategories(genericFetchEntity.search.userCategories)" class="text-center">
      Oops, it seems no item can be found with the user categories.<br>
    </p>
    <p class="text-center">
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
  },
  methods: {
    checkUserCategories(userCategories) {
      if (userCategories.length < 1) return false

      let ret = false
      userCategories.forEach(userCat => {
        if (userCat.selectedValue !== '') ret = true
      })
      return ret
    }
  }
}
</script>
