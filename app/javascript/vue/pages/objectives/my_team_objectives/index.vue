<template>
  <div class="width-70 mt-5 mx-auto">

    <div class="flex-row-center-centered pos-rel">

      <bkt-back-button v-if="backButton"
                       class="pos-abs"
                       style="top: 0; left: 0;">
      </bkt-back-button>

      <h1 v-if="title" class="fs-2_4rem font-weight-500">{{title}}</h1>
      <h1 v-else class="fs-2_4rem font-weight-500">My team objectives</h1>

    </div>

    <div class="flex-row-center-centered mt-5 position-relative">
      <img class="rounded-circle width-5rem height-5rem border-bkt-blue-2px"
           :src="myTeamObjectives.user.picture"
           onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
           alt="">
    </div>
    <div class="flex-row-center-centered mt-2">
      <h1 class="fs-2_4rem font-weight-500">{{
          `${myTeamObjectives.user.firstname} ${myTeamObjectives.user.lastname}`
        }}</h1>
    </div>
    <div class="flex-row-center-centered mt-2">
      <p class="font-weight-600 fs-1_4rem bkt-light-grey6 ">{{ myTeamObjectives.user.job_title }}</p>
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
          >
            <template v-slot:default="{obj}">
              <div
                  v-for="(element, idx) in obj.objective_elements"
                  @mouseover="setHover(`key-${obj.userId}-${idx}`)"
                  @mouseleave="removeHover(`key-${obj.userId}-${idx}`)"
                  :class="`key-${obj.userId}-${idx}`"
                  class="flex-row-start-centered my-2 py-1"
              >
                <bkt-dots-button>
                  <button
                      class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                      @click="openPopUpArchive(element.id)"
                  >
                    Archive objective
                  </button>
                  <button
                      class="flex-row-start-centered fs-1_4rem bkt-red bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                      @click="openPopUpDelete(element.id)"
                  >
                    Delete
                  </button>
                </bkt-dots-button>
              </div>
            </template>
          </my-team-objectives-table>
        </template>
        <template v-slot:archived>
          <my-team-objectives-table
              :headers="headers"
              :table-data="myTeamObjectives.employeesArchived"
          >
            <template v-slot:default="{obj}">
              <div
                  v-for="(element, idx) in obj.objective_elements"
                  @mouseover="setHover(`key-${obj.userId}-${idx}`)"
                  @mouseleave="removeHover(`key-${obj.userId}-${idx}`)"
                  :class="`key-${obj.userId}-${idx}`"
                  class="flex-row-start-centered my-2 py-1"
              >
                <bkt-dots-button>
                  <button
                      class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                      @click="openPopUpUnarchive(element.id)"
                  >
                    Unarchive objective
                  </button>
                  <button
                      class="flex-row-start-centered fs-1_4rem bkt-red bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                      @click="openPopUpDelete(element.id)"
                  >
                    Delete
                  </button>
                </bkt-dots-button>
              </div>
            </template>
          </my-team-objectives-table>
        </template>
      </objective-switcher>
    </div>
  </div>
</template>

<script>
import BktButton from "../../../components/BktButton";
import BktBackButton from "../../../components/BktBackButton";
import ObjectiveSwitcher from "../../../components/ObjectiveSwitcher";
import MyTeamObjectivesTable from "./MyTeamObjectivesTable";
import BktDotsButton from '../../../components/BktDotsButton'
import tools from '../../../mixins/tools'
import store from "../../../store";

export default {
  mixins: [tools],
  props: ['userId', 'title', 'backButton'],
  data() {
    return {
      headers: ['Employees', 'Objectives', 'Completion', 'Deadline', ''],
      myTeamObjectives: store.state.myTeamObjectives
    }
  },
  created() {
    store.commit('myTeamObjectives/setUserId', this.userId)
    store.dispatch('myTeamObjectives/fetchUser')
    store.dispatch('myTeamObjectives/fetchEmployeesCurrent')
    store.dispatch('myTeamObjectives/fetchEmployeesArchived')
  },
  methods: {
    openPopUpArchive(id) {
      this.$modal.open({
        type: 'normal',
        title: `Are you sure you want to archive this objective ?<br/>(This is not a permanent action)`,
        textClose: 'No',
        textConfirm: 'Yes, archive',
        close() {
        },
        confirm() {
          store
              .dispatch('myTeamObjectives/archiveObjectiveUser', id)
              .then(() => this.$modal.close())
        }
      })
    },
    openPopUpUnarchive(id) {
      this.$modal.open({
        type: 'normal',
        title: `Are you sure you want to unarchive this objective ?<br/>(This is not a permanent action)`,
        textClose: 'No',
        textConfirm: 'Yes, unarchive',
        close() {
        },
        confirm() {
          store
              .dispatch('myTeamObjectives/unarchiveObjectiveUser', id)
              .then(() => this.$modal.close())
        }
      })
    },
    openPopUpDelete(id) {
      this.$modal.open({
        type: 'delete',
        title: `Are you sure you want to delete this objective ?<br/>(This is a permanent action)`,
        textClose: 'No',
        textConfirm: 'Yes, delete',
        close() {
        },
        confirm() {
          store
              .dispatch('myTeamObjectives/deleteObjectiveUser', id)
              .then(() => this.$modal.close())
        }
      })
    },
  },
  components: {
    MyTeamObjectivesTable,
    BktButton,
    BktBackButton,
    ObjectiveSwitcher,
    BktDotsButton
  }
}
</script>
