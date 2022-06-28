
<template>
  <bkt-index-skeleton body-class="bkt-bg-white box-shadow-none">
    <template v-slot:title>
      <div v-if="campaign" class="flex-row-around-centered">
        <bkt-button class="">
          <span class="fs-2_4rem font-weight-500 bkt-dark-grey">
            Campaigns
          </span>
        </bkt-button>
        <span class="iconify bkt-light-grey font-weight-600" data-icon="akar-icons:chevron-right" data-width="30" data-height="30"></span>
        <span class="fs-2_4rem font-weight-500 bkt-dark-grey mr-3">
          {{campaign.title}}
        </span>
        <campaign-status-chip :status="campaign.status"></campaign-status-chip>
      </div>
    </template>

    <template v-if="campaign" v-slot:create-index>
        <p class="bkt-dark-grey font-weight-600">Dealine :</p>
        <p class="font-weight-500 bkt-light-grey6">
          {{campaign.deadline | formatDate}}
        </p>
    </template>

    <template v-slot:body>
      <bkt-switcher
          :current-nbr="genericFetchEntity.data ? genericFetchEntity.data.set_interviews.length : 0"
          :archived-nbr="null"
          title="Participants"
      >
        <template v-slot:current>
          <div class="flex-row-between-centered">
            <campaign-show-search
                v-if="campaign"
                :campaign="campaign"
                :overview="overview"
            ></campaign-show-search>

            <div v-if="overview" class="flex-row-end-centered width-30rem">
              <bkt-dots-button>
                <button
                    class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                    @click="openAddParticipant"
                >
                  + Add participant
                </button>
                <button
                    class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                    @click=""
                >
                  Edit deadline
                </button>
                <button
                    class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                    @click=""
                >
                  Send invitation to all
                </button>
                <button
                    class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                    @click=""
                >
                  Send reminder to all
                </button>
              </bkt-dots-button>
            </div>
          </div>
          <campaign-show-table
              v-show="genericFetchEntity.data && genericFetchEntity.data['set_interviews'] && genericFetchEntity.data['set_interviews'].length > 0"
              :campaign="campaign"
          ></campaign-show-table>
          <bkt-no-entity-from-index
              v-if="genericFetchEntity.data && genericFetchEntity.data['set_interviews'] && genericFetchEntity.data['set_interviews'].length === 0 && genericFetchEntity.search"
          ></bkt-no-entity-from-index>
          <bkt-box-loader v-else-if="!genericFetchEntity.data" type="interview"></bkt-box-loader>
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
import BktCreateEntityFromIndex from "../../../components/BktCreateEntityFromIndex";
import BktNoEntityFromIndex from "../../../components/BktNoEntityFromIndex";
import BktBoxLoader from "../../../components/BktBoxLoader";
import axios from "../../../plugins/axios";
import BktDotsButton from "../../../components/BktDotsButton";

export default {
  props: ['campaignId', 'overview'],
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity,
      campaign: null
    }
  },
  async created() {
    store.dispatch('genericFetchEntity/fetch', {
      pathKey: 'campaigns_id_data_show',
      pathKeyArgs: {id: this.campaignId}
    })

    this.campaign = (await axios.get(this.$routes.generate('campaigns_id', {id: this.campaignId}) + '.json')).data.campaign
  },
  methods: {
    openAddParticipant() {
      const campaignId = this.campaign.id

      this.$modal.open({
        type: 'custom',
        componentName: 'pop-up-set-another-interviewee',
        closable: false,
        campaignId: campaignId,
        close() {
          store.dispatch('genericFetchEntity/fetch', {
            pathKey: 'campaigns_id_data_show',
            pathKeyArgs: {id: campaignId}
          })
        }
      })
    }
  },
  components: {
    BktBoxLoader,
    BktNoEntityFromIndex,
    BktCreateEntityFromIndex,
    CampaignShowTable, BktSwitcher, CampaignStatusChip, BktIndexSkeleton, BktButton, CampaignShowSearch, BktDotsButton}
}
</script>
