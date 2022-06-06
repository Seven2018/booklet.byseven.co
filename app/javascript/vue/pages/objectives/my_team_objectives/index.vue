<template>
  <div class="width-70 mt-5 mx-auto">

    <div class="flex-row-center-centered pos-rel">

      <bkt-back-button v-if="backButton"
                       class="flex-column pos-abs-sm"
                       style="top: 0; left: 0;">
      </bkt-back-button>

      <h1 v-if="title" class="flex-column fs-2_4rem font-weight-500">{{title}}</h1>
      <h1 v-else class="fs-2_4rem font-weight-500">My team Roadmap</h1>

    </div>

    <user-quick-indo :user="myTeamObjectives.user"></user-quick-indo>

    <div class="flex-row-end-centered mt-5">
      <bkt-new-target-button></bkt-new-target-button>
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
import UserQuickIndo from "../../../components/UserQuickIndo";
import BktNewTargetButton from "../../../components/BktNewTargetButton";

export default {
  mixins: [tools],
  props: ['userId', 'title', 'backButton'],
  data() {
    return {
      headers: ['Employees', 'Targets', 'Completion', 'Deadline', ''],
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
        textLoading: 'Archiving ...',
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
        textLoading: 'Unarchiving ...',
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
        textLoading: 'Deleting ...',
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
    UserQuickIndo,
    MyTeamObjectivesTable,
    BktButton,
    BktBackButton,
    ObjectiveSwitcher,
    BktDotsButton,
    BktNewTargetButton
  }
}
</script>
