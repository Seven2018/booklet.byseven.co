
<template>
  <div>
    <p class="fs-1_6rem font-weight-600 bkt-light-grey5">{{title}}</p>
    <div
        class="d-flex justify-content-between align-items-start height-4rem bkt-bg-light-grey9-hover"
        @mouseover="hover = true"
        @mouseleave="hover = false"
    >
      <div class="d-flex justify-content-between align-items-start width-20rem height-4rem fs-2_6rem font-weight-500 bkt-dark-grey ">
        <p class="height-4rem fs-2_6rem font-weight-500 bkt-dark-grey mr-1rem flex-grow-1">
          <slot></slot>
        </p>
      </div>
      <div
          class="height-4rem width-3rem d-flex justify-content-center align-items-center bkt-light-grey5 bkt-dark-grey-hover smooth-transition cursor-pointer "
          :class="[hover ? '' : 'opacity_0']"
          @click="$emit('editing')"
      >
        <span class="iconify" data-icon="fa6-solid:pen" data-width="15" data-height="15"></span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['title'],
  data() {
    return {
      hover: false,
    };
  }
}
</script>