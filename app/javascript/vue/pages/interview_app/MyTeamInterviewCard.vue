<template>
  <div>
    <div v-if="isMobile()"
         class="flex-column-centered bkt-box-shadow-medium rounded-15px mb-5 justify-content-center align-items-center pt-5">
      mobile
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
        <a class="bkt-blue flex-row-start-centered align-items-center bkt-bg-light-grey4-hover p-1rem rounded-5px fs-1_6rem font-weight-600 " :href="$routes.generate('campaigns_id', {id: campaign.id})">
          <p class="d-flex mr-3">Manage campaign</p>
          <span class="iconify" data-icon="akar-icons:chevron-right"></span>
        </a>
      </div>

      <interview-sub-card
          v-for="(item, idx) in campaign.employees_interviews"
          :key="idx"
          :left-user="item.employee"
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
  },
  components: {InterviewSubCard, BktDotsButton}
}
</script>