
<template>
  <div>
    test
  </div>
</template>

<script>
import BktSwitcher from "../../components/BktSwitcher";
import store from "../../store";
import MyInterviewCard from "./MyInterviewCard";

export default {
  props: [''],
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  created() {
    store.dispatch('genericFetchEntity/fetch', {pathKey: 'my_team_interviews_list'})
  },
  components: {MyInterviewCard, BktSwitcher},
}
</script>