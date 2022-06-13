
<template>
  <div class="d-flex align-items-center">
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
        <p class="font-weight-500 fs-1_2rem bkt-light-grey6 text-truncate">{{ user.job_title }}</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['user']
}
</script>