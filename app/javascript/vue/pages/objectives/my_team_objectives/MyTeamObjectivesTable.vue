<template>
  <index-table
      :headers="headers"
      headerClass="bkt-light-grey6"
      :table-data="tableData"
      :without-hover="true"
  >
    <template v-slot="{id, firstname, lastname, job_title, picture, objective_elements}">
      <td style="vertical-align: top" class="px-2">
        <a
            class="d-block bkt-bg-light-grey9-hover p-4 rounded-5px cursor-pointer"
            :href="$routes.generate('objective_user_show', {id})"
        >
          <div class="flex-row-start-centered align-items-center ml-3 " >
            <div class="flex-column ">
              <div class="flex-row-start-centered width-4rem height-3rem">
                <img class="rounded-circle"
                     :src="picture"
                     onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
                     alt="">
              </div>
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
        </a>
      </td>

      <td class="border-left-bkt-light-grey px-2">
        <div
            v-for="(element, idx) in objective_elements"
            @mouseover="setHover(`key-${id}-${idx}`)"
            @mouseleave="removeHover(`key-${id}-${idx}`)"
            :class="`key-${id}-${idx}`"
            class="flex-row-start-centered pl-4 my-2 py-2"
        >
          <a class="width-100" :href="$routes.generate('objective_elements_id', {id: element.id})">
            <div class="flex-row-start-centered max-w-25rem">
              <div v-if="isCompleted(element.objective_indicator)">
                <span class="iconify mr-2 bkt-light-grey5" data-width="20" data-icon="akar-icons:check"></span>
              </div>
              <p
                  class="font-weight-500 text-truncate"
                  :class="{'bkt-light-grey5': isCompleted(element.objective_indicator)}"
              >{{ element.title }}</p>
            </div>
          </a>
        </div>
      </td>

      <td class="px-2">
        <div
            v-for="(element, idx) in objective_elements"
            @mouseover="setHover(`key-${id}-${idx}`)"
            @mouseleave="removeHover(`key-${id}-${idx}`)"
            :class="`key-${id}-${idx}`"
            class="flex-row-start-centered my-2 py-2 width-100"
        >
          <a class="width-100" :href="$routes.generate('objective_elements_id', {id: element.id})">
            <p
                class="font-weight-500"
                :class="{'bkt-light-grey5': isCompleted(element.objective_indicator)}"
            >
            <span
                v-if="element.objective_indicator.indicator_type === 'boolean'"
            >
              value: {{
                element.objective_indicator.options.starting_value
              }}, target: {{ element.objective_indicator.options.target_value }}
            </span>
              <span
                  v-else-if="element.objective_indicator.indicator_type === 'numeric_value'"
              >
              {{
                  element.objective_indicator.options.starting_value
                }}/{{ element.objective_indicator.options.target_value }}
            </span>
              <span
                  v-else-if="element.objective_indicator.indicator_type === 'percentage'"
              >
              {{ element.objective_indicator.options.current_value }}%
            </span>
              <span
                  v-else-if="element.objective_indicator.indicator_type === 'multi_choice'"
              >
              <span v-if="!element.objective_indicator.options.starting_value">Not set yet</span>
              <span v-else>{{ element.objective_indicator.options.starting_value }}</span>
            </span>
            </p>
          </a>
        </div>
      </td>

      <td class="px-2">
        <div
            v-for="(element, idx) in objective_elements"
            @mouseover="setHover(`key-${id}-${idx}`)"
            @mouseleave="removeHover(`key-${id}-${idx}`)"
            :class="`key-${id}-${idx}`"
            class="flex-row-start-centered my-2 py-2 width-100"
        >
          <a class="width-100" :href="$routes.generate('objective_elements_id', {id: element.id})">
            <p
                class="font-weight-500 text-truncate"
                :class="{'bkt-light-grey5': isCompleted(element.objective_indicator)}"
            >{{ element.due_date || '-' }}</p>
          </a>
        </div>
      </td>

      <td v-if="showOptions" class="px-2">
        <slot v-bind:obj="{objective_elements, userId: id}"></slot>
      </td>
    </template>
  </index-table>
</template>

<script>
import IndexTable from "../../../components/IndexTable";
import BktDotsButton from '../../../components/BktDotsButton'
import tools from '../../../mixins/tools'

export default {
  mixins: [tools],
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
  },
  components: {
    IndexTable,
    BktDotsButton,
  }
}
</script>
