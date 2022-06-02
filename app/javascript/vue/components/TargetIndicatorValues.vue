<template>
  <div class="container-fluid">
    <div class="row">
      <div
          class="col-12 col-sm-4 p-0"
          v-for="box in getBoxes"
      >
        <target-indicator-box
            :options="box"
            @click="$emit('input', {...value, type: box.type})"
        ></target-indicator-box>
      </div>
    </div>

    <div class="row">
      <div
          class="col-12 flex-column mt-2"
          v-for="box in getBoxes"
          v-if="box.selected"
      >
        <h2 class="fs-1_2rem font-weight-600 bkt-dark-grey mt-2">{{box.title}} :</h2>
        <p class="fs-1_2rem font-weight-500 bkt-light-grey6">{{box.longDesc}}</p>

<!--        for multi-->
        <div
            v-if="box.type === 'multi-choice'"
            class="flex-column mt-2">
          <bkt-input-form
              class="mt-2"
              v-for="multiChoiceValue in value.multiChoiceList"
              placeholder="New option"
              :value="multiChoiceValue"
              @input="updateOption(multiChoiceValue, $event)"
          ></bkt-input-form>
          <bkt-button
              @click="addOption"
              class="mt-3 width-15rem" type="blue">
            Add an option
          </bkt-button>
        </div>
        <div v-else class="flex-row-between-centered mt-2">
<!--          for others-->
          <div class="flex-row-between-centered">
            <span class="iconify bkt-objective-blue" data-icon="lucide:flag"></span>
            <p class="mx-3 fs-1_2rem font-weight-500 bkt-dark-grey ">Starting value</p>
            <bkt-input-form
                class="width-7rem"
                :type="box.type === 'boolean' ? 'text' : 'number'"
                @input="$emit('input', {...value, starting_value: $event})"
            ></bkt-input-form>
          </div>

          <div class="flex-row-between-centered">
            <span class="iconify bkt-objective-blue" data-icon="fluent:target-arrow-20-filled"></span>
            <p class="mx-3 fs-1_2rem font-weight-500 bkt-dark-grey">Target value</p>
            <bkt-input-form
                class="width-7rem"
                :type="box.type === 'boolean' ? 'text' : 'number'"
                @input="$emit('input', {...value, target_value: $event})"
            ></bkt-input-form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import TargetIndicatorBox from "./TargetIndicatorBox";
import BktInputForm from "./BktInputForm";
import BktButton from "./BktButton";

export default {
  props: ['value'],
  // TODO: add input and emit to every field for fit with
  // {
  //   type: 'boolean',
  //   starting_value: null,
  //   target_value: null,
  //   multiChoiceList: null
  // }
  data() {
    return {
      boxes: [
        {
          type: 'boolean',
          iconify: 'ic:outline-toggle-on',
          title: 'True/False',
          shortDesc: 'For non quantifiable objectives, you can chose the value of the two booleans.',
          longDesc: 'Define the two words you want to measure the objective. Word 1 will be the\ndefault value, then you could switch to word 2.',
          selected: false
        },
        {
          type: 'number',
          iconify: 'ic:baseline-numbers',
          title: 'Number',
          shortDesc: 'For quantifiable objectives, chose a value (persons, money, apples, ...), a start and target value.',
          longDesc: 'Define a starting and a target value to measure the objective completion.',
          selected: false
        },
        {
          type: 'percent',
          iconify: 'fa6-solid:percent',
          title: 'Percent',
          shortDesc: 'Useful to measure easily a quantifiable objective.',
          longDesc: 'Use a percentage based value to measure the objective completion.',
          selected: false
        },
        {
          type: 'multi-choice',
          iconify: 'fluent:text-bullet-list-ltr-16-filled',
          title: 'Multi-choice',
          shortDesc: 'For non quantifiable objectives, you can add and edit choices to rate or qualify your objective.',
          longDesc: 'Add options to qualify the objective completion.',
          selected: false
        },
      ],
    }
  },
  computed: {
    getBoxes() {
      return this.boxes.map(box => {
        return {
          ...box, selected: this.value.type === box.type
        }
      })
    }
  },
  methods: {
    addOption() {
      this.value.multiChoiceList.push('')
      this.$emit('input', {...this.value})
    },
    updateOption(option, newOption) {
      for (const key in this.value.multiChoiceList) {
        if (this.value.multiChoiceList[key] === option) {
          this.value.multiChoiceList[key] = newOption
          this.$emit('input', {...this.value})
        }
      }
    }
  },
  components: {BktButton, BktInputForm, TargetIndicatorBox},
}
</script>