<template>
  <div>
    <div v-if="objectiveUser.user" class="width-70 mt-5 mx-auto">
      <div class="flex-row-center-centered">
        <h1 class="fs-2_4rem font-weight-500">My Objective</h1>
      </div>
      <div class="flex-row-center-centered mt-5">
        <img class="rounded-circle width-5rem height-5rem"
             :src="objectiveUser.user.picture"
             onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
             alt="">
      </div>
      <div class="flex-row-center-centered mt-2">
        <h1 class="fs-2_4rem font-weight-500">{{
            `${objectiveUser.user.firstname} ${objectiveUser.user.lastname}`
          }}</h1>
      </div>
      <div class="flex-row-center-centered mt-2">
        <p class="font-weight-500 fs-1_2rem bkt-light-grey6 ">{{ objectiveUser.user.job_title }}</p>
      </div>
      <div class="flex-row-end-centered mt-5">
        <bkt-button type="blue" iconify="ant-design:plus-circle-outlined" :href="$routes.generate('objective_new')">
          New objective
        </bkt-button>
      </div>
    </div>
    <div v-if="objectiveUser.objectives">
      test
    </div>
  </div>
</template>

<script>

import store from "../../../store";
import BktButton from "../../../components/BktButton";

export default {
  components: {BktButton},
  props: ['userId'],
  data() {
    return {
      objectiveUser: store.state.objectiveUser
    }
  },
  created() {
    store.dispatch('objectiveUser/fetchUser', this.userId)
    store.dispatch('objectiveUser/fetchUserObjectivesCurrent', this.userId)
    store.dispatch('objectiveUser/fetchUserObjectivesArchived', this.userId)
  }
}
</script>