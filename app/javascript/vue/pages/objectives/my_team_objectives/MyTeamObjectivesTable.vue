<template>
  <index-table
      :headers="headers"
      headerClass="bkt-light-grey6"
      :table-data="tableData"
      :without-hover="true"
  >
    <template v-slot="{id, firstname, lastname, job_title, picture, objective_elements}">
      <td style="vertical-align: top">
        <div class="d-flex align-items-center ml-3">
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

      <td class="border-left-bkt-light-grey">
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

      <td>
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
              actual value: {{
                element.objective_indicator.options.starting_value
              }}, target value: {{ element.objective_indicator.options.target_value }}
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

      <td>
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

      <td v-if="showOptions">
        <div
            v-for="(element, idx) in objective_elements"
            @mouseover="setHover(`key-${id}-${idx}`)"
            @mouseleave="removeHover(`key-${id}-${idx}`)"
            :class="`key-${id}-${idx}`"
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
        close() {
        },
        confirm() {
          store
              .dispatch('myTeamObjectives/archiveObjectiveUser', id)
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
    setHover(className) {
      const elems = document.querySelectorAll(`.${className}`)
      elems.forEach(el => {
        el.classList.add('bkt-bg-light-grey10')
      })
    },
    removeHover(className) {
      const elems = document.querySelectorAll(`.${className}`)
      elems.forEach(el => {
        el.classList.remove('bkt-bg-light-grey10')
      })
    }
  },
  components: {
    IndexTable,
    BktDotsButton,
  }
}
</script>
