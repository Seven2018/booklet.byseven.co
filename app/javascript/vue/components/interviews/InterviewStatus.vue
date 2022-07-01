
<template>
  <div :class="isMobile() ? `flex justify-between` : `flex justify-start`">
    <p class="mr-4" v-if="setInterview && setInterview.employee_interview">
      IE <span class="width-1rem height-1rem d-inline-block ml-2"
               :class="getBgByCampaignStatus(setInterview.employee_interview.interview.status)"></span>
    </p>
    <p class="mr-4" v-if="setInterview && setInterview.manager_interview">
      IR <span class="width-1rem height-1rem d-inline-block ml-2"
               :class="getBgByCampaignStatus(setInterview.manager_interview.interview.status)"></span>
    </p>
    <p class="mr-4" v-if="setInterview && setInterview.crossed_interview"
       :class="getColorByCampaignStatus(setInterview.crossed_interview.interview.status)">
      CR <span class="width-1rem height-1rem d-inline-block ml-2"
               :class="getBgByCampaignStatus(setInterview.crossed_interview.interview.status)"></span></p>
  </div>
</template>
<script>
import tools from "../../mixins/tools";

export default {
  mixins: [tools],
  props: ['setInterview']
}
</script>
