
<template>
  <div v-if="user">
    <div class="flex-row-center-centered mt-5 position-relative">
      <img class="rounded-circle width-5rem height-5rem border-bkt-objective-blue-2px"
           :src="user.picture"
           onerror="this.onerror=null;this.src='//i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png'"
           alt="">
    </div>
    <div class="flex-row-center-centered mt-2">
      <h1 class="fs-2_4rem font-weight-500">{{
          `${user.firstname} ${user.lastname}`
        }}</h1>
    </div>
    <div class="flex-row-center-centered mt-2">
      <p class="font-weight-600 fs-1_4rem bkt-light-grey6 ">{{ user.job_title }}</p>
    </div>
  </div>
</template>

<script>
export default {
  props: ['user']
}
</script>