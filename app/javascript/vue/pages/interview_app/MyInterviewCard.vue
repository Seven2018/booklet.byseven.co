<template>
  <div>
    <div v-if="isMobile()"
         class="flex-column-centered bkt-box-shadow-medium rounded-15px mb-5 justify-content-center align-items-center pt-5">
      <div class="flex-row-center-centered">
          <span class="iconify bkt-blue bkt-bg-light-blue p-2 rounded-5px" data-width="30" data-height="30"
                :data-icon="campaign_icon(campaign.campaign_type)"></span>

        <h1 class="font-weight-600 fs-1rem ml-3">{{ campaign.title }}</h1>
      </div>
      <p class="fs-0_8rem bkt-light-grey">{{ campaign.deadline | formatDate }}</p>
      <user-info-in-table class="mt-4" :user="{...campaign.manager.user, subtitle: 'interviewer'}"></user-info-in-table>

      <p class="fs-1_2rem font-weight-500 flex-row-start-centered mt-4">
        {{ campaign.interview_status_sentence }}
        <span @click="openInfo" class="cursor-pointer">
          <span class="iconify bkt-light-grey ml-3" data-icon="akar-icons:question"></span>
        </span>
      </p>
      <div class="flex justify-between">
        <p class="mr-4">IE <span class="width-1rem height-1rem d-inline-block ml-2"
                                 :class="campaign.employee_interview.bg"></span></p>
        <p class="mr-4">IR <span class="width-1rem height-1rem d-inline-block ml-2"
                                 :class="campaign.manager_interview.bg"></span></p>
        <p class="mr-4" :class="campaign.crossed_interview.color">CR <span
            class="width-1rem height-1rem d-inline-block ml-2" :class="campaign.crossed_interview.bg"></span></p>
      </div>

      <button class="p-4 mt-4 text-center bkt-bg-blue bkt-white width-100 rounded-b-15px fs-1rem font-weight-600">
        {{ myInterviewCampaignButtonSentence(campaign) }}
      </button>
    </div>

    <div v-else class="bkt-box-shadow-medium rounded-15px p-5 mb-5">
      <div class="flex-row-between-centered">
        <div>
          <div class="flex-row-start-centered">
            <div>
              <span class="iconify bkt-blue bkt-bg-light-blue p-2 rounded-5px" data-width="30" data-height="30"
                    :data-icon="campaign_icon(campaign.campaign_type)"></span>
            </div>
            <div class="flex-column ml-3">
              <h1 class="font-weight-600 fs-1_6rem ">{{ campaign.title }}</h1>
              <p class="bkt-light-grey">{{ campaign.deadline | formatDate }}</p>
            </div>
          </div>
        </div>
        <div>
          <bkt-dots-button>
            <button
                class="flex-row-start-centered fs-1_4rem bkt-bg-light-grey10-hover width-100 p-3"
                @click="toggleArchive(campaign.employee_interview.id)"
            >
              <span class="iconify fs-2rem mr-0_5rem" data-icon="fluent:archive-48-regular"></span>
              <span v-if="type === 'current'" class="mr-1">Archive </span>
              <span v-else-if="type === 'archived'" class="mr-1">Unarchive </span>
              interview
            </button>
          </bkt-dots-button>
        </div>
      </div>

      <div class="mt-4 flex-row-between-centered">
        <div class="flex-row-start-centered ">
          <div class="width-30rem border-right-bkt-light-grey">
            <user-info-in-table :user="{...campaign.manager.user, subtitle: 'interviewer'}"></user-info-in-table>
          </div>
          <div class="ml-3">
            <p class="fs-1_2rem font-weight-500 flex-row-start-centered">
              {{ campaign.interview_status_sentence }}
              <span @click="openInfo" class="cursor-pointer">
                <span class="iconify bkt-light-grey ml-3" data-icon="akar-icons:question"></span>
              </span>
            </p>
            <div class="flex justify-between">
              <p class="mr-4">IE <span class="width-1rem height-1rem d-inline-block ml-2"
                                       :class="campaign.employee_interview.bg"></span></p>
              <p class="mr-4">IR <span class="width-1rem height-1rem d-inline-block ml-2"
                                       :class="campaign.manager_interview.bg"></span></p>
              <p class="mr-4" :class="campaign.crossed_interview.color">CR <span
                  class="width-1rem height-1rem d-inline-block ml-2" :class="campaign.crossed_interview.bg"></span></p>
            </div>
          </div>
        </div>

        <div>
          <bkt-button
              iconify="akar-icons:arrow-right"
              :left="false"
              :type="campaign.crossed_interview && campaign.crossed_interview.status === 'submitted' || campaign.employee_interview.status === 'submitted' ? 'white' : 'interview'"
              :href="$routes.generate('interviews_id', {id: campaign.crossed_interview && campaign.crossed_interview.status === 'submitted' ?
              campaign.crossed_interview.id : campaign.employee_interview.id})"
          >
            {{ myInterviewCampaignButtonSentence(campaign) }}
          </bkt-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import tools from "../../mixins/tools";
import BktDotsButton from "../../components/BktDotsButton";
import UserInfoInTable from "../../components/UserInfoInTable";
import BktButton from "../../components/BktButton";
import HTTP from "../../plugins/axios";
import store from "../../store";

export default {
  mixins: [tools],
  props: ['campaign', 'type'],
  methods: {
    async toggleArchive(id) {
      try {
        await HTTP.get(
            '/archive_interview',
            {
              params: {
                id
              }
            }
        )


        await store.dispatch('genericFetchEntity/fetch', {pathKey: 'my_interviews_list'})
      } catch (e) {
        console.log(e)
      }
    },
    openInfo() {
      this.$modal.open({
        type: 'custom',
        componentName: 'pop-up-info-interview-status',
        closable: true,
      })
    }
  },
  components: {BktButton, UserInfoInTable, BktDotsButton}
}
</script>