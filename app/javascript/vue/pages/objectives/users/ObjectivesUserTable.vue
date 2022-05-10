<template>
  <index-table
      :headers="headers"
      headerClass="bkt-light-grey6"
      :table-data="tableData"
  >
    <template v-slot="{title, due_date, objective_indicator}">
      <td>
        <div class="flex-row-start-centered max-w-25rem">
          <span v-if="isCompleted(objective_indicator)" class="iconify mr-2 bkt-light-grey5" data-width="20" data-icon="akar-icons:check"></span>
          <p
              class="font-weight-500 text-truncate"
              :class="{'bkt-light-grey5': isCompleted(objective_indicator)}"
          >{{ title }}</p>
        </div>
      </td>

      <td>
        <p
            class="font-weight-500"
            :class="{'bkt-light-grey5': isCompleted(objective_indicator)}"
        >
          <span
            v-if="objective_indicator.indicator_type === 'boolean'"
          >
            actual value: {{objective_indicator.options.starting_value}}, target value: {{objective_indicator.options.target_value}}
          </span>
          <span
              v-else-if="objective_indicator.indicator_type === 'numeric_value'"
          >
            {{objective_indicator.options.starting_value}}/{{objective_indicator.options.target_value}}
          </span>
          <span
              v-else-if="objective_indicator.indicator_type === 'percentage'"
          >
            {{objective_indicator.options.target_value}}%
          </span>
          <span
              v-else-if="objective_indicator.indicator_type === 'multi_choice'"
          >
            {{objective_indicator.options}}
          </span>
        </p>
      </td>

      <td>
        <p
            class="font-weight-500 text-truncate"
            :class="{'bkt-light-grey5': isCompleted(objective_indicator)}"
        >{{ due_date }}</p>
      </td>

      <td>
        <bkt-dots-button>
          test
        </bkt-dots-button>
      </td>
    </template>
  </index-table>
</template>

<script>
import IndexTable from "../../../components/IndexTable";
import BktDotsButton from '../../../components/BktDotsButton'

export default {
  props: ['headers', 'tableData'],
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
    }
  },
  components: {
    IndexTable,
    BktDotsButton
  }
}
</script>