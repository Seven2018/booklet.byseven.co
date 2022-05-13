<template>
  <index-table
      :headers="headers"
      headerClass="bkt-light-grey6"
      :table-data="tableData"
  >
    <template v-slot="{id, title, due_date, objective_indicator}">
      <td>
        <a :href="$routes.generate('objective_elements_id', {id})">
          <div class="flex-row-start-centered max-w-25rem">
            <div v-if="isCompleted(objective_indicator)">
            <span  class="iconify mr-2 bkt-light-grey5" data-width="20"
                   data-icon="akar-icons:check"></span>
            </div>
            <p
                class="font-weight-500 text-truncate"
                :class="{'bkt-light-grey5': isCompleted(objective_indicator)}"
            >{{ title }}</p>
          </div>
        </a>
      </td>

      <td>
        <a :href="$routes.generate('objective_elements_id', {id})">
          <p
              class="font-weight-500"
              :class="{'bkt-light-grey5': isCompleted(objective_indicator)}"
          >
          <span
              v-if="objective_indicator.indicator_type === 'boolean'"
          >
            actual value: {{
              objective_indicator.options.starting_value
            }}, target value: {{ objective_indicator.options.target_value }}
          </span>
            <span
                v-else-if="objective_indicator.indicator_type === 'numeric_value'"
            >
            {{ objective_indicator.options.starting_value }}/{{ objective_indicator.options.target_value }}
          </span>
            <span
                v-else-if="objective_indicator.indicator_type === 'percentage'"
            >
            {{ objective_indicator.options.target_value }}%
          </span>
            <span
                v-else-if="objective_indicator.indicator_type === 'multi_choice'"
            >
            <span v-if="!objective_indicator.options.starting_value">Not set yet</span>
            <span v-else>{{ objective_indicator.options.starting_value }}</span>
          </span>
          </p>
        </a>
      </td>

      <td>
        <a :href="$routes.generate('objective_elements_id', {id})">
          <p
              class="font-weight-500 text-truncate"
              :class="{'bkt-light-grey5': isCompleted(objective_indicator)}"
          >{{ due_date }}</p>
        </a>
      </td>

      <td v-if="showOptions">
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
      </td>
    </template>
  </index-table>
</template>

<script>
import IndexTable from "../../../components/IndexTable";
import BktDotsButton from '../../../components/BktDotsButton'
import store from "../../../store";

export default {
  props: {
    headers: Array,
    tableData: Array,
    showOptions: {
      type: Boolean,
      default() {
        return true
      }
    }
  },
  methods: {
    isCompleted(indicator) {
      if (indicator.indicator_type === 'boolean' ||
          indicator.indicator_type === 'numeric_value') {
        return indicator.options.starting_value == indicator.options.target_value
      } else if (indicator.indicator_type === 'percentage') {
        return indicator.options.starting_value == '100'
      } else if (indicator.indicator_type === 'multi_choice') {
        return indicator.options.starting_value == indicator.options.choice_1
      }
    },
    openPopUpArchive(id) {
      this.$modal.open({
        type: 'normal',
        title: `Are you sure you want to archive this objective ?<br/>(This is not a permanent action)`,
        textClose: 'No',
        textConfirm: 'Yes, archive',
        close() {},
        confirm() {
          store
              .dispatch('objectiveUser/archiveObjectiveUser', id)
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
    IndexTable,
    BktDotsButton,
  }
}
</script>