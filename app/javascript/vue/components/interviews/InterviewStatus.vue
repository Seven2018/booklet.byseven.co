
<template>
  <div class="flex justify-between">
    <p class="mr-4" v-if="campaign.employee_interview">IE <span class="width-1rem height-1rem d-inline-block ml-2"
                                                                :class="campaign.employee_interview.bg"></span></p>
    <p class="mr-4" v-if="campaign.manager_interview">IR <span class="width-1rem height-1rem d-inline-block ml-2"
                                                               :class="campaign.manager_interview.bg"></span></p>
    <p class="mr-4" v-if="campaign.crossed_interview" :class="campaign.crossed_interview.color">CR <span
        class="width-1rem height-1rem d-inline-block ml-2" :class="campaign.crossed_interview.bg"></span></p>
  </div>
</template>
<script>
export default {
  props: ['campaign']
}
</script>