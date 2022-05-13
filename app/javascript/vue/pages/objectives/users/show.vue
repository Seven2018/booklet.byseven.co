<template>
  <div>
    <div v-if="objectiveUser.user" class="width-70 mt-5 mx-auto">
      <div class="flex-row-center-centered">
        <h1 v-if="title" class="fs-2_4rem font-weight-500">{{title}}</h1>
        <h1 v-else class="fs-2_4rem font-weight-500">My Objectives</h1>
      </div>
      <div class="flex-row-center-centered mt-5 position-relative">
        <div
            v-if="backButton"
            class="position-absolute" style="left: 0">
          <bkt-back-button></bkt-back-button>
        </div>
        <img class="rounded-circle width-5rem height-5rem border-bkt-blue-2px"
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
        <p class="font-weight-600 fs-1_4rem bkt-light-grey6 ">{{ objectiveUser.user.job_title }}</p>
      </div>
      <div class="flex-row-end-centered mt-5">
        <bkt-button type="blue" iconify="ant-design:plus-circle-outlined" :href="$routes.generate('objective_new')">
          New objective
        </bkt-button>
      </div>
    </div>

    <div class="width-70 mt-5 mx-auto">
      <objective-switcher
        v-if="objectiveUser.objectivesCurrent && objectiveUser.objectivesArchived"
        :current-nbr="objectiveUser.objectivesCurrent.length"
        :archived-nbr="objectiveUser.objectivesArchived.length"
      >
        <template v-slot:current>
          <objectives-user-table
              :headers="headers"
              :table-data="objectiveUser.objectivesCurrent"
          ></objectives-user-table>
        </template>

        <template v-slot:archived>
          <objectives-user-table
              :headers="headers"
              :table-data="objectiveUser.objectivesArchived"
              :show-options="false"
          ></objectives-user-table>
        </template>
      </objective-switcher>
    </div>
  </div>
</template>

<script>
import store from "../../../store";
import BktButton from "../../../components/BktButton";
import IndexTable from "../../../components/IndexTable";
import ObjectivesUserTable from "./ObjectivesUserTable";
import ObjectiveSwitcher from "../../../components/ObjectiveSwitcher";
import BktBackButton from "../../../components/BktBackButton";

export default {
  props: ['userId', 'title', 'backButton'],
  data() {
    return {
      headers: ['Objectives', 'Completion', 'Deadline', ''],
      objectiveUser: store.state.objectiveUser,
      panelCurrentObjective: true,
    }
  },
  created() {
    store.dispatch('objectiveUser/fetchUser', this.userId)
    store.dispatch('objectiveUser/fetchUserObjectivesCurrent', this.userId)
    store.dispatch('objectiveUser/fetchUserObjectivesArchived', this.userId)
  },
  methods: {
    togglePanelCurrentObjective() {
      this.panelCurrentObjective = !this.panelCurrentObjective
    }
  },
  components: {
    BktBackButton,
    ObjectiveSwitcher,
    ObjectivesUserTable,
    BktButton,
    IndexTable
  },
}
</script>