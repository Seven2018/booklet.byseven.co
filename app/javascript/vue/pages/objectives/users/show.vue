<template>
  <div>
    <div v-if="objectiveUser.user" class="width-70 mt-5 mx-auto">
      <div class="flex-row-center-centered">
        <h1 class="fs-2_4rem font-weight-500">My Objectives</h1>
      </div>
      <div class="flex-row-center-centered mt-5">
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
        <p class="font-weight-500 fs-1_2rem bkt-light-grey6 ">{{ objectiveUser.user.job_title }}</p>
      </div>
      <div class="flex-row-end-centered mt-5">
        <bkt-button type="blue" iconify="ant-design:plus-circle-outlined" :href="$routes.generate('objective_new')">
          New objective
        </bkt-button>
      </div>
    </div>
    <div class="flex-row-start-centered width-70 mt-5 mx-auto border-bottom-bkt-light-grey">
      <button
          class="pb-3 fs-1_6rem"
          :class="[panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-light-grey5', panelCurrentObjective ? 'border-bottom-bkt-objective-blue' : '']"
          @click="togglePanelCurrentObjective"
      >
        Currents objectives
        <span
            v-if="objectiveUser.objectivesCurrent"
            class="px-2 rounded-5px fs-1_2rem"
            :class="[panelCurrentObjective ? 'bkt-bg-objective-blue2' : 'bkt-bg-light-grey5', panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-white']">
          {{objectiveUser.objectivesCurrent.length}}
        </span>
        <span
            v-else
            class="px-2 rounded-5px fs-1_2rem"
            :class="[panelCurrentObjective ? 'bkt-bg-objective-blue2' : 'bkt-bg-light-grey5', panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-white']">
          0
        </span>
      </button>

      <button
          class="pb-3 pl-3 fs-1_6rem"
          :class="[!panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-light-grey5', !panelCurrentObjective ? 'border-bottom-bkt-objective-blue' : '']"
          @click="togglePanelCurrentObjective"
      >
        Archived objectives
        <span
            v-if="objectiveUser.objectivesArchived"
            class="px-2 rounded-5px fs-1_2rem"
            :class="[!panelCurrentObjective ? 'bkt-bg-objective-blue2' : 'bkt-bg-light-grey5', !panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-white']">
          {{objectiveUser.objectivesArchived.length}}
        </span>
        <span
            v-else
            class="px-2 rounded-5px fs-1_2rem"
            :class="[!panelCurrentObjective ? 'bkt-bg-objective-blue2' : 'bkt-bg-light-grey5', !panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-white']">
          0
        </span>
      </button>
    </div>
    <div class="width-70 mt-5 mx-auto">
      <objectives-user-table
          v-if="panelCurrentObjective"
          :headers="headers"
          :table-data="objectiveUser.objectivesCurrent"
      ></objectives-user-table>
      <objectives-user-table
          v-else-if="!panelCurrentObjective"
          :headers="headers"
          :table-data="objectiveUser.objectivesArchived"
          :show-options="false"
      ></objectives-user-table>
    </div>
  </div>
</template>

<script>
import store from "../../../store";
import BktButton from "../../../components/BktButton";
import IndexTable from "../../../components/IndexTable";
import ObjectivesUserTable from "./ObjectivesUserTable";

export default {
  props: ['userId'],
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
    ObjectivesUserTable,
    BktButton,
    IndexTable
  },
}
</script>