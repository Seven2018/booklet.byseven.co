<template>
  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-12 col-sm-5 pos-rel">
        <bkt-back-button
            iconify="iconoir:cancel"
            class="pos-abs" style="right: -25px"></bkt-back-button>

        <new-entity-title>
          Chose a target template
        </new-entity-title>

        <new-target-view-search class="mt-5"></new-target-view-search>

        <div
            v-if="genericFetchEntity.data"
        >
          <div
              class="flex-row-between-centered bkt-box-shadow-medium p-3 mb-4 rounded-5px"
              v-for="row in genericFetchEntity.data['objective/templates']"
              :key="row.id"
              @click="createTargetFromTemplate(row)"
          >
            <div>
              <p class="fs-1_8rem font-weight-500">
                {{ row.title }}
              </p>
            </div>

            <div class="flex-row-end-centered">
              <div class="bkt-bg-light-grey6 mr-3" style="width: 1px; height: 17px"></div>

              <div class="flex-row-between-centered width-25rem">
                <div class="bkt-objective-blue flex-row-between-centered">
                  <span
                      class="iconify mr-2"
                      :data-icon="getIndicatorIconifyName(row.objective_indicator.indicator_type)"
                      data-width="15"
                  ></span>
                  <p v-if="row.objective_indicator.indicator_type == 'numeric_value'">
                    {{ row.objective_indicator.options.target_value }}
                  </p>
                  <p v-else-if="row.objective_indicator.indicator_type == 'boolean'">
                    {{ row.objective_indicator.options.starting_value }}/{{ row.objective_indicator.options.target_value }}
                  </p>
                  <p v-else-if="row.objective_indicator.indicator_type == 'percentage'">
                    {{ row.objective_indicator.options.target_value }}
                  </p>
                  <p v-else-if="row.objective_indicator.indicator_type == 'multi_choice'">
                    {{ filterMultiChoiceCount(row.objective_indicator.options) }}
                  </p>
                </div>

                <span class="iconify" data-width="22" data-height="22" data-icon="bytesize:arrow-right"></span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import BktBackButton from "../../../../components/BktBackButton";
import NewEntityTitle from "../../../../components/NewEntityTitle";
import NewTargetViewSearch from "./NewTargetViewSearch";
import store from "../../../../store";
import tools from "../../../../mixins/tools";

export default {
  mixins: [tools],
  data() {
    return {
      genericFetchEntity: store.state.genericFetchEntity,
    }
  },
  created() {
    store.dispatch('genericFetchEntity/fetch',
        {
          pathKey: 'objective_templates_list'
        }
    )
  },
  methods: {
    createTargetFromTemplate(row) {
    }
  },
  components: {NewTargetViewSearch, NewEntityTitle, BktBackButton}
}
</script>