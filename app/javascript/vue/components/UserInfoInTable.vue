
<template>
  <div>
    <div v-if="isMobile()">
      <div class="flex-column-centered ">
        <img class="rounded-circle width-3rem height-3rem"
             :src="user.picture"
             onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
             alt="">
        <p class="font-weight-500 text-truncate">{{ `${user.firstname} ${user.lastname}` }}</p>
        <p class="font-weight-500 fs-1_2rem bkt-light-grey6 text-truncate">{{ user.job_title || user.subtitle }}</p>
      </div>
    </div>
    <div v-else class="d-flex align-items-center">
      <div class="flex-column ">
        <img class="rounded-circle width-3rem height-3rem"
             :src="user.picture"
             onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
             alt="">
      </div>

      <div class="flex-column ml-3 width-25rem ">
        <div class="flex-row-start-centered">
          <p class="font-weight-500 text-truncate">{{ `${user.firstname} ${user.lastname}` }}</p>
        </div>
        <div class="flex-row-start-centered">
          <a v-if="submitted"
             :href="`/interviews/${interviewId}`"
             class="fs-1_2rem font-weight-600 bkt-blue bkt-blue-hover border-bottom-bkt-blue">View interviewee answers</a>
          <p v-else
             class="font-weight-500 fs-1_2rem bkt-light-grey6 text-truncate">{{ user.job_title || user.subtitle }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import tools from "../mixins/tools";

export default {
  mixins: [tools],
  props: ['user', 'submitted', 'interviewId'],
}
</script>
