
<template>
  <div>
    <div class="flex-row-start-centered mt-5">
      <h2 class="flex-row-start-centered align-items-center font-weight-600 fs-1_6rem">
        Filter by tags
        <div
            @click="openInfo"
        >
          <span
              class="iconify ml-3 cursor-pointer"
              data-icon="akar-icons:question"
          ></span>
        </div>
      </h2>
    </div>
    <div class="flex-row-start-centered"></div>
    <div class="flex-row-start-centered"></div>
  </div>
</template>

<script>
export default {
  methods: {
    openInfo() {
      this.$modal.open({
        type: 'custom',
        componentName: 'info-filter-category-tags',
        closable: true,
      })
    }
  }
}
</script>