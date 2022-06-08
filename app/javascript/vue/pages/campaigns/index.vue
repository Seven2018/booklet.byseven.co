<template>
  <bkt-index-skeleton>
    <template v-slot:title>Target templates</template>
    <template v-slot:create-index>
      <bkt-button
          type="interview"
          iconify="ant-design:plus-circle-outlined"
          :href="$routes.generate('campaign_draft_edit')"
      >Create campaign</bkt-button>
    </template>
    <template v-slot:body>
      <campaign-index-search></campaign-index-search>
      <campaign-table></campaign-table>
<!--      <generic-index-search path-key="objective_templates_list"></generic-index-search>-->
<!--      <target-template-table v-show="genericFetchEntity.data && genericFetchEntity.data['objective/templates'] && genericFetchEntity.data['objective/templates'].length > 0"></target-template-table>-->
<!--      <bkt-create-entity-from-index-->
<!--          v-show="genericFetchEntity.data && genericFetchEntity.data['objective/templates'] && genericFetchEntity.data['objective/templates'].length === 0 && !genericFetchEntity.search"-->
<!--          type="roadmap"-->
<!--          :href="$routes.generate('objective_new')"-->
<!--      >-->
<!--        target employee-->
<!--      </bkt-create-entity-from-index>-->
<!--      <bkt-no-entity-from-index-->
<!--          v-show="genericFetchEntity.data && genericFetchEntity.data['objective/templates'] && genericFetchEntity.data['objective/templates'].length === 0 && genericFetchEntity.search"-->
<!--      ></bkt-no-entity-from-index>-->
<!--      <bkt-box-loader v-show="!genericFetchEntity.data" type="roadmap"></bkt-box-loader>-->
    </template>
  </bkt-index-skeleton>
</template>
<script>
import BktIndexSkeleton from "../../components/BktIndexSkeleton";
import BktButton from "../../components/BktButton";
import CampaignIndexSearch from "./CampaignIndexSearch";
import CampaignTable from "./CampaignTable";

export default {
  components: {CampaignTable, BktButton, BktIndexSkeleton, CampaignIndexSearch}
}
</script>