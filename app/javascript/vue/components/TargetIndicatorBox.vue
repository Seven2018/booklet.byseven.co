<template>
    <div
        class="flex-column-between-centered m-2 cursor-pointer"
        :class="options.selected ? 'bkt-box-shadow-light border-bkt-objective-blue bkt-objective-blue' : 'border-bkt-light-grey6 bkt-light-grey6'"
        style="height: 175px;"
        @click="$emit('click', options)"
    >
      <span class="iconify mt-3" data-width="40" data-height="40" :data-icon="options.iconify"></span>

      <h2 class="fs-1_6rem font-weight-500">{{ options.title }}</h2>

      <p class="m-3 text-center fs-1_2rem">{{ options.shortDesc }}</p>
    </div>
</template>

<script>
export default {
  props: ['options']
}
</script>