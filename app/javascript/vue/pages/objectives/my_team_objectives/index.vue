<template>
    <div class="width-70 mt-5 mx-auto">
      <div class="flex-row-center-centered">
        <h1 class="fs-2_4rem font-weight-500">My team objectives</h1>
      </div>

      <div class="flex-row-end-centered mt-5">
        <bkt-button type="blue" iconify="ant-design:plus-circle-outlined" :href="$routes.generate('objective_new')">
          New objective
        </bkt-button>
      </div>

      <div class="flex-row-start-centered">
        <objective-switcher
            v-if="myTeamObjectives.employeesCurrent && myTeamObjectives.employeesArchived"
            :current-nbr="myTeamObjectives.employeesCurrent.length"
            :archived-nbr="myTeamObjectives.employeesArchived.length"
        >
          <template v-slot:current>
            <my-team-objectives-table
                :headers="headers"
                :table-data="myTeamObjectives.employeesCurrent"
            ></my-team-objectives-table>
          </template>
          <template v-slot:archived>
            <my-team-objectives-table
                :headers="headers"
                :table-data="myTeamObjectives.employeesArchived"
                :show-options="false"
            ></my-team-objectives-table>
          </template>
        </objective-switcher>
      </div>
    </div>
</template>

<script>
import BktButton from "../../../components/BktButton";
import ObjectiveSwitcher from "../../../components/ObjectiveSwitcher";
import MyTeamObjectivesTable from "./MyTeamObjectivesTable";
import store from "../../../store";

export default {
  data() {
    return {
      headers: ['Employees', 'Objectives', 'Completion', 'Deadline', ''],
      myTeamObjectives: store.state.myTeamObjectives
    }
  },
  created() {
    store.dispatch('myTeamObjectives/fetchEmployeesCurrent')
    store.dispatch('myTeamObjectives/fetchEmployeesArchived')
  },
  components: {
    MyTeamObjectivesTable,
    BktButton,
    ObjectiveSwitcher
  }
}
</script>