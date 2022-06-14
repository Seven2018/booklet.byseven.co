
<template>
  <bkt-index-skeleton body-class="bkt-bg-white">
    <template v-slot:title>Template</template>
    <template v-slot:create-index>
      <bkt-button
          type="interview"
          iconify="ant-design:plus-circle-outlined"
          @click="createInterviewForm"
      >Create campaign</bkt-button>
    </template>
    <template v-slot:body>
      <generic-index-search path-key="interview_forms_list"></generic-index-search>
      <interview-template-table v-show="genericFetchEntity.data && genericFetchEntity.data['interview_forms'] && genericFetchEntity.data['interview_forms'].length > 0"></interview-template-table>
      <bkt-create-entity-from-index
          v-if="genericFetchEntity.data && genericFetchEntity.data['interview_forms'] && genericFetchEntity.data['interview_forms'].length === 0 && !genericFetchEntity.search"
          type="interview"
          @click="createInterviewForm"
      >
        template
      </bkt-create-entity-from-index>
      <bkt-no-entity-from-index
          v-else-if="genericFetchEntity.data && genericFetchEntity.data['interview_forms'] && genericFetchEntity.data['interview_forms'].length === 0 && genericFetchEntity.search"
      ></bkt-no-entity-from-index>
      <bkt-box-loader v-else-if="!genericFetchEntity.data" type="interview"></bkt-box-loader>
    </template>
  </bkt-index-skeleton>
</template>
<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import BktButton from "../../../components/BktButton";
import GenericIndexSearch from "../../objectives/users/GenericIndexSearch";
import InterviewTemplateTable from "./InterviewTemplateTable";
import axios from "../../../plugins/axios";
import store from "../../../store";
import BktCreateEntityFromIndex from "../../../components/BktCreateEntityFromIndex";
import BktNoEntityFromIndex from "../../../components/BktNoEntityFromIndex";
import BktBoxLoader from "../../../components/BktBoxLoader";
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
    BktBoxLoader,
    BktNoEntityFromIndex,
    BktCreateEntityFromIndex, InterviewTemplateTable, GenericIndexSearch, BktButton, BktIndexSkeleton}
}
</script>