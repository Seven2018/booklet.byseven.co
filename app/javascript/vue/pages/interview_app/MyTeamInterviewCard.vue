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
      <div class="border-bottom-bkt-light-grey width-98 my-4" style="height: 1px"></div>

      <div v-for="group_interview in campaign.employees_interviews"
           class="width-100 border-bottom-bkt-light-grey5-not-last-child flex-column-centered justify-content-center align-items-center">
        <user-info-in-table class="mt-4"
                            :user="{...group_interview.employee, subtitle: 'interviewee'}"></user-info-in-table>

        <p class="fs-1_2rem font-weight-500 flex-row-start-centered mt-4 mb-2">
          {{ group_interview.employee_interview.interview.status_sentence }}
          <span @click="openInfo" class="cursor-pointer">
            <span class="iconify bkt-light-grey ml-3" data-icon="akar-icons:question"></span>
          </span>
        </p>

        <interview-status :set-interview="group_interview"></interview-status>

        <bkt-button
            class="my-5 width-95"
            :type="group_interview.crossed_interview && group_interview.crossed_interview.interview.status === 'submitted' || group_interview.manager_interview.interview.status === 'submitted' ? 'white' : 'interview'"
            :href="$routes.generate('interviews_id', {id: group_interview.crossed_interview && group_interview.crossed_interview.interview.status === 'submitted' ?
              group_interview.crossed_interview.interview.id : group_interview.manager_interview.interview.id})"
        >
          {{ myInterviewCampaignButtonSentenceForManager(group_interview) }}
        </bkt-button>
        <bkt-button
            class="mb-5 width-95"
            v-if="group_interview.crossed_interview && group_interview.crossed_interview.interview.status !== 'not_available_yet'"
            :type="group_interview.crossed_interview.interview.status === 'submitted' ? 'white' : 'interview'"
            :href="$routes.generate('interviews_id', {id: group_interview.crossed_interview.interview.id })"
        >
          {{ myInterviewCampaignButtonSentenceForCrossed(group_interview) }}
        </bkt-button>
      </div>
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
                @click="toggleArchive(campaign.id, campaign.manager.user.id)"
            >
              <span class="iconify fs-2rem mr-0_5rem" data-icon="fluent:archive-48-regular"></span>
              <span v-if="type === 'current'" class="mr-1">Archive </span>
              <span v-else-if="type === 'archived'" class="mr-1">Unarchive </span>
              interview
            </button>
          </bkt-dots-button>
        </div>
      </div>

      <div class="flex-row-end-centered">
        <a class="bkt-blue flex-row-start-centered align-items-center bkt-bg-light-grey4-hover p-1rem rounded-5px fs-1_6rem font-weight-600 "
           :href="$routes.generate('campaigns_id', {id: campaign.id})">
          <p class="d-flex mr-3">Manage campaign</p>
          <span class="iconify" data-icon="akar-icons:chevron-right"></span>
        </a>
      </div>

      <interview-sub-card
          v-for="(item, idx) in campaign.set_interviews"
          :key="idx"
          :left-user="item['employee_interview'] ? item['employee_interview'].interview.employee : item['manager_interview'].interview.employee"
          :campaign="campaign"
          :default-interview="item['employee_interview'] || item['manager_interview']"
          :interviews="item"
          user-kind="interviewee"
          class="py-4 border-bottom-bkt-light-grey5-not-last-child"
      ></interview-sub-card>
    </div>
  </div>
</template>

<script>
import BktDotsButton from "../../components/BktDotsButton";
import tools from "../../mixins/tools";
import HTTP from "../../plugins/axios";
import store from "../../store";
import InterviewSubCard from "../../components/interviews/InterviewSubCard";
import InterviewStatus from "../../components/interviews/InterviewStatus";
import UserInfoInTable from "../../components/UserInfoInTable";
import BktButton from "../../components/BktButton";

export default {
  mixins: [tools],
  props: ['campaign', 'type'],
  methods: {
    async toggleArchive(campaign_id, interviewer_id) {
      try {
        await HTTP.get(
            '/archive_interviewer_interviews',
            {
              params: {
                campaign_id,
                interviewer_id
              }
            }
        )


        await store.dispatch('genericFetchEntity/fetch', {pathKey: 'my_team_interviews_list'})
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
  components: {BktButton, UserInfoInTable, InterviewStatus, InterviewSubCard, BktDotsButton}
}
</script>
