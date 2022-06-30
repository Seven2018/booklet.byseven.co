
<template>
  <div class="width-70 mt-1 mt-sm-5 mx-auto">
    <bkt-switcher
        v-if="genericFetchEntity.data"
        :current-nbr="genericFetchEntity.data.current_campaigns.campaigns.length"
        :archived-nbr="genericFetchEntity.data.archived_campaigns.campaigns.length"
        title="campaigns"
    >
      <template v-slot:current>
        <my-team-interview-card
            v-for="campaign in genericFetchEntity.data.current_campaigns.campaigns"
            :key="campaign.id"
            :campaign="campaign"
            type="current"
        ></my-team-interview-card>
      </template>
      <template v-slot:archived>
        <my-team-interview-card
            v-for="campaign in genericFetchEntity.data.archived_campaigns.campaigns"
            :key="campaign.id"
            :campaign="campaign"
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
  components: {MyTeamInterviewCard, MyInterviewCard, BktSwitcher},
}
</script>