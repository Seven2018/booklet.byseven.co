
<template>
  <div
      @click="$emit('click')"
      class="rounded-circle bkt-box-shadow-medium p-2 cursor-pointer bkt-bg-light-grey-hover">
    <span class="iconify bkt-dark-grey m-0" data-icon="bi:x" data-width="25" data-height="25"></span>
  </div>
</template>