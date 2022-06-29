<template>
  <div class="width-100 overflow-x-auto-mobile">
    <div class="height-3_6rem border-bottom-bkt-light-grey mb-4">
      <button
          class="height-3_5rem pb-3 fs-1rem fs-sm-1_6rem"
          :class="[panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-light-grey5', panelCurrentObjective ? 'border-bottom-bkt-objective-blue' : '']"
          @click="togglePanelCurrentObjective"
      >
        {{currentTitle}}
        <span
            class="px-2 rounded-5px fs-0_8rem fs-sm-1_2rem"
            :class="[panelCurrentObjective ? 'bkt-bg-objective-blue2' : 'bkt-bg-light-grey5', panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-white']">
          {{currentNbr || 0}}
        </span>
      </button>

      <button
          v-if="archivedNbr !== null"
          class="height-3_5rem pb-3 pl-3 fs-1rem fs-sm-1_6rem"
          :class="[!panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-light-grey5', !panelCurrentObjective ? 'border-bottom-bkt-objective-blue' : '']"
          @click="togglePanelCurrentObjective"
      >
        {{archivedTitle}}
        <span
            class="px-2 rounded-5px fs-0_8rem fs-sm-1_2rem"
            :class="[!panelCurrentObjective ? 'bkt-bg-objective-blue2' : 'bkt-bg-light-grey5', !panelCurrentObjective ? 'bkt-objective-blue' : 'bkt-white']">
          {{archivedNbr || 0}}
        </span>
      </button>
    </div>

    <slot v-if="panelCurrentObjective" name="current"></slot>
    <slot v-else name="archived"></slot>
  </div>
</template>

<script>
export default {
  props: {
    currentNbr: {
      type: Number,
      default() {
        return 0
      }
    },
    archivedNbr: {
      type: Number,
      default() {
        return 0;
      }
    },
    currentTitle: {
      type: String,
      default() {
        return 'Current targets'
      }
    },
    archivedTitle: {
      type: String,
      default() {
        return 'Archived targets'
      }
    },
    theme: {
      type: String,
      default() {
        return 'objective'
      }
    }
  },
  data() {
    return {
      panelCurrentObjective: true,
    }
  },
  methods: {
    togglePanelCurrentObjective() {
      if (this.archivedNbr !== null)
        this.panelCurrentObjective = !this.panelCurrentObjective
    }
  },
}
</script>
