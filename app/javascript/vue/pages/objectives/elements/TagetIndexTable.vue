<template>
  <index-table
      v-if="genericFetchEntity.data"
      :headers="headers"
      :table-data="genericFetchEntity.data['objective/elements']"
      :pagination="genericFetchEntity.pagination"
      @fetch-page="fetchPage($event, 'objective_target_list')"
  >
    <template v-slot="{id, title, due_date, comments_count, objectivable, objective_indicator}">
      <td>
        <div class="align-items-center">
          <div class="flex-column ">
            <p class="font-weight-600 bkt-dark-grey">
              {{ title }}
            </p>
          </div>
        </div>
      </td>

      <td>
        <user-info-in-table :user="objectivable"></user-info-in-table>
      </td>

      <td>
        <div class="d-flex align-items-center">
          <span
              class="iconify mr-2"
              :data-icon="getIndicatorIconifyName(objective_indicator.indicator_type)"
              data-width="15"
          ></span>
          <p class="font-weight-600" :class="[objective_indicator.status == 'completed' ? ' bkt-objective-blue' : 'bkt-red']">
            <span v-if="objective_indicator.indicator_type === 'multi_choice'">
              {{filterMultiChoiceCount(objective_indicator.options)}}
            </span>
            <span v-else>
              {{objective_indicator.options.current_value}}
            </span>
          </p>
<!--          <p v-else >{{// objective_indicator.options.current_value}}</p>-->
<!--          <p v-if="objective_indicator.status == 'completed'">-->
<!--            Confirmed-->
<!--          </p>-->
<!--          <p v-else>Not confirmed</p>-->
        </div>
      </td>

      <td>
        <div class="d-flex align-items-center">
          <span class="iconify" data-icon="bi:calendar"></span>
          <p class="ml-2">
            {{ due_date }}
          </p>
        </div>
      </td>

      <td>
        <div class="d-flex align-items-center">
          <span class="iconify" data-icon="bi:chat-dots"></span>
          <p class="ml-2">
            {{ comments_count }} comments
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
import UserInfoInTable from "../../../components/UserInfoInTable";

export default {
  mixins: [tools],
  data() {
    return {
      headers: ['Target title', 'Employee', 'Indicator', 'Deadline', 'Comments', ''],
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  created() {
    store.dispatch('genericFetchEntity/fetch',
        {
          pathKey: 'objective_target_list'
        }
    )
  },
  methods: {
  },
  components: {UserInfoInTable, IndexTable}
}
</script>