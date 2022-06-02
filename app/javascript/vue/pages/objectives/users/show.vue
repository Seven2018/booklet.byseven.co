<template>
  <div>
    <div v-if="objectiveUser.user" class="width-70 mt-5 mx-auto">
      <div class="flex-row-center-centered pos-rel">

        <bkt-back-button v-if="backButton"
                       class="flex-column pos-abs-sm"
                       style="top: 0; left: 0;">
        </bkt-back-button>

        <h1 v-if="title" class="flex-column fs-2_4rem font-weight-500">{{title}}</h1>
        <h1 v-else class="flex-column fs-2_4rem font-weight-500">My Objectives</h1>

      </div>

      <user-quick-indo :user="objectiveUser.user"></user-quick-indo>

      <div class="flex-row-end-centered mt-5">
        <bkt-new-target-button></bkt-new-target-button>
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
          >
            <template v-slot:default="{id}">
              <bkt-dots-button>
                <button
                    class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                    @click="openPopUpArchive(id)"
                >
                  Archive objective
                </button>
                <button
                    class="flex-row-start-centered fs-1_4rem bkt-red bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                    @click="openPopUpDelete(id)"
                >
                  Delete
                </button>
              </bkt-dots-button>
            </template>
          </objectives-user-table>
        </template>

        <template v-slot:archived>
          <objectives-user-table
              :headers="headers"
              :table-data="objectiveUser.objectivesArchived"
          >
            <template v-slot:default="{id}">
              <bkt-dots-button>
                <button
                    class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                    @click="openPopUpUnarchive(id)"
                >
                  Unarchive objective
                </button>
                <button
                    class="flex-row-start-centered fs-1_4rem bkt-red bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                    @click="openPopUpDelete(id)"
                >
                  Delete
                </button>
              </bkt-dots-button>
            </template>
          </objectives-user-table>
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
import BktDotsButton from '../../../components/BktDotsButton'
import UserQuickIndo from "../../../components/UserQuickIndo";
import BktNewTargetButton from "../../../components/BktNewTargetButton";

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
    },
    openPopUpArchive(id) {
      this.$modal.open({
        type: 'normal',
        title: `Are you sure you want to archive this objective ?<br/>(This is not a permanent action)`,
        textClose: 'No',
        textConfirm: 'Yes, archive',
        textLoading: 'Archiving ...',
        close() {},
        confirm() {
          store
              .dispatch('objectiveUser/archiveObjectiveUser', id)
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
        close() {},
        confirm() {
          store
              .dispatch('objectiveUser/unarchiveObjectiveUser', id)
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
        close() {},
        confirm() {
          store
              .dispatch('objectiveUser/deleteObjectiveUser', id)
              .then(() => this.$modal.close())
        }
      })
    }
  },
  components: {
    BktNewTargetButton,
    UserQuickIndo,
    BktBackButton,
    ObjectiveSwitcher,
    ObjectivesUserTable,
    BktButton,
    IndexTable,
    BktDotsButton
  },
}
</script>
