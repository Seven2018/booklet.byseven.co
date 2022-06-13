
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
      <interview-template-table></interview-template-table>
<!--      <campaign-table v-show="genericFetchEntity.data && genericFetchEntity.data['campaigns'] && genericFetchEntity.data['campaigns'].length > 0"></campaign-table>-->
<!--      <bkt-create-entity-from-index-->
<!--          v-if="genericFetchEntity.data && genericFetchEntity.data['campaigns'] && genericFetchEntity.data['campaigns'].length === 0 && !genericFetchEntity.search"-->
<!--          type="interview"-->
<!--          :href="$routes.generate('campaign_draft_edit')"-->
<!--      >-->
<!--        campaign-->
<!--      </bkt-create-entity-from-index>-->
<!--      <bkt-no-entity-from-index-->
<!--          v-else-if="genericFetchEntity.data && genericFetchEntity.data['campaigns'] && genericFetchEntity.data['campaigns'].length === 0 && genericFetchEntity.search"-->
<!--      ></bkt-no-entity-from-index>-->
<!--      <bkt-box-loader v-else-if="!genericFetchEntity.data" type="interview"></bkt-box-loader>-->
    </template>
  </bkt-index-skeleton>
</template>
<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import BktButton from "../../../components/BktButton";
import GenericIndexSearch from "../../objectives/users/GenericIndexSearch";
import InterviewTemplateTable from "./InterviewTemplateTable";
import axios from "../../../plugins/axios";
export default {
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
  components: {InterviewTemplateTable, GenericIndexSearch, BktButton, BktIndexSkeleton}
}
</script>