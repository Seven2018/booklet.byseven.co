
<template>
  <bkt-index-skeleton body-class="bkt-bg-white">
    <template v-slot:title>
      <div class="flex-row-between-centered mb-5">
        Reports
        <span class="iconify ml-4 mr-0_75rem fs-2_4rem" data-icon="ant-design:exclamation-circle-outlined"></span>
        <div class="fs-1_6rem">Reports are deleted 7 days after being created</div>
      </div>
    </template>
    <template v-slot:create-index>
      <bkt-button
          type="interview"
          iconify="ant-design:plus-circle-outlined"
          :href="$routes.generate('interviews_reports_edit')"
      >Create report</bkt-button>
    </template>
    <template v-slot:body>
      <interview-report-table v-show="genericFetchEntity.data && genericFetchEntity.data['interview_reports'] && genericFetchEntity.data['interview_reports'].length > 0"></interview-report-table>
      <bkt-create-entity-from-index
          v-if="genericFetchEntity.data && genericFetchEntity.data['interview_reports'] && genericFetchEntity.data['interview_reports'].length === 0 && !genericFetchEntity.search"
          type="interview"
          :href="$routes.generate('interviews_reports_edit')"
      >
        template
      </bkt-create-entity-from-index>
      <bkt-no-entity-from-index
          v-else-if="genericFetchEntity.data && genericFetchEntity.data['interview_reports'] && genericFetchEntity.data['interview_reports'].length === 0 && genericFetchEntity.search"
      ></bkt-no-entity-from-index>
      <bkt-box-loader v-else-if="!genericFetchEntity.data" type="interview"></bkt-box-loader>
    </template>
  </bkt-index-skeleton>
</template>
<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import BktButton from "../../../components/BktButton";
import GenericIndexSearch from "../../objectives/users/GenericIndexSearch";
import axios from "../../../plugins/axios";
import store from "../../../store";
import BktCreateEntityFromIndex from "../../../components/BktCreateEntityFromIndex";
import BktNoEntityFromIndex from "../../../components/BktNoEntityFromIndex";
import BktBoxLoader from "../../../components/BktBoxLoader";
import InterviewReportTable from "./InterviewReportTable";

export default {
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  methods: {
    async createInterviewForm() {
      try {
        const res = await axios.post(this.$routes.generate('interview_forms'), {
          interview_form: {
            title: 'New template'
          }
        })

        window.location.href = res.request.responseURL
      } catch (e) {
        console.log('error', e)
      }
    },
  },
  components: {
    InterviewReportTable,
    BktBoxLoader,
    BktNoEntityFromIndex,
    BktCreateEntityFromIndex, GenericIndexSearch, BktButton, BktIndexSkeleton}
}
</script>