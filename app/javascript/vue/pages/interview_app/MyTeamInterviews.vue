
<template>
  <div class="width-70 mt-1 mt-sm-5 mx-auto">
    <bkt-switcher
        v-if="genericFetchEntity.data"
        :current-nbr="genericFetchEntity.data.current_campaigns.campaigns.length"
        :archived-nbr="genericFetchEntity.data.archived_campaigns.campaigns.length"
        current-title="Current interviews"
        archived-title="Archived interviews"
        theme="interview"
    >
      <template v-slot:current>
        <my-team-interview-card
            v-for="campaign in genericFetchEntity.data.current_campaigns.campaigns"
            :key="campaign.id"
            :campaign="campaign"
            :manage-link-active="allowManageLink(campaign)"
            type="current"
        ></my-team-interview-card>
      </template>
      <template v-slot:archived>
        <my-team-interview-card
            v-for="campaign in genericFetchEntity.data.archived_campaigns.campaigns"
            :key="campaign.id"
            :campaign="campaign"
            :manage-link-active="allowManageLink(campaign)"
            type="archived"
        ></my-team-interview-card>
      </template>
    </bkt-switcher>
  </div>
</template>

<script>
import BktSwitcher from "../../components/BktSwitcher";
import store from "../../store";
import MyInterviewCard from "./MyInterviewCard";
import MyTeamInterviewCard from "./MyTeamInterviewCard";

export default {
  props: [''],
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  created() {
    store.dispatch('genericFetchEntity/fetch', {pathKey: 'my_team_interviews_list'})
  },
  methods: {
    allowManageLink(campaign) {
      var active = false

      campaign.set_interviews.forEach((set) => {
        const default_interview = set.employee_interview || set.manager_interview
        if (default_interview.interview.interviewer.id === campaign.manager.user.id) {
          active = true
        }
      })

      return active
    }
  },
  components: {MyTeamInterviewCard, MyInterviewCard, BktSwitcher},
}
</script>
