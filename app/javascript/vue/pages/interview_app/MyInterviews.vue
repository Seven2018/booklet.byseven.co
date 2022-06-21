
<template>
  <div class="width-70 mt-5 mx-auto">
    <bkt-switcher
        v-if="genericFetchEntity.data"
        :current-nbr="1"
        :archived-nbr="0"
        title="interviews"
    >
      <template v-slot:current>
        current
      </template>
      <template v-slot:archived>
        archived
      </template>
    </bkt-switcher>
  </div>
</template>

<script>
import BktBanner from "../../components/BktBanner";
import BktSwitcher from "../../components/BktSwitcher";
import store from "../../store";

export default {
  props: ['bannerLink'],
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  created() {
    store.dispatch('genericFetchEntity/fetch', {pathKey: 'my_interviews_list'})
  },
  components: {BktSwitcher, BktBanner},
}
</script>