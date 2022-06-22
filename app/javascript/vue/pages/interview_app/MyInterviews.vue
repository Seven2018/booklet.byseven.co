
<template>
  <div class="width-70 mt-5 mx-auto">
    <bkt-switcher
        v-if="genericFetchEntity.data"
        :current-nbr="genericFetchEntity.data.current_campaigns.campaigns.length"
        :archived-nbr="genericFetchEntity.data.archived_campaigns.campaigns.length"
        title="interviews"
    >
      <template v-slot:current>
        <my-interview-card
            v-for="campaign in genericFetchEntity.data.current_campaigns.campaigns"
            :key="campaign.id"
            :campaign="campaign"
            type="current"
        ></my-interview-card>
      </template>
      <template v-slot:archived>
        <my-interview-card
            v-for="campaign in genericFetchEntity.data.archived_campaigns.campaigns"
            :key="campaign.id"
            :campaign="campaign"
            type="archived"
        ></my-interview-card>
      </template>
    </bkt-switcher>
  </div>
</template>

<script>
import BktBanner from "../../components/BktBanner";
import BktSwitcher from "../../components/BktSwitcher";
import store from "../../store";
import MyInterviewCard from "./MyInterviewCard";

export default {
  props: ['bannerLink'],
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity
    }
  },
  created() {
    store.dispatch('genericFetchEntity/fetch', {pathKey: 'my_interviews_list'})
  },
  components: {MyInterviewCard, BktSwitcher, BktBanner},
}
</script>