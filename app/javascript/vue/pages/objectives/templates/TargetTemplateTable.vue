<template>
  <index-table
      v-if="genericFetchEntity.data"
      :headers="headers"
      headerClass="bkt-light-grey6"
      :table-data="genericFetchEntity.data['objective/templates']"
      :pagination="genericFetchEntity.pagination"
      @fetch-page="fetchPage"
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
            {{objective_indicator.options.target_value}}
          </p>
        <p v-else-if="objective_indicator.indicator_type == 'multi_choice'">
            {{filterMultiChoice(objective_indicator.options)}}
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
          <a class="bkt-objective-blue underline" :href="$routes.generate('objective_elements_id', {id})">
            See details
          </a>
        </div>
      </td>
    </template>
  </index-table>
</template>

<script>
import tools from "../../../mixins/tools";
import store from "../../../store";
import IndexTable from "../../../components/IndexTable";

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
    fetchPage(page) {
      store.dispatch('genericFetchEntity/fetch', {
        pathKey: 'objective_templates_list',
        params: {
          'page[number]': page,
        }
      })
    },
    filterMultiChoice(opts) {
      let count = 0
      const regex = new RegExp(/^choice_.*/)

      for (const opt in opts) {
        if (regex.test(opt)) count++
      }
      return count
    }
  },
  components: {IndexTable}
}
</script>