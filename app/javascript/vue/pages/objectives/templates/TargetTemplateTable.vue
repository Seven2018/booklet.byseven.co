<template>
  <index-table
      v-if="genericFetchEntity.data"
      :headers="headers"
      headerClass="bkt-light-grey6"
      :table-data="genericFetchEntity.data['objective/templates']"
      :pagination="genericFetchEntity.pagination"
      @fetch-page="fetchPage($event, 'objective_templates_list')"
      @row-click="rowClick"
  >
    <template v-slot="{id, title, updated_at, objective_indicator}">
      <td>
        <div class="align-items-center">
          <div class="flex-column ">
            <p>
              {{ title }}
            </p>
          </div>
        </div>
      </td>

      <td>
        <div class="d-flex align-items-center">
          <span
              class="iconify mr-2"
              :data-icon="getIndicatorIconifyName(objective_indicator.indicator_type)"
              data-width="15"
          ></span>
          <p v-if="objective_indicator.indicator_type == 'numeric_value'">
            {{objective_indicator.options.target_value}}
          </p>
          <p v-else-if="objective_indicator.indicator_type == 'boolean'">
            {{objective_indicator.options.starting_value}}/{{objective_indicator.options.target_value}}
          </p>
          <p v-else-if="objective_indicator.indicator_type == 'percentage'">
            {{objective_indicator.options.target_value}    fetchPage(page) {
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'objective_templates_list',
        params: {
          'page[number]': page,
        }
      })
    },
}
          </p>
          <p v-else-if="objective_indicator.indicator_type == 'multi_choice'">
            {{filterMultiChoiceCount(objective_indicator.options)}}
          </p>
        </div>
      </td>

      <td>
        <div class="d-flex align-items-center">
          <span class="iconify" data-icon="bi:calendar"></span>
          <p class="ml-2">
            {{ updated_at | formatDate }}
          </p>
        </div>
      </td>

      <td>
        <div class="d-flex align-items-center">
          <bkt-dots-button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-red bkt-bg-light-grey10-hover width-100 pl-3 pr-3 p-3"
                @click.stop="deleteTemplate(id)"
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
import tools from "../../../mixins/tools";
import store from "../../../store";
import IndexTable from "../../../components/IndexTable";
import BktDotsButton from '../../../components/BktDotsButton'

export default {
  mixins: [tools],
  data() {
    return {
      headers: ['Template title', 'Indicator', 'Last update', ''],
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  created() {
    store.dispatch('genericFetchEntity/fetch',
        {
          pathKey: 'objective_templates_list'
        }
    )
  },
  methods: {
    deleteTemplate(id) {
      store.dispatch('genericFetchEntity/delete', {
        pathKey: 'objective_templates_id',
        id,
        dataKind: 'objective/templates'
      })
    },
    rowClick(row) {
      // console.log(row, this.$routes.generate('objective_templates_edit', {id: row.id}))
      window.location.href = this.$routes.generate('objective_templates_edit', {id: row.id})
    }
  },
  components: {IndexTable, BktDotsButton}
}
</script>
