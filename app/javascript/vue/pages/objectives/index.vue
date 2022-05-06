<template>
  <div class="width-80 mt-5 mx-auto">
    <div class="flex-row-between-centered mb-5">
      <div class="flex-column">
        <h1 class="font-weight-700 fs-2_4rem">Employees objectives</h1>
      </div>
      <div class="flex-column">
        <bkt-button type="blue" iconify="ant-design:plus-circle-outlined">
          New objective
        </bkt-button>
      </div>
    </div>

    <bkt-box>
      <div class="flex-row-start-centered mb-5">
        <bkt-search></bkt-search>
        <p class="ml-5 font-weight-500">
          Reset
        </p>
      </div>

      <index-table
          :headers="headers"
          :tableData="tableData">
        <template v-slot="{name, jobTitle, accessLevel, manager, objectives, objectivesTeamLink, objectiveLink}">
          <td>
            <div class="d-flex align-items-center">
              <div class="flex-column ">
                <img class="rounded-circle width-3rem height-3rem" src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/2048px-Circle-icons-profile.svg.png" alt="">
              </div>

              <div class="flex-column ml-3">
                <div class="flex-row-start-centered">
                  <p class="font-weight-500">{{name}}</p>
                </div>
                <div class="flex-row-start-centered">
                  <p class="font-weight-500 fs-1_2rem bkt-light-grey6">{{jobTitle}}</p>
                </div>
              </div>
            </div>
          </td>

          <td>
            <p>
              {{accessLevel}}
            </p>
          </td>

          <td>
            <p>
              {{manager}}
            </p>
          </td>


          <td>
            <p>
              {{objectives}}
            </p>
          </td>

          <td>
            <p>
              {{objectivesTeamLink}}

              {{objectiveLink}}
            </p>
          </td>
        </template>
      </index-table>
    </bkt-box>
  </div>
</template>

<script>
import BktButton from '../../components/BktButton';
import BktBox from "../../components/BktBox";
import BktSearch from "../../components/bktSearch";
import IndexTable from '../../components/IndexTable'

export default {
  data() {
    return {
      headers: ['Name', 'Access Level', 'Manager', 'Objectives', ''],
      tableData: [
        {name: 'Marvin', jobTitle: 'Web Designer', accessLevel: 'Manager', manager: {image: '', name: 'Ralph Edwards'}, objectives: 4, objectivesTeamLink: 'teamlink', objectiveLink: 'link'},
        {name: 'Marvin', jobTitle: 'Web Designer', accessLevel: 'Manager', manager: {image: '', name: 'Ralph Edwards'}, objectives: 4, objectivesTeamLink: 'teamlink', objectiveLink: 'link'},
      ]
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