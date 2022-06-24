
<template>
  <bkt-index-skeleton body-class="bkt-bg-white box-shadow-none">
    <template v-slot:title>
      <div v-if="genericFetchEntity.data" class="flex-row-around-centered">
        <bkt-button class="">
          <span class="fs-2_4rem font-weight-500 bkt-dark-grey">
            Campaigns
          </span>
        </bkt-button>
        <span class="iconify bkt-light-grey font-weight-600" data-icon="akar-icons:chevron-right" data-width="30" data-height="30"></span>
        <span class="fs-2_4rem font-weight-500 bkt-dark-grey mr-3">
          {{genericFetchEntity.data.campaign.campaign.title}}
        </span>
        <campaign-status-chip :status="genericFetchEntity.data.campaign.campaign.status"></campaign-status-chip>
      </div>
    </template>

    <template v-if="genericFetchEntity.data" v-slot:create-index>
      <p class="bkt-dark-grey font-weight-600">Dealine :</p>
      <p class="font-weight-500 bkt-light-grey6">
        {{genericFetchEntity.data.campaign.campaign.deadline | formatDate}}
      </p>
    </template>

    <template v-slot:body>
      <bkt-switcher
          v-if="genericFetchEntity.data"
          :current-nbr="genericFetchEntity.data.set_interviews.length"
          :archived-nbr="null"
          title="Participants"
      >
        <template v-slot:current>
          <campaign-show-search
              :campaign="genericFetchEntity.data.campaign.campaign"
          ></campaign-show-search>
          <campaign-show-table
              :set_interviews="genericFetchEntity.data.set_interviews"
          ></campaign-show-table>
        </template>
      </bkt-switcher>
    </template>
  </bkt-index-skeleton>
</template>

<script>
import BktIndexSkeleton from "../../../components/BktIndexSkeleton";
import BktButton from "../../../components/BktButton";
import store from "../../../store";
import CampaignStatusChip from "../../../components/campaign/CampaignStatusChip";
import BktSwitcher from "../../../components/BktSwitcher";
import CampaignShowTable from "./CampaignShowTable";
import CampaignShowSearch from "./CampaignShowSearch";

export default {
  props: ['campaignId'],
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  created() {
    store.dispatch('genericFetchEntity/fetch', {
      pathKey: 'campaigns_id_data_show',
      pathKeyArgs: {id: this.campaignId}
    })
  },
  components: {CampaignShowTable, BktSwitcher, CampaignStatusChip, BktIndexSkeleton, BktButton, CampaignShowSearch}
}
</script>
