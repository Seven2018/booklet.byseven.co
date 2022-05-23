<template>
  <div class="width-100 overflow-x-auto-mobile">
    <div class="height-3_6rem border-bottom-bkt-light-grey mb-4">
      <button
          class="height-3_5rem pb-3 fs-1_6rem"
          :class="[panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-light-grey5', panelCurrentObjective ? 'border-bottom-bkt-objective-blue' : '']"
          @click="togglePanelCurrentObjective"
      >
        Current objectives
        <span
            v-if="currentNbr"
            class="px-2 rounded-5px fs-1_2rem"
            :class="[panelCurrentObjective ? 'bkt-bg-objective-blue2' : 'bkt-bg-light-grey5', panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-white']">
          {{currentNbr}}
        </span>
        <span
            v-else
            class="px-2 rounded-5px fs-1_2rem"
            :class="[panelCurrentObjective ? 'bkt-bg-objective-blue2' : 'bkt-bg-light-grey5', panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-white']">
          0
        </span>
      </button>

      <button
          class="height-3_5rem pb-3 pl-3 fs-1_6rem"
          :class="[!panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-light-grey5', !panelCurrentObjective ? 'border-bottom-bkt-objective-blue' : '']"
          @click="togglePanelCurrentObjective"
      >
        Archived objectives
        <span
            v-if="archivedNbr"
            class="px-2 rounded-5px fs-1_2rem"
            :class="[!panelCurrentObjective ? 'bkt-bg-objective-blue2' : 'bkt-bg-light-grey5', !panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-white']">
          {{archivedNbr}}
        </span>
        <span
            v-else
            class="px-2 rounded-5px fs-1_2rem"
            :class="[!panelCurrentObjective ? 'bkt-bg-objective-blue2' : 'bkt-bg-light-grey5', !panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-white']">
          0
        </span>
      </button>
    </div>

    <slot v-if="panelCurrentObjective" name="current"></slot>
    <slot v-else name="archived"></slot>
  </div>
</template>

<script>
export default {
  props: ['currentNbr', 'archivedNbr'],
  data() {
    return {
      panelCurrentObjective: true,
    }
  },
  methods: {
    togglePanelCurrentObjective() {
      this.panelCurrentObjective = !this.panelCurrentObjective
    }
  },
}
</script>
