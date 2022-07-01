
<template>
  <div class="width-65rem">
    <slider class="mt-4" ref="slider" :options="options">
      <slideritem v-for="(item,index) in someList" :key="index" >
        <component :is="item.component"></component>
      </slideritem>

      <!-- Customizable loading -->
      <div slot="loading">loading...</div>
    </slider>
    <div class="flex-row-between-centered">
      <bkt-button :style="{opacity: myCurrentPage > 0 ? 1 : 0}" iconify="akar-icons:arrow-left" type="white-grey" @click="prev">Back</bkt-button>
      <bkt-button v-if="myCurrentPage === 0" iconify="akar-icons:arrow-right" type="interview" :left="false" @click="next">Next</bkt-button>
      <bkt-button v-else type="interview" @click="$emit('close')">Close</bkt-button>
    </div>
  </div>
</template>

<script>
import { slider, slideritem } from 'vue-concise-slider'
import FirstSlider from './FirstSlider'
import SecondSlider from './SecondSlider'
import BktButton from "../BktButton";


export default {
  props: ['type'],
  data () {
    return {
      someList:[
        {
          component: 'first-slider',
        },
        {
          component: 'second-slider',
        },
      ],
      myCurrentPage: 0,
      //Slider configuration [obj]
      options: {
        currentPage: 0,
        pagination: false
      }
    }
  },
  methods: {
    next() {
      this.$refs.slider.$emit('slideNext')
      this.myCurrentPage++
    },
    prev() {
      this.$refs.slider.$emit('slidePre')
      this.myCurrentPage--
    }
  },
  components: {
    BktButton,
    slider,
    slideritem,
    FirstSlider,
    SecondSlider
  }
}
</script>

<style>
.slider-pagination-bullet {
  /*background-color: #CDCDCD !important;*/
}
.slider-pagination-bullet-active {
  background-color: #3177B7 !important;
}
.slider-wrapper {
  align-items: start !important;
}
</style>