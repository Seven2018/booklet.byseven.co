<template>
  <index-table
      v-if="genericFetchEntity.data"
      :headers="headers"
      :table-data="genericFetchEntity.data['interview_reports']"
      :pagination="genericFetchEntity.pagination"
      :without-hover="true"
      @fetch-page="fetchPage($event, 'interviews_reports')"
  >
    <template v-slot="{id, creator, created_at, mode, start_time, end_time, processing, csv_path, xlsx_path}">
      <td>
        <user-info-in-table :user="creator"></user-info-in-table>
      </td>

      <td>
        <p>
          {{ created_at | formatDate }}
        </p>
      </td>

      <td>
        <div class="flex-row-start-centered align-items-center">
          <div class="p-2 bkt-bg-light-blue rounded-2px mr-2">
            <span class="iconify bkt-blue" data-icon="bi:clipboard2-data-fill"></span>
          </div>
          <p>
            {{strMode(mode)}}
          </p>
        </div>
      </td>

      <td>
        <p>
          {{start_time | formatDate}}
        </p>
      </td>


      <td>
        <p>
          {{end_time | formatDate}}
        </p>
      </td>

      <td>
        <div class="flex-row-start-centered align-items-center">
          <a :href="csv_path" class="mr-4">
            <i class="fas fs-2_4rem fa-file-csv "></i>
          </a>
          <a :href="xlsx_path" class="mr-4">
            <i class="fas fs-2_4rem fa-file-excel"></i>
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
import BktTableFirstColumn from "../../../components/BktTableFirstColumn";
import DisplayTagInIndex from "../../../components/DisplayTagInIndex";
import BktDotsButton from "../../../components/BktDotsButton";
import UserQuickIndo from "../../../components/UserQuickIndo";
import UserInfoInTable from "../../../components/UserInfoInTable";

export default {
  mixins: [tools],
  data() {
    return {
      headers: ['Creator', 'Created at', 'Type', 'From', 'To', 'Downloads'],
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  created() {
    store.dispatch('genericFetchEntity/fetch',
        {
          pathKey: 'interviews_reports'
        }
    )
  },
  methods: {
    strMode(mode) {
      const arr = {
        classic: "Analytics",
        data: "Global data",
        answers: "Answers"
      }
      return arr[mode]
    },
    iconMode(mode) {
      const arr = {
        classic: "clarity:line-chart-solid",
        data: "bi:clipboard2-data-fill",
        answers: "fluent:chat-multiple-16-filled"
      }
      return arr[mode]
    }
  },
  components: {UserInfoInTable, UserQuickIndo, DisplayTagInIndex, BktTableFirstColumn, IndexTable, BktDotsButton}
}
</script>