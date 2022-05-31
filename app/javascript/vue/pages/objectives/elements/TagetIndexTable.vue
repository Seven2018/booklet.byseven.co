<template>
  <index-table
      :headers="headers"
      headerClass="bkt-light-grey6"
      :table-data="targetObjectives.targetList"
      :pagination="targetObjectives.pagination"
      @fetch-page="fetchPage"
  >
    <template v-slot="{id, title, due_date, comments_count, objectivable, objective_indicator}">
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
          <div class="flex-column ">
            <img class="rounded-circle width-3rem height-3rem"
                 :src="objectivable.picture"
                 onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
                 alt="">
          </div>

          <div class="flex-column ml-3 width-25rem ">
            <div class="flex-row-start-centered">
              <p class="font-weight-500 text-truncate">{{ `${objectivable.firstname} ${objectivable.lastname}` }}</p>
            </div>
            <div class="flex-row-start-centered">
              <p class="font-weight-500 fs-1_2rem bkt-light-grey6 text-truncate">{{ objectivable.job_title }}</p>
            </div>
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
          <p v-if="objective_indicator.status == 'completed'">
            Confirmed
          </p>
          <p v-else>Not confirmed</p>
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

export default {
  mixins: [tools],
  data() {
    return {
      headers: ['Target title', 'Employee', 'Indicator', 'Deadline', 'Comments', ''],
      targetObjectives: store.state.targetObjectives
    }
  },
  created() {
    store.dispatch('targetObjectives/fetchTargetList')
  },
  methods: {
    fetchPage(page) {
      // ${path}?page[number]=${pagination.current_page}&page[size]=10`
      store.dispatch('targetObjectives/fetchTargetList', {
        'page[number]': page,
        // 'page[size]': 1,
      })
    }
  },
  components: {IndexTable}
}
</script>