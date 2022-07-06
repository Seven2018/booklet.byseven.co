
<template>
  <bkt-index-skeleton body-class="bkt-bg-white box-shadow-none">
    <template v-slot:title>
      <div v-if="campaign" class="flex-row-around-centered">
        <bkt-button
          :href="overview ? $routes.generate('campaigns') : $routes.generate('my_team_interviews')"
          class="">
          <span class="fs-2_4rem font-weight-500 bkt-dark-grey">
            {{ overview ? 'Campaigns' : 'My team interview'}}
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

    <template v-if="campaign" v-slot:mobile-header>
      <div class="flex-column text-center">
        <p class="fs-1_4rem font-weight-700">
          {{ campaign.title}}
        </p>
        <p class="fs-0_8rem font-weight-600 bkt-light-grey6">
          {{campaign.deadline}}
        </p>
      </div>
    </template>

    <template v-slot:body>
      <bkt-switcher
          :current-nbr="genericFetchEntity.data ? genericFetchEntity.data.set_interviews.length : 0"
          :archived-nbr="null"
          current-title="Participants"
          theme="interview"
      >
        <template v-slot:current>
          <div class="flex-row-between-centered align-items-start pos-rel">
            <campaign-show-search
                v-if="campaign"
                :campaign="campaign"
                :overview="overview"
            ></campaign-show-search>

            <div v-if="overview && !isMobile()"
                 class="flex-row-end-centered width-30rem mt-4 pos-abs"
                 style="top: 0; right: 0;">
              <bkt-dots-button>
                <button
                    class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                    @click="openAddParticipant"
                >
                  + Add participant
                </button>
                <button
                    class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                    @click="openEditDeadline"
                >
                  Edit deadline
                </button>
                <button
                    class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                    @click="sendInvitationToAll(campaignId)"
                >
                  Send invitation to all
                </button>
                <button
                    class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                    @click="sendReminderToAll(campaignId)"
                >
                  Send reminder to all
                </button>
              </bkt-dots-button>
            </div>
          </div>
          <group-category-filter v-if="overview &&!isMobile()" entity-list-key="campaigns_id_data_show" :path-key-args="{id: campaignId}"></group-category-filter>
          <campaign-show-table
              v-show="genericFetchEntity.data && genericFetchEntity.data['set_interviews'] && genericFetchEntity.data['set_interviews'].length > 0"
              :overview="overview"
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
import GroupCategoryFilter from "../../../components/GroupCategoryFilter";
import tools from "../../../mixins/tools";

export default {
  mixins: [tools],
  props: ['campaignId', 'overview'],
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity,
      campaign: null
    }
  },
  created() {
    // store.dispatch('genericFetchEntity/fetch', {
    //   pathKey: 'campaigns_id_data_show',
    //   pathKeyArgs: {id: this.campaignId}
    // })

    this.fetchCampaign()
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
    },
    openEditDeadline() {
      // TODO: refactor
      const campaignId = this.campaign.id
      const self = this

      this.$modal.open({
        type: 'custom',
        componentName: 'pop-up-campaign-edit-deadline',
        closable: false,
        campaignId: campaignId,
        close() {
          self.fetchCampaign()
        }
      })
    },
    async fetchCampaign() {
      this.campaign = (await axios.get(this.$routes.generate('campaigns_id', {id: this.campaignId}) + '.json')).data.campaign
    },
    async sendReminderToAll(campaignId) {
      try {
        const res = await axios.get(this.$routes.generate('send_notification_email',{id: campaignId}), {params: { email_type: 'remind', format: 'json' }})
      } catch (e) {
      }
    },
    async sendInvitationToAll(campaignId) {
      try {
        const res = await axios.get(this.$routes.generate('send_notification_email',{id: campaignId}), {params: { email_type: 'invite', format: 'json' }})
      } catch (e) {
      }
    },
  },
  components: {
    GroupCategoryFilter,
    BktBoxLoader,
    BktNoEntityFromIndex,
    BktCreateEntityFromIndex,
    CampaignShowTable, BktSwitcher, CampaignStatusChip, BktIndexSkeleton, BktButton, CampaignShowSearch, BktDotsButton}
}
</script>
