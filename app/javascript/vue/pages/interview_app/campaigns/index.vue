<template>
  <bkt-index-skeleton body-class="bkt-bg-white">
    <template v-slot:title>Campaigns</template>
    <template v-slot:create-index>
      <bkt-button
          type="interview"
          iconify="ant-design:plus-circle-outlined"
          :href="$routes.generate('campaign_draft_edit')"
      >Create campaign</bkt-button>
    </template>
    <template v-slot:body>
      <campaign-index-search></campaign-index-search>
      <group-category-filter></group-category-filter>
      <campaign-table v-show="genericFetchEntity.data && genericFetchEntity.data['campaigns'] && genericFetchEntity.data['campaigns'].length > 0"></campaign-table>
      <bkt-create-entity-from-index
          v-if="genericFetchEntity.data && genericFetchEntity.data['campaigns'] && genericFetchEntity.data['campaigns'].length === 0 && !genericFetchEntity.search"
          type="interview"
          :href="$routes.generate('campaign_draft_edit')"
      >
        campaign
      </bkt-create-entity-from-index>
      <bkt-no-entity-from-index
          v-else-if="genericFetchEntity.data && genericFetchEntity.data['campaigns'] && genericFetchEntity.data['campaigns'].length === 0 && genericFetchEntity.search"
      ></bkt-no-entity-from-index>
      <bkt-box-loader v-else-if="!genericFetchEntity.data" type="interview"></bkt-box-loader>
    </template>
  </bkt-index-skeleton>
</template>
<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import BktButton from "../../../components/BktButton";
import CampaignIndexSearch from "./CampaignIndexSearch";
import CampaignTable from "./CampaignTable";
import store from "../../../store";
import BktCreateEntityFromIndex from "../../../components/BktCreateEntityFromIndex";
import BktNoEntityFromIndex from "../../../components/BktNoEntityFromIndex";
import BktBoxLoader from "../../../components/BktBoxLoader";
import GroupCategoryFilter from "../../../components/GroupCategoryFilter";

export default {
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  components: {
    GroupCategoryFilter,
    BktBoxLoader,
    BktNoEntityFromIndex,
    BktCreateEntityFromIndex, CampaignTable, BktButton, BktIndexSkeleton, CampaignIndexSearch}
}
</script>