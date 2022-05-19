<template>
  <div class="width-80 mt-5 mx-auto">
    <div class="flex-row-between-centered mb-5">
      <div class="flex-column">
        <h1 class="font-weight-700 fs-2_4rem">Employees objectives</h1>
      </div>
      <div class="flex-column">
        <bkt-button type="blue" iconify="ant-design:plus-circle-outlined" :href="$routes.generate('objective_new')">
          New objective
        </bkt-button>
      </div>
    </div>

    <bkt-box>
      <bkt-search></bkt-search>

      <index-table
          :headers="headers"
          :tableData="adminObjectives.users">
        <template v-slot="{id, firstname, lastname, picture, job_title, access_level_int, manager, objectives_count}">
          <td>
            <div class="d-flex align-items-center">
              <div class="flex-column ">
                <img class="rounded-circle width-3rem height-3rem"
                     :src="picture"
                     onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
                     alt="">
              </div>

              <div class="flex-column ml-3 width-25rem ">
                <div class="flex-row-start-centered">
                  <p class="font-weight-500 text-truncate">{{ `${firstname} ${lastname}` }}</p>
                </div>
                <div class="flex-row-start-centered">
                  <p class="font-weight-500 fs-1_2rem bkt-light-grey6 text-truncate">{{ job_title }}</p>
                </div>
              </div>
            </div>
          </td>

          <td>
            <div class="align-items-center">
              <div class="flex-column ">
                <p>
                  {{ access_level_int | convert_hr | capitalize }}
                </p>
                <a
                    v-if="access_level_int !== 'employee'"
                    :href="$routes.generate('objective_user_my_team_objectives', {id})"
                    class="bkt-objective-blue"
                    style="text-decoration: underline">View Team Objective</a>
              </div>
            </div>
          </td>

          <td>
            <div v-if="manager" class="d-flex align-items-center">
              <div class="flex-column ">
                <img class="rounded-circle width-4rem height-3rem"
                     :src="manager.picture"
                     onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
                     alt="">
              </div>

              <div class="flex-column ml-3 width-25rem">
                <div class="flex-row-start-centered">
                  <p class="font-weight-500 text-truncate">{{ `${manager.firstname} ${manager.lastname}` }}</p>
                </div>
              </div>
            </div>
          </td>


          <td>
            <p>
              {{ objectives_count }}
            </p>
          </td>

          <td>
            <div class="flex-row-between-centered align-items-center">
              <div class="flex-column ">
                <a
                    v-if="manager"
                    :href="$routes.generate('objective_user_my_team_objectives', {id: manager.id})"
                    class="bkt-objective-blue"
                    style="text-decoration: underline">View Team Objective of his/her manager</a>
              </div>

              <div class="flex-column">
                <bkt-button type="blue" :href="$routes.generate('objective_user_show', {id})">
                  View objectives
                </bkt-button>
              </div>
            </div>
          </td>
        </template>
      </index-table>
    </bkt-box>

  </div>
</template>

<script>
import BktButton from '../../../components/BktButton';
import BktBox from "../../../components/BktBox";
import BktSearch from "../../../components/bktSearch";
import IndexTable from '../../../components/IndexTable'
import store from "../../../store";

export default {
  data() {
    return {
      headers: ['Name', 'Access Level', 'Manager', 'Objectives', ''],
      adminObjectives: store.state.adminObjectives,
    }
  },
  components: {
    BktSearch,
    BktBox,
    BktButton,
    IndexTable
  }
}
</script>
